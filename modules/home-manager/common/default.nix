{
  outputs,
  userConfig,
  pkgs,
  ...
}: {
  imports = [
    ../misc/qt
    ../programs/aerospace
    ../programs/alacritty
    ../programs/atuin
    ../programs/bat
    ../programs/brave
    ../programs/btop
    ../programs/fastfetch
    ../programs/fzf
    ../programs/git
    ../programs/go
    ../programs/gpg
    ../programs/k9s
    ../programs/krew
    ../programs/lazygit
    ../programs/neovim
    ../programs/obs-studio
    ../programs/saml2aws
    ../programs/starship
    ../programs/telegram
    ../programs/tmux
    ../programs/ulauncher
    ../programs/zsh
    ../scripts
    ../services/easyeffects
    ../services/flatpak
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
    username = "${userConfig.name}";
    homeDirectory =
      if pkgs.stdenv.isDarwin
      then "/Users/${userConfig.name}"
      else "/home/${userConfig.name}";
  };

  # Ensure common packages are installed
  home.packages = with pkgs;
    [
      anki-bin
      awscli2
      dig
      du-dust
      eza
      fd
      jq
      kubectl
      lazydocker
      nh
      openconnect
      pipenv
      python3
      ripgrep
      terraform
    ]
    ++ lib.optionals stdenv.isDarwin [
      colima
      docker
      hidden-bar
      raycast
    ]
    ++ lib.optionals (!stdenv.isDarwin) [
      pavucontrol
      tesseract
      unzip
      wl-clipboard
    ];

  # Catpuccin flavor and accent
  catppuccin = {
    flavor = "macchiato";
    accent = "lavender";
  };
}
