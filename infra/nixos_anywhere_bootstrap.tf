resource "terraform_data" "wait_for_ssh" {
  depends_on = [proxmox_virtual_environment_vm.management_vm]
  input = {
    target        = var.management_vm_nixos_anywhere_target
    identity_file = var.management_vm_nixos_anywhere_identity_file
  }

  provisioner "local-exec" {
    command = <<-EOT
      echo "Waiting for VM to be reachable via SSH..."
      for i in {1..60}; do
        if ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ${self.input.identity_file} ${self.input.target} "echo ok" 2>/dev/null; then
          echo "VM is reachable!"
          exit 0
        fi
        echo "Waiting for SSH... attempt $i/60"
        sleep 10
      done
      echo "VM did not become reachable in time"
      exit 1
    EOT
  }
}

resource "terraform_data" "deploy_nixos" {
  count      = var.management_vm_nixos_anywhere_enabled ? 1 : 0
  depends_on = [terraform_data.wait_for_ssh]
  input = {
    target        = var.management_vm_nixos_anywhere_target
    identity_file = var.management_vm_nixos_anywhere_identity_file
    flake         = var.management_vm_nixos_anywhere_flake
  }

  provisioner "local-exec" {
    command     = "nix run github:nix-community/nixos-anywhere -- --flake ${self.input.flake} -i ${self.input.identity_file} --phases disko,install,reboot --ssh-option StrictHostKeyChecking=no --ssh-option UserKnownHostsFile=/dev/null ${self.input.target}"
    working_dir = "${path.module}/.."
  }
}
