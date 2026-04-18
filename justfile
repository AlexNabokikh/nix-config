# Justfile for Nix Darwin and Home Manager system management

# Determine the hostname dynamically
hostname := `hostname`
system := `uname -s`
enabled_darwin_hosts := "neo"
enabled_vm_hosts := "trinity"
enabled_nixos_hosts := "morpheus"

# Default recipe: Shows available commands
default:
    @just --list

# Print a colored section banner for long-running recipes.
_banner color lane target action:
    @printf '\n\033[1;{{color}}m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m\n'
    @printf '\033[1;{{color}}m%s :: %s\033[0m\n' "{{lane}}" "{{target}}"
    @printf '\033[{{color}}m%s\033[0m\n' "{{action}}"
    @printf '\033[1;{{color}}m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m\n'

# ============================================================================
# Quick Update Commands
# ============================================================================

# Update flake inputs, then switch every enabled deployment lane.
quick-update: update darwin-switch nixos-switch vm-switch

# Update flake inputs, then switch one enabled deployment lane.
quick-update-lane lane:
    #!/usr/bin/env bash
    set -euo pipefail
    case "{{lane}}" in
      darwin)
        just update
        just darwin-switch
        ;;
      nixos)
        just update
        just nixos-switch
        ;;
      vm)
        just update
        just vm-switch
        ;;
      *)
        echo "Unknown lane '{{lane}}'. Expected one of: darwin, nixos, vm" >&2
        exit 1
        ;;
    esac

# ============================================================================
# Flake Management
# ============================================================================

# Update flake inputs
update:
    @just _banner 33 flake inputs "Updating flake inputs"
    doppler run -- nix flake update

# Verify flake configuration
verify-flake:
    @just _banner 33 flake check "Verifying flake configuration"
    doppler run -- nix flake check

# Open nix repl with current flake
repl:
    @just _banner 33 flake repl "Opening Nix REPL"
    doppler run -- nix repl .#

# ============================================================================
# Terraform Infrastructure
# ============================================================================

# Run Terraform config from the infra directory, for example: just tf init; just tf plan
tf *args:
    @TMPDIR=/tmp doppler run --name-transformer tf-var -- terraform -chdir=infra {{args}}

# Initialize Terraform providers
tf-init:
    just tf init

# Upgrade Terraform providers and refresh the lockfile
tf-upgrade:
    just tf init -upgrade

# Validate Terraform configuration
tf-validate:
    just tf validate

# ============================================================================
# Proxmox NixOS VMs
# ============================================================================

# Plan VM infrastructure changes after building the shared cloud image.
vm-plan: vm-build
    just tf plan -parallelism=1

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

# Recreate one Terraform-managed VM from the cloud image.
vm-recreate hostname="trinity": vm-build
    just tf apply -parallelism=1 -auto-approve -replace='proxmox_virtual_environment_vm.vm["{{hostname}}"]'

# Recreate VMs, then apply NixOS configs
vm-redeploy: vm-recreate
    just vm-wait trinity
    just vm-switch

# Wait for SSH on a VM declared in Terraform
vm-wait hostname="trinity" identity="~/.ssh/id_macbook_fs":
    #!/usr/bin/env bash
    set -euo pipefail
    target=$(just tf output -json ssh_targets | jq -r --arg hostname "{{hostname}}" '.[$hostname].target // empty')
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

# Switch NixOS config on all enabled VMs, or pass a hostname to switch one VM.
vm-switch hostname="all":
    #!/usr/bin/env bash
    set -euo pipefail
    if [ "{{hostname}}" = "all" ]; then
      for host in {{enabled_vm_hosts}}; do
        just vm-switch "$host"
      done
      exit 0
    fi
    target=$(just tf output -json ssh_targets | jq -r --arg hostname "{{hostname}}" '.[$hostname].target // empty')
    if [ -z "$target" ] || [ "$target" = "DHCP_PENDING" ]; then
      echo "No static SSH target found for {{hostname}} in Terraform output" >&2
      exit 1
    fi
    just _banner 35 vm "{{hostname}}" "Switching NixOS VM on ${target}"
    export NIX_SSHOPTS="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
    nix run nixpkgs#nixos-rebuild -- switch --impure --flake .#{{hostname}} --target-host "$target" --build-host "$target" --sudo --no-reexec
    # After switch, connect Tailscale
    auth_key=$(doppler run -- printenv TAILSCALE_AUTH_KEY)
    ssh $NIX_SSHOPTS "$target" "sudo tailscale up --auth-key='$auth_key' --ssh" || true

# Switch all enabled VM hosts.
vm-switch-all:
    just vm-switch

# Full VM deploy: build image, let Terraform create/update cloud-init VMs, then apply NixOS configs
vm-deploy: vm-apply
    just vm-wait trinity
    just vm-switch

# ============================================================================
# Darwin (macOS System) Management
# ============================================================================

# Switch nix-darwin and Home Manager on all enabled Macs, or pass a hostname to switch one Mac.
darwin-switch host="all":
    #!/usr/bin/env bash
    set -euo pipefail
    if [ "{{host}}" = "all" ]; then
      for h in {{enabled_darwin_hosts}}; do
        just darwin-switch "$h"
      done
      exit 0
    fi

    just _banner 36 darwin "{{host}}" "Switching nix-darwin configuration"
    doppler run -- sudo nix run nix-darwin -- switch --flake .#{{host}}

    just darwin-home-switch "{{host}}"

# Switch Home Manager on all enabled Macs, or pass a hostname to switch one Mac.
darwin-home-switch host="all":
    #!/usr/bin/env bash
    set -euo pipefail
    if [ "{{host}}" = "all" ]; then
      for h in {{enabled_darwin_hosts}}; do
        just darwin-home-switch "$h"
      done
      exit 0
    fi

    just _banner 34 home "fs@{{host}}" "Switching Home Manager configuration"
    doppler run -- home-manager switch --flake .#fs@{{host}}

# Build nix-darwin and Home Manager on all enabled Macs, or pass a hostname to build one Mac.
darwin-build host="all":
    #!/usr/bin/env bash
    set -euo pipefail
    if [ "{{host}}" = "all" ]; then
      for h in {{enabled_darwin_hosts}}; do
        just darwin-build "$h"
      done
      exit 0
    fi

    just _banner 36 darwin "{{host}}" "Building nix-darwin configuration"
    doppler run -- nix run nix-darwin -- build --flake .#{{host}}

    just darwin-home-build "{{host}}"

# Build Home Manager on all enabled Macs, or pass a hostname to build one Mac.
darwin-home-build host="all":
    #!/usr/bin/env bash
    set -euo pipefail
    if [ "{{host}}" = "all" ]; then
      for h in {{enabled_darwin_hosts}}; do
        just darwin-home-build "$h"
      done
      exit 0
    fi

    just _banner 34 home "fs@{{host}}" "Building Home Manager configuration"
    doppler run -- home-manager build --flake .#fs@{{host}}

# Compatibility alias for the old explicit neo command.
darwin-switch-neo:
    just darwin-switch neo

# Compatibility alias for the old explicit neo home command.
home-switch-neo:
    just darwin-home-switch neo

# Compatibility alias for the old explicit macvm-fs command.
darwin-switch-macvm-fs:
    just darwin-switch macvm-fs

# Compatibility alias for the old explicit macvm-fs home command.
home-switch-macvm-fs:
    just darwin-home-switch macvm-fs

# Compatibility alias for the old explicit macvm-fs build command.
darwin-build-macvm-fs:
    just darwin-build macvm-fs

# ============================================================================
# Physical NixOS Host Management
# ============================================================================

# Resolve SSH target for a physical NixOS host.
_nixos-target host:
    #!/usr/bin/env bash
    set -euo pipefail
    case "{{host}}" in
      morpheus)
        echo "root@10.0.40.19"
        ;;
      *)
        echo "No physical NixOS target configured for '{{host}}'" >&2
        exit 1
        ;;
    esac

# Verify a physical NixOS host is reachable before starting a remote build or switch.
_nixos-check-ssh host target:
    #!/usr/bin/env bash
    set -euo pipefail
    if ssh -o BatchMode=yes -o ConnectTimeout=5 -o StrictHostKeyChecking=no "{{target}}" true >/dev/null 2>&1; then
      exit 0
    fi

    cat >&2 <<'EOF'
    Cannot reach physical NixOS host {{host}} at {{target}} over SSH.

    Check that this machine is on the same LAN/VPN as the server, or that the
    server is already reachable through Tailscale. For morpheus, the direct LAN
    target is 10.0.40.19.
    EOF
    exit 1

# Build NixOS on all enabled physical hosts, or pass a hostname to build one host.
nixos-build host="all":
    #!/usr/bin/env bash
    set -euo pipefail
    if [ "{{host}}" = "all" ]; then
      for h in {{enabled_nixos_hosts}}; do
        just nixos-build "$h"
      done
      exit 0
    fi

    target=$(just _nixos-target "{{host}}")
    just _nixos-check-ssh "{{host}}" "$target"
    just _banner 32 nixos "{{host}}" "Building physical host on ${target}"
    export NIX_SSHOPTS="-o StrictHostKeyChecking=no"
    nix run nixpkgs#nixos-rebuild -- build --flake .#{{host}} --target-host "$target" --build-host "$target" --no-reexec

# Switch NixOS on all enabled physical hosts, or pass a hostname to switch one host.
nixos-switch host="all":
    #!/usr/bin/env bash
    set -euo pipefail
    if [ "{{host}}" = "all" ]; then
      for h in {{enabled_nixos_hosts}}; do
        just nixos-switch "$h"
      done
      exit 0
    fi

    target=$(just _nixos-target "{{host}}")
    just _nixos-check-ssh "{{host}}" "$target"
    just _banner 32 nixos "{{host}}" "Switching physical host on ${target}"
    export NIX_SSHOPTS="-o StrictHostKeyChecking=no"
    nix run nixpkgs#nixos-rebuild -- switch --flake .#{{host}} --target-host "$target" --build-host "$target" --no-reexec

    auth_key=$(doppler run -- printenv TAILSCALE_AUTH_KEY 2>/dev/null || true)
    if [ -n "$auth_key" ]; then
      ssh $NIX_SSHOPTS "$target" "tailscale up --auth-key='$auth_key' --ssh" || true
    fi

# Compatibility alias for switching all enabled physical NixOS hosts.
nixos-switch-all:
    just nixos-switch

# Compatibility alias for building all enabled physical NixOS hosts.
nixos-build-all:
    just nixos-build

# ============================================================================
# Home Manager (User Environment) Management
# ============================================================================

# Switch Home Manager for the current local host, or pass a host explicitly.
home-switch host="current":
    #!/usr/bin/env bash
    set -euo pipefail
    target="{{host}}"
    if [ "$target" = "current" ]; then
      target="{{hostname}}"
    fi
    just darwin-home-switch "$target"

# Build Home Manager for the current local host, or pass a host explicitly.
home-build host="current":
    #!/usr/bin/env bash
    set -euo pipefail
    target="{{host}}"
    if [ "$target" = "current" ]; then
      target="{{hostname}}"
    fi
    just darwin-home-build "$target"

# Compatibility alias for the old explicit macvm-fs home build command.
home-build-macvm-fs:
    just darwin-home-build macvm-fs

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
