{
  inputs,
  hostname,
  lib,
  modulesPath,
  pkgs,
  userConfig,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ../modules/tailscale.nix
  ];

  # Core VM settings (generic for all Proxmox VMs)
  networking.hostName = hostname;
  networking.useDHCP = false;
  networking.usePredictableInterfaceNames = false;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  boot.kernelPackages = pkgs.linuxPackages_6_12;
  boot.kernelParams = ["console=tty0"];
  boot.loader = {
    efi.canTouchEfiVariables = false;
    grub.enable = false;
    systemd-boot.enable = true;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/ESP";
    fsType = "vfat";
  };
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    trusted-users = ["root" "@wheel"];
  };
  nix.optimise.automatic = true;

  services.qemuGuest.enable = true;
  services.cloud-init = {
    enable = true;
    network.enable = true;
    settings = {
      datasource_list = [
        "NoCloud"
        "ConfigDrive"
      ];
      preserve_hostname = true;
    };
  };
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  networking.firewall.enable = true;
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.${userConfig.name} = {
    description = userConfig.fullName;
    extraGroups = ["wheel" "docker"];
    isNormalUser = true;
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = userConfig.sshKeys;
  };

  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    curl
    docker-compose
    direnv
    doppler
    eza
    fastfetch
    fzf
    git
    home-manager
    htop
    jq
    kubectl
    lazydocker
    lazygit
    mise
    neovim
    ripgrep
    starship
    tailscale
    tree
    vim
    zoxide
    zsh-syntax-highlighting
  ];

  programs.zsh.enable = true;

  environment.etc."zsh/vm-zshrc".text = ''
    # Managed by NixOS. Mirrors the reusable shell setup from home/modules/zsh.nix.

    if [[ -o zle ]]; then
      source ${inputs.zsh-autosuggestions}/zsh-autosuggestions.zsh
      source ${inputs.zsh-history-substring-search}/zsh-history-substring-search.zsh
      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    fi

    if [[ -o zle ]] && command -v starship >/dev/null 2>&1; then
      eval "$(starship init zsh)"
    fi

    if command -v zoxide >/dev/null 2>&1; then
      eval "$(zoxide init zsh)"
      alias cd="__zoxide_z"
    fi

    if [[ -o zle ]] && [[ -t 0 ]] && command -v fzf >/dev/null 2>&1; then
      source <(fzf --zsh)
    fi

    if command -v kubectl >/dev/null 2>&1; then
      source <(kubectl completion zsh)
    fi

    if command -v mise >/dev/null 2>&1; then
      eval "$(mise activate zsh)"
    fi

    if command -v direnv >/dev/null 2>&1; then
      eval "$(direnv hook zsh)"
    fi

    alias ff="fastfetch"
    alias ld="lazydocker"
    alias lg="lazygit"
    alias repo="cd $HOME/Documents/repositories"
    alias temp="cd $HOME/Downloads/temp"
    alias v="nvim"
    alias vi="nvim"
    alias vim="nvim"
    alias ls="eza --icons always"
    alias ll="eza -bhl --icons --group-directories-first"
    alias la="eza -abhl --icons --group-directories-first"
    alias lt="eza --tree --level=2 --icons"

    alias gaa="git add --all"
    alias gcam="git commit --all --message"
    alias gcl="git clone"
    alias gco="git checkout"
    alias ggl="git pull"
    alias ggp="git push"

    alias k="kubectl"
    alias kgno="kubectl get node"
    alias kdno="kubectl describe node"
    alias kgp="kubectl get pods"
    alias kep="kubectl edit pods"
    alias kdp="kubectl describe pods"
    alias kdelp="kubectl delete pods"
    alias kgs="kubectl get svc"
    alias kes="kubectl edit svc"
    alias kds="kubectl describe svc"
    alias kdels="kubectl delete svc"
    alias kgi="kubectl get ingress"
    alias kei="kubectl edit ingress"
    alias kdi="kubectl describe ingress"
    alias kdeli="kubectl delete ingress"
    alias kgns="kubectl get namespaces"
    alias kens="kubectl edit namespace"
    alias kdns="kubectl describe namespace"
    alias kdelns="kubectl delete namespace"
    alias kgd="kubectl get deployment"
    alias ked="kubectl edit deployment"
    alias kdd="kubectl describe deployment"
    alias kdeld="kubectl delete deployment"
    alias kgsec="kubectl get secret"
    alias kdsec="kubectl describe secret"
    alias kdelsec="kubectl delete secret"

    if [[ -o zle ]]; then
      bindkey -v
      bindkey '^A' beginning-of-line
      bindkey '^E' end-of-line
      bindkey '^H' backward-delete-word
      bindkey '^[[1;5C' forward-word
      bindkey '^[[1;5D' backward-word

      autoload -z edit-command-line
      zle -N edit-command-line
      bindkey "^e" edit-command-line

      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down
    fi

    export HISTSIZE=10000
    export SAVEHIST=10000
    setopt HIST_IGNORE_DUPS
    setopt HIST_IGNORE_SPACE
    setopt SHARE_HISTORY
  '';

  environment.etc."starship-vm.toml".text = ''
    add_newline = false
    palette = "catppuccin_macchiato"
    right_format = "$kubernetes"

    [aws]
    disabled = true

    [directory]
    style = "bold lavender"

    [docker_context]
    symbol = " "

    [golang]
    symbol = " "

    [kubernetes]
    disabled = false
    style = "bold pink"
    symbol = "󱃾 "
    format = "[$symbol$context( \\($namespace\\))]($style)"

    [[kubernetes.contexts]]
    context_pattern = "arn:aws:eks:(?P<var_region>.*):(?P<var_account>[0-9]{12}):cluster/(?P<var_cluster>.*)"
    context_alias = "$var_cluster"

    [lua]
    symbol = " "

    [package]
    symbol = " "

    [php]
    symbol = " "

    [python]
    symbol = " "

    [terraform]
    symbol = " "

    [palettes.catppuccin_macchiato]
    lavender = "#b7bdf8"
    pink = "#f5bde6"
  '';

  virtualisation.docker.enable = true;
  virtualisation.docker.rootless.enable = true;
  virtualisation.docker.rootless.setSocketVariable = true;

  # Tailscale VPN with SSH access
  tailscale = {
    enable = true;
  };

  system.stateVersion = "25.05";
}
