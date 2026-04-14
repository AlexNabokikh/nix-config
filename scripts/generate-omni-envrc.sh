#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
envrc="${repo_root}/.envrc"
out_dir="${repo_root}/.secrets/omni"
gnupg_home="${out_dir}/gnupg"

if [ -f "$envrc" ]; then
  set -a
  # shellcheck disable=SC1090
  . "$envrc"
  set +a
fi

OMNI_ENDPOINT="${OMNI_ENDPOINT:-omni.krapulax.dev}"
OMNI_AUTH_ENDPOINT="${OMNI_AUTH_ENDPOINT:-auth.krapulax.dev}"
OMNI_ADVERTISED_API_URL="${OMNI_ADVERTISED_API_URL:-https://${OMNI_ENDPOINT}/}"
OMNI_AUTH_PROVIDER_URL="${OMNI_AUTH_PROVIDER_URL:-https://${OMNI_AUTH_ENDPOINT}}"
OMNI_MACHINE_API_BIND_ADDR="${OMNI_MACHINE_API_BIND_ADDR:-0.0.0.0:8095}"
OMNI_MACHINE_API_ADVERTISED_URL="${OMNI_MACHINE_API_ADVERTISED_URL:-https://${OMNI_ENDPOINT}:8095/}"
OMNI_ACCOUNT_ID="${OMNI_ACCOUNT_ID:-}"
OMNI_USER_EMAIL="${OMNI_USER_EMAIL:-admin@krapulax.dev}"
OMNI_SIDEROLINK_WIREGUARD_ADVERTISED_ADDR="${OMNI_SIDEROLINK_WIREGUARD_ADVERTISED_ADDR:-10.0.40.61:50180}"
OMNI_DEX_USERNAME="${OMNI_DEX_USERNAME:-admin}"

wireguard_host="${OMNI_SIDEROLINK_WIREGUARD_ADVERTISED_ADDR%:*}"

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    printf 'Missing required command: %s\n' "$1" >&2
    exit 1
  fi
}

shell_quote() {
  printf "'"
  printf '%s' "$1" | sed "s/'/'\\\\''/g"
  printf "'"
}

prompt_password() {
  if [ -n "${OMNI_ADMIN_PASSWORD:-}" ]; then
    printf '%s' "$OMNI_ADMIN_PASSWORD"
    return
  fi

  if [ ! -t 0 ]; then
    printf 'OMNI_ADMIN_PASSWORD is not set and no TTY is available for prompting.\n' >&2
    exit 1
  fi

  local first second
  read -r -s -p "Omni admin password: " first
  printf '\n'
  read -r -s -p "Confirm Omni admin password: " second
  printf '\n'

  if [ "$first" != "$second" ]; then
    printf 'Passwords did not match.\n' >&2
    exit 1
  fi

  if [ -z "$first" ]; then
    printf 'Password cannot be empty.\n' >&2
    exit 1
  fi

  printf '%s' "$first"
}

generate_password_hash() {
  local password="$1"

  if command -v htpasswd >/dev/null 2>&1; then
    htpasswd -bnBC 10 "" "$password" | tr -d ':\n'
    return
  fi

  if command -v docker >/dev/null 2>&1; then
    docker run --rm httpd:2.4-alpine htpasswd -bnBC 10 "" "$password" | tr -d ':\n'
    return
  fi

  printf 'Need htpasswd or docker to generate OMNI_DEX_PASSWORD_HASH.\n' >&2
  exit 1
}

write_cert_config() {
  local san_file="$1"
  cat >"$san_file" <<EOF
[req]
default_bits = 4096
prompt = no
default_md = sha256
distinguished_name = dn
req_extensions = san

[dn]
C = GB
O = Home Infrastructure
OU = Omni
CN = ${OMNI_ENDPOINT}

[san]
subjectAltName = @alt_names

[alt_names]
DNS.1 = ${OMNI_ENDPOINT}
DNS.2 = ${OMNI_AUTH_ENDPOINT}
IP.1 = 127.0.0.1
EOF

  if [[ "$wireguard_host" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    printf 'IP.2 = %s\n' "$wireguard_host" >>"$san_file"
  else
    printf 'DNS.3 = %s\n' "$wireguard_host" >>"$san_file"
  fi
}

emit_scalar_export() {
  local name="$1" value="$2"
  printf "export %s=%s\n" "$name" "$(shell_quote "$value")"
}

emit_multiline_export() {
  local name="$1" path="$2"
  printf 'export %s="$(cat <<'\''EOF_%s'\''\n' "$name" "$name"
  cat "$path"
  printf '\nEOF_%s\n)"\n' "$name"
}

update_envrc() {
  local block_file="$1"
  local start="# >>> omni generated secrets >>>"
  local end="# <<< omni generated secrets <<<"
  local tmp
  tmp="$(mktemp)"

  if [ -f "$envrc" ]; then
    awk -v start="$start" -v end="$end" '
      $0 == start {skip = 1; next}
      $0 == end {skip = 0; next}
      skip != 1 {print}
    ' "$envrc" >"$tmp"
  fi

  {
    cat "$tmp"
    printf '\n%s\n' "$start"
    cat "$block_file"
    printf '%s\n' "$end"
  } >"$envrc"

  rm -f "$tmp"
}

require_cmd openssl
require_cmd gpg

mkdir -p "$out_dir"
chmod 700 "$out_dir"

printf 'Generating Omni certs in %s\n' "$out_dir"

openssl genrsa -out "${out_dir}/ca-key.pem" 4096
openssl req \
  -x509 \
  -new \
  -nodes \
  -key "${out_dir}/ca-key.pem" \
  -sha256 \
  -days 3650 \
  -out "${out_dir}/ca.pem" \
  -subj "/C=GB/O=Home Infrastructure/OU=Omni/CN=Internal Root CA"

write_cert_config "${out_dir}/server-openssl.cnf"
openssl genrsa -out "${out_dir}/server-key.pem" 4096
openssl req \
  -new \
  -key "${out_dir}/server-key.pem" \
  -out "${out_dir}/server.csr" \
  -config "${out_dir}/server-openssl.cnf"
openssl x509 \
  -req \
  -in "${out_dir}/server.csr" \
  -CA "${out_dir}/ca.pem" \
  -CAkey "${out_dir}/ca-key.pem" \
  -CAcreateserial \
  -out "${out_dir}/server.pem" \
  -days 825 \
  -sha256 \
  -extfile "${out_dir}/server-openssl.cnf" \
  -extensions san

printf 'Generating Omni GPG key\n'
rm -rf "$gnupg_home"
mkdir -p "$gnupg_home"
chmod 700 "$gnupg_home"
cat >"${out_dir}/gpg-batch" <<'EOF'
Key-Type: RSA
Key-Length: 4096
Name-Real: Omni
Name-Comment: Used for etcd data encryption
Name-Email: omni@internal.local
Expire-Date: 0
%no-protection
%commit
EOF
gpg --homedir "$gnupg_home" --batch --generate-key "${out_dir}/gpg-batch"
gpg --homedir "$gnupg_home" --armor --export-secret-keys omni@internal.local >"${out_dir}/omni.asc"

OMNI_DEX_CLIENT_SECRET="$(openssl rand -hex 32)"
admin_password="$(prompt_password)"
OMNI_DEX_PASSWORD_HASH="$(generate_password_hash "$admin_password")"

block_file="$(mktemp)"
trap 'rm -f "$block_file"' EXIT

{
  printf '# Generated by scripts/generate-omni-envrc.sh. Do not edit this block by hand.\n'
  emit_scalar_export "OMNI_ENDPOINT" "$OMNI_ENDPOINT"
  emit_scalar_export "OMNI_AUTH_ENDPOINT" "$OMNI_AUTH_ENDPOINT"
  emit_scalar_export "OMNI_ADVERTISED_API_URL" "$OMNI_ADVERTISED_API_URL"
  emit_scalar_export "OMNI_AUTH_PROVIDER_URL" "$OMNI_AUTH_PROVIDER_URL"
  emit_scalar_export "OMNI_MACHINE_API_BIND_ADDR" "$OMNI_MACHINE_API_BIND_ADDR"
  emit_scalar_export "OMNI_MACHINE_API_ADVERTISED_URL" "$OMNI_MACHINE_API_ADVERTISED_URL"
  emit_scalar_export "OMNI_ACCOUNT_ID" "$OMNI_ACCOUNT_ID"
  emit_scalar_export "OMNI_USER_EMAIL" "$OMNI_USER_EMAIL"
  emit_scalar_export "OMNI_SIDEROLINK_WIREGUARD_ADVERTISED_ADDR" "$OMNI_SIDEROLINK_WIREGUARD_ADVERTISED_ADDR"
  emit_scalar_export "OMNI_DEX_USERNAME" "$OMNI_DEX_USERNAME"
  emit_scalar_export "OMNI_DEX_CLIENT_SECRET" "$OMNI_DEX_CLIENT_SECRET"
  emit_scalar_export "OMNI_DEX_PASSWORD_HASH" "$OMNI_DEX_PASSWORD_HASH"
  emit_multiline_export "OMNI_CA_CERT_PEM" "${out_dir}/ca.pem"
  emit_multiline_export "OMNI_TLS_CERT_PEM" "${out_dir}/server.pem"
  emit_multiline_export "OMNI_TLS_KEY_PEM" "${out_dir}/server-key.pem"
  emit_multiline_export "OMNI_GPG_KEY_ASC" "${out_dir}/omni.asc"
} >"$block_file"

cp "$envrc" "${envrc}.bak.$(date +%Y%m%d%H%M%S)" 2>/dev/null || true
update_envrc "$block_file"

chmod 600 \
  "${out_dir}/ca-key.pem" \
  "${out_dir}/server-key.pem" \
  "${out_dir}/omni.asc"

printf 'Updated %s\n' "$envrc"
printf 'Generated local secret files under %s\n' "$out_dir"
printf 'Run: direnv allow && just vm-switch trinity\n'
