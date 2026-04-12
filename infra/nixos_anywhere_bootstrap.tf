# Wait for each VM's installer to be reachable via SSH
resource "terraform_data" "wait_for_ssh" {
  for_each = {
    for name, config in var.vms : name => config
    if config.enabled && config.nixos_anywhere_enabled
  }
  depends_on = [proxmox_virtual_environment_vm.vm]
  
  input = {
    vm_name       = each.key
    target        = each.value.nixos_anywhere_target != null ? each.value.nixos_anywhere_target : "root@${each.value.ipv4_address}"
    identity_file = each.value.nixos_anywhere_identity_file
  }

  provisioner "local-exec" {
    command = <<-EOT
      echo "Waiting for ${self.input.vm_name} installer to be reachable via SSH..."
      for i in {1..60}; do
        if ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ${self.input.identity_file} ${self.input.target} "echo ok" 2>/dev/null; then
          echo "${self.input.vm_name} installer is reachable!"
          exit 0
        fi
        echo "Waiting for SSH... attempt $i/60"
        sleep 10
      done
      echo "${self.input.vm_name} installer did not become reachable in time"
      exit 1
    EOT
  }
}

# Deploy NixOS to each VM via nixos-anywhere
resource "terraform_data" "deploy_nixos" {
  for_each = {
    for name, config in var.vms : name => config
    if config.enabled && config.nixos_anywhere_enabled
  }
  depends_on = [terraform_data.wait_for_ssh]
  
  input = {
    vm_name       = each.key
    target        = each.value.nixos_anywhere_target != null ? each.value.nixos_anywhere_target : "root@${each.value.ipv4_address}"
    identity_file = each.value.nixos_anywhere_identity_file
    flake         = ".#${each.key}"
  }

  provisioner "local-exec" {
    command     = "nix run github:nix-community/nixos-anywhere -- --flake ${self.input.flake} -i ${self.input.identity_file} --phases disko,install,reboot --ssh-option StrictHostKeyChecking=no --ssh-option UserKnownHostsFile=/dev/null ${self.input.target}"
    working_dir = "${path.module}/.."
  }
}
