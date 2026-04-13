# Justfile for Nix Darwin and Home Manager system management

# Determine the hostname dynamically
hostname := `hostname`
system := `uname -s`

# Default recipe: Shows available commands
default:
    @just --list

# ============================================================================
# Quick Update Commands
# ============================================================================

# Quick system and home update dynamically (update + darwin + home)
quick-update: update darwin-switch home-switch

# Quick system and home update for macvm-fs
quick-update-macvm-fs: update darwin-switch-macvm-fs home-switch-macvm-fs

# ============================================================================
# Flake Management
# ============================================================================

# Update flake inputs
update:
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    @echo "📦 Updating flake inputs..."
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    doppler run -- nix flake update

# Verify flake configuration
verify-flake:
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    @echo "✅ Verifying flake configuration..."
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    doppler run -- nix flake check

# Open nix repl with current flake
repl:
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    @echo "🔍 Opening Nix REPL..."
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    doppler run -- nix repl .#

# ============================================================================
# Terraform Infrastructure
# ============================================================================

# Run Terraform config from the infra directory, for example: just tf init; just tf plan
tf *args:
    TMPDIR=/tmp terraform -chdir=infra {{args}}

# Initialize Terraform providers
tf-init:
    just tf init

# Upgrade Terraform providers and refresh the lockfile
tf-upgrade:
    just tf init -upgrade

# Validate Terraform configuration
tf-validate:
    just tf validate

# Plan VM infrastructure changes
vm-plan: vm-build
    just tf plan -parallelism=1

# ============================================================================
# Proxmox NixOS VMs
# ============================================================================

# Build the NixOS cloud image used by Terraform
vm-build:
    #!/usr/bin/env bash
    set -euo pipefail
    rm -rf result-cloud
    mkdir -p result-cloud
    
    system="{{system}}"
    
    if [ "$system" = "Darwin" ]; then
      docker_volume="nix-store-darwin"
      docker run --rm --platform linux/amd64 \
        --security-opt seccomp=unconfined \
        -v "$docker_volume":/nix \
        -v "$PWD:/work" \
        -w /work \
        nixos/nix:latest \
        sh -euc "out=\$(nix --extra-experimental-features 'nix-command flakes' --option filter-syscalls false --option system-features kvm build --print-out-paths .#nixosConfigurations.vm-cloud-image.config.system.build.image); cp -L \"\$out\"/*.qcow2 /work/result-cloud/nixos-proxmox-cloud.qcow2"
    else
      out=$(nix build --print-out-paths .#nixosConfigurations.vm-cloud-image.config.system.build.image)
      cp -L "$out"/*.qcow2 result-cloud/nixos-proxmox-cloud.qcow2
    fi
    
    echo "Built cloud image:"
    ls -lh result-cloud/nixos-proxmox-cloud.qcow2

# Create/update Proxmox VMs and upload the cloud image through Terraform
vm-apply: vm-build
    just tf apply -parallelism=1 -auto-approve

# Recreate the managed VMs from the cloud image
vm-recreate: vm-build
    TMPDIR=/tmp terraform -chdir=infra apply -parallelism=1 -auto-approve -replace='proxmox_virtual_environment_vm.vm["trinity"]' -replace='proxmox_virtual_environment_vm.vm["morpheus"]'

# Recreate VMs, then apply NixOS configs
vm-redeploy: vm-recreate
    just vm-wait trinity
    just vm-wait morpheus
    just vm-switch-all

# Wait for SSH on a VM declared in Terraform
vm-wait hostname="trinity" identity="~/.ssh/id_macbook_fs":
    #!/usr/bin/env bash
    set -euo pipefail
    target=$(TMPDIR=/tmp terraform -chdir=infra output -json ssh_targets | jq -r --arg hostname "{{hostname}}" '.[$hostname].target // empty')
    if [ -z "$target" ] || [ "$target" = "DHCP_PENDING" ]; then
      echo "No static SSH target found for {{hostname}} in Terraform output" >&2
      exit 1
    fi

    echo "Waiting for ${target}..."
    for i in {1..60}; do
      if ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i {{identity}} "$target" "echo ok" >/dev/null 2>&1; then
        echo "${target} is reachable"
        exit 0
      fi
      echo "Waiting for SSH... attempt $i/60"
      sleep 10
    done
    echo "${target} did not become reachable in time" >&2
    exit 1

# Switch NixOS config on a VM
vm-switch hostname="trinity":
    #!/usr/bin/env bash
    set -euo pipefail
    target=$(TMPDIR=/tmp terraform -chdir=infra output -json ssh_targets | jq -r --arg hostname "{{hostname}}" '.[$hostname].target // empty')
    if [ -z "$target" ] || [ "$target" = "DHCP_PENDING" ]; then
      echo "No static SSH target found for {{hostname}} in Terraform output" >&2
      exit 1
    fi
    export NIX_SSHOPTS="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
    if [ -z "${CLOUDFLARED_TUNNEL_TOKEN:-}" ] && [ -f .envrc ]; then
      set -a
      . ./.envrc
      set +a
    fi
    if [ -z "${CLOUDFLARED_TUNNEL_TOKEN:-}" ]; then
      echo "CLOUDFLARED_TUNNEL_TOKEN is not set; load direnv or define it before running vm-switch" >&2
      exit 1
    fi
    secret_file=$(mktemp)
    config_file=$(mktemp)
    trap 'rm -f "$secret_file" "$config_file"' EXIT
    printf '%s\n' "$CLOUDFLARED_TUNNEL_TOKEN" > "$secret_file"
    if jq -e 'type == "object" and has("AccountTag") and has("TunnelSecret") and has("TunnelID")' "$secret_file" >/dev/null 2>&1; then
      tunnel_id=$(jq -r '.TunnelID' "$secret_file")
      printf '%s\n' \
        "tunnel: $tunnel_id" \
        "credentials-file: /etc/cloudflared/credentials.json" \
        "ingress:" \
        "  - service: http://127.0.0.1:80" \
        > "$config_file"
      scp $NIX_SSHOPTS "$secret_file" "$target:/tmp/cloudflared-credentials.json" >/dev/null 2>&1
      scp $NIX_SSHOPTS "$config_file" "$target:/tmp/cloudflared-config.yml" >/dev/null 2>&1
      ssh $NIX_SSHOPTS "$target" "sudo install -d -m 0700 /run/secrets/cloudflared && sudo install -m 0600 /tmp/cloudflared-credentials.json /run/secrets/cloudflared/credentials.json && sudo install -m 0600 /tmp/cloudflared-config.yml /run/secrets/cloudflared/config.yml && sudo rm -f /run/secrets/cloudflared/token /tmp/cloudflared-credentials.json /tmp/cloudflared-config.yml"
    else
      printf '%s\n' \
        "ingress:" \
        "  - service: http://127.0.0.1:80" \
        > "$config_file"
      scp $NIX_SSHOPTS "$secret_file" "$target:/tmp/cloudflared-token" >/dev/null 2>&1
      scp $NIX_SSHOPTS "$config_file" "$target:/tmp/cloudflared-config.yml" >/dev/null 2>&1
      ssh $NIX_SSHOPTS "$target" "sudo install -d -m 0700 /run/secrets/cloudflared && sudo install -m 0600 /tmp/cloudflared-token /run/secrets/cloudflared/token && sudo install -m 0600 /tmp/cloudflared-config.yml /run/secrets/cloudflared/config.yml && sudo rm -f /run/secrets/cloudflared/credentials.json /tmp/cloudflared-token /tmp/cloudflared-config.yml"
    fi
    nix run nixpkgs#nixos-rebuild -- switch --flake .#{{hostname}} --target-host "$target" --build-host "$target" --sudo --no-reexec

# Switch all deployed NixOS VMs
vm-switch-all:
    just vm-switch trinity
    just vm-switch morpheus

# Full VM deploy: build image, let Terraform create/update cloud-init VMs, then apply NixOS configs
vm-deploy: vm-apply
    just vm-wait trinity
    just vm-wait morpheus
    just vm-switch-all

# Switch Nix Darwin configuration for neo
darwin-switch-neo:
    @echo ""
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    @echo "🔄 Switching Nix Darwin configuration for neo..."
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    doppler run -- sudo nix run nix-darwin -- switch --flake .#neo

# Switch Home Manager configuration for neo
home-switch-neo:
    @echo ""
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    @echo "🏠 Switching Home Manager configuration for fs@neo..."
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    doppler run -- home-manager switch --flake .#fs@neo

# ============================================================================
# Darwin (macOS System) Management
# ============================================================================

# Switch Nix Darwin configuration dynamically
darwin-switch:
    @echo ""
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    @echo "🔄 Switching Nix Darwin configuration for {{hostname}}..."
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    doppler run -- sudo nix run nix-darwin -- switch --flake .#{{hostname}}

# Switch Nix Darwin configuration for macvm-fs
darwin-switch-macvm-fs:
    @echo ""
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    @echo "🔄 Switching Nix Darwin configuration for macvm-fs..."
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    doppler run -- sudo nix run nix-darwin -- switch --flake .#macvm-fs

# Build Darwin configuration dynamically without switching
darwin-build:
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    @echo "🔨 Building Nix Darwin configuration for {{hostname}}..."
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    doppler run -- nix run nix-darwin -- build --flake .#{{hostname}}

# Build Darwin configuration for macvm-fs without switching
darwin-build-macvm-fs:
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    @echo "🔨 Building Nix Darwin configuration for macvm-fs..."
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    doppler run -- nix run nix-darwin -- build --flake .#macvm-fs

# ============================================================================
# Home Manager (User Environment) Management
# ============================================================================

# Switch Home Manager configuration dynamically
home-switch:
    @echo ""
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    @echo "🏠 Switching Home Manager configuration for fs@{{hostname}}..."
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    doppler run -- home-manager switch --flake .#fs@{{hostname}}

# Switch Home Manager configuration for macvm-fs
home-switch-macvm-fs:
    @echo ""
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    @echo "🏠 Switching Home Manager configuration for fs@macvm-fs..."
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    doppler run -- home-manager switch --flake .#fs@macvm-fs

# Build Home Manager configuration dynamically without switching
home-build:
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    @echo "🔨 Building Home Manager configuration for fs@{{hostname}}..."
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    doppler run -- home-manager build --flake .#fs@{{hostname}}

# Build Home Manager configuration for macvm-fs without switching
home-build-macvm-fs:
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    @echo "🔨 Building Home Manager configuration for fs@macvm-fs..."
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    doppler run -- home-manager build --flake .#fs@macvm-fs

# ============================================================================
# System Information
# ============================================================================

# Show current system and home manager configurations
show-config:
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    @echo "📋 Showing current configurations..."
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    @echo ""
    @echo "=== System Information ==="
    @echo "Hostname: {{hostname}}"
    @echo "Darwin Configuration: .#{{hostname}}"
    @echo "Home Manager Configuration: .#fs@{{hostname}}"
    @echo ""
    @echo "=== Darwin System Generations ==="
    @nix profile history --profile /nix/var/nix/profiles/system 2>/dev/null | tail -n 10 || echo "Unable to read Darwin generations"
    @echo ""
    @echo "=== Current System Link ==="
    @ls -l /run/current-system 2>/dev/null || echo "Not available"
    @echo ""
    @echo "=== Home Manager Generations (Last 5) ==="
    @home-manager generations | head -n 5

# ============================================================================
# Maintenance & Cleanup
# ============================================================================

# Cleanup Nix store and old generations
clean:
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    @echo "🧹 Cleaning up Nix store and old generations..."
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    doppler run -- nix-collect-garbage -d
    doppler run -- home-manager expire-generations "-7 days"

# ============================================================================
# Code Quality & Formatting
# ============================================================================

# Format all Nix files
fmt:
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    @echo "✨ Formatting Nix files..."
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    doppler run -- nix fmt -- .

# Run statix linter (warnings only)
lint:
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    @echo "🔍 Running statix linter..."
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    doppler run -- nix develop --command statix check .

# Fix statix issues automatically
lint-fix:
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    @echo "🔧 Fixing statix issues..."
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    doppler run -- nix develop --command statix fix .

# Run deadnix to find unused code
deadnix:
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    @echo "🔍 Checking for unused Nix code..."
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    doppler run -- nix develop --command deadnix .

# Fix deadnix issues automatically (removes unused code)
deadnix-fix:
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    @echo "🔧 Removing unused Nix code..."
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    doppler run -- nix develop --command deadnix --edit .

# ============================================================================
# Pre-commit Hooks
# ============================================================================

# Install pre-commit hooks
install-hooks:
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    @echo "🪝 Installing pre-commit hooks..."
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    doppler run -- nix develop --command pre-commit install

# Run pre-commit on all files
run-hooks:
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    @echo "🪝 Running pre-commit hooks on all files..."
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    doppler run -- nix develop --command pre-commit run --all-files

# Run pre-commit checks
check-pre-commit:
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    @echo "✅ Running pre-commit checks..."
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    doppler run -- nix flake check
