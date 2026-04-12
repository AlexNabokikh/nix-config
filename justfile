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

# Run OpenTofu/Terraform config from the infra directory, for example: just tf init; just tf plan
tf *args:
    tofu -chdir=infra {{args}}

# ============================================================================
# Management VM NixOS Bootstrap
# ============================================================================

# Build all NixOS installer ISOs
vm-build:
    #!/usr/bin/env bash
    set -euo pipefail
    rm -rf result-iso
    mkdir -p result-iso
    
    # Build all installer ISOs
    installers=("trinity-installer" "morpheus-installer")
    system="{{system}}"
    
    if [ "$system" = "Darwin" ]; then
      docker_volume="nix-store-darwin"
      for installer in "${installers[@]}"; do
        docker run --rm --platform linux/amd64 \
          --security-opt seccomp=unconfined \
          -v "$docker_volume":/nix \
          -v "$PWD:/work" \
          -w /work \
          nixos/nix:latest \
          sh -euc "out=\$(nix --extra-experimental-features 'nix-command flakes' --option filter-syscalls false build --print-out-paths .#nixosConfigurations.${installer}.config.system.build.isoImage); cp -L \"\$out\"/iso/*.iso /work/result-iso/"
      done
    else
      for installer in "${installers[@]}"; do
        out=$(nix build --print-out-paths .#nixosConfigurations.${installer}.config.system.build.isoImage)
        cp -L "$out"/iso/*.iso result-iso/
      done
    fi
    
    echo "Built ISOs:"
    ls -lh result-iso/

# Upload NixOS installer ISOs to Proxmox
vm-upload node="pve-2" storage="nfs-proxmox-iso": vm-build
    #!/usr/bin/env bash
    set -euo pipefail

    get_tfvar() {
      awk -v name="$1" -F'"' '$0 ~ "^[[:space:]]*" name "[[:space:]]*=" { value=$2 } END { print value }' \
        infra/proxmox.auto.tfvars infra/secrets.auto.tfvars
    }

    endpoint="$(get_tfvar proxmox_endpoint)"
    insecure="$(awk '/^[[:space:]]*proxmox_insecure[[:space:]]*=/{ value=$3 } END { print value }' infra/proxmox.auto.tfvars infra/secrets.auto.tfvars)"
    token_id="$(get_tfvar proxmox_token_id)"
    token_secret="$(get_tfvar proxmox_token_secret)"

    if [ -z "$endpoint" ] || [ -z "{{node}}" ] || [ -z "$token_id" ] || [ -z "$token_secret" ]; then
      echo "Missing Proxmox endpoint, node, token ID, or token secret in infra/*.tfvars" >&2
      exit 1
    fi

    curl_args=(--fail --silent --show-error)
    if [ "$insecure" = "true" ]; then
      curl_args+=(--insecure)
    fi

    auth_header="Authorization: PVEAPIToken=${token_id}=${token_secret}"

    # Upload all ISOs from result-iso
    for iso_path in result-iso/*.iso; do
      if [ -f "$iso_path" ]; then
        iso_name=$(basename "$iso_path")
        volume="{{storage}}:iso/${iso_name}"
        encoded_volume="$(python3 -c 'import sys, urllib.parse; print(urllib.parse.quote(sys.argv[1], safe=""))' "$volume")"

        # Delete old ISO if it exists
        curl "${curl_args[@]}" \
          -X DELETE \
          -H "$auth_header" \
          "$endpoint/api2/json/nodes/{{node}}/storage/{{storage}}/content/$encoded_volume" >/dev/null || true

        # Upload new ISO
        curl "${curl_args[@]}" \
          -H "$auth_header" \
          -F "content=iso" \
          -F "filename=@${iso_path};filename=${iso_name}" \
          "$endpoint/api2/json/nodes/{{node}}/storage/{{storage}}/upload" >/dev/null

        echo "✅ Uploaded ${iso_path} to {{node}}/{{storage}}:iso/${iso_name}"
      fi
    done

# Full deploy: build ISOs, upload, create VMs, and install NixOS
vm-deploy node="pve-2" storage="nfs-proxmox-iso":
    just vm-upload {{node}} {{storage}}
    just tf apply -refresh=false -auto-approve

# Manually run nixos-anywhere (for emergency re-installs)
vm-install hostname="trinity" target="root@10.0.40.100" identity="~/.ssh/id_macbook_fs":
    nix run github:nix-community/nixos-anywhere -- --flake .#{{hostname}} -i {{identity}} --phases disko,install,reboot --ssh-option StrictHostKeyChecking=no --ssh-option UserKnownHostsFile=/dev/null {{target}}

# Switch NixOS config on a VM (after deployment)
vm-switch hostname="trinity" target="fs@10.0.40.100":
    nix run nixpkgs#nixos-rebuild -- switch --flake .#{{hostname}} --target-host {{target}} --build-host {{target}} --sudo --no-reexec

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
