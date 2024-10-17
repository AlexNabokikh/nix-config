{pkgs, ...}: {
  # Basic system settings
  system.defaults.NSGlobalDomain.AppleInterfaceStyle = "Dark";
  system.defaults.NSGlobalDomain.AppleKeyboardUIMode = 3;
  system.defaults.NSGlobalDomain.InitialKeyRepeat = 15;
  system.defaults.NSGlobalDomain.KeyRepeat = 2;

  # Install some basic packages
  environment.systemPackages = with pkgs; [
    awscli2
    delta
    kubectl
    du-dust
    eza
    fd
    jq
    kubectl
    lazydocker
    nh
    openconnect
    pipenv
    ripgrep
  ];

  # Enable some system services
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  # Fonts configuration
  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["Meslo" "JetBrainsMono"];})
    roboto
  ];

  homebrew = {
    enable = true;
    casks = [
      "alacritty"
      "anki"
    ];
  };

  # Add ability to use TouchID for sudo
  security.pam.enableSudoTouchIdAuth = true;

  # Set up user
  users.users.alexander-nabokikh = {
    name = "alexander.nabokikh";
    home = "/Users/alexander.nabokikh";
  };

  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = 5;
}
