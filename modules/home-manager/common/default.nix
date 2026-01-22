{
  outputs,
  userConfig,
  pkgs,
  ...
}:
{
  imports = [
    ../programs/aerospace
    ../programs/alacritty
    ../programs/albert
    ../programs/atuin
    ../programs/bat
    ../programs/brave
    ../programs/btop
    ../programs/fastfetch
    ../programs/fzf
    ../programs/git
    ../programs/go
    ../programs/gpg
    ../programs/k8s
    ../programs/lazygit
    ../programs/neovim
    ../programs/saml2aws
    ../programs/starship
    ../programs/telegram
    ../programs/tmux
    ../programs/zsh
    ../scripts
  ];

  # Nixpkgs configuration
  nixpkgs = {
    overlays = [
      outputs.overlays.stable-packages
    ];

    config = {
      allowUnfree = true;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # Home-Manager configuration for the user's home environment
  home = {
    username = userConfig.name;
    homeDirectory =
      if pkgs.stdenv.isDarwin then "/Users/${userConfig.name}" else "/home/${userConfig.name}";
  };

  # Ensure common packages are installed
  home.packages =
    with pkgs;
    [
      awscli2
      dig
      eza
      fd
      github-copilot-cli
      jq
      nh
      openconnect
      pipenv
      podman-compose
      podman-tui
      python3
      ripgrep
      terraform
    ]
    ++ lib.optionals stdenv.isDarwin [
      anki-bin
      colima
      hidden-bar
      mos
      podman
      raycast
    ]
    ++ lib.optionals (!stdenv.isDarwin) [
      anki
      tesseract
      unzip
      wl-clipboard
    ];

  # Catppuccin flavor and accent
  catppuccin = {
    flavor = "macchiato";
    accent = "lavender";
  };
}
