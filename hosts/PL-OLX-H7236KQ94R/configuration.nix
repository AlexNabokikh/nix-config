{
  pkgs,
  outputs,
  userConfig,
  ...
}: {
  # Nixpkgs configuration
  nixpkgs = {
    overlays = [
      outputs.overlays.unstable-packages
    ];

    config = {
      allowUnfree = true;
    };
  };

  # Nix settings
  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };

  nix.package = pkgs.nix;

  # Enable Nix daemon
  services.nix-daemon.enable = true;

  # User configuration
  users.users.${userConfig.name} = {
    name = "${userConfig.name}";
    home = "/Users/${userConfig.name}";
  };

  # Add ability to use TouchID for sudo
  security.pam.enableSudoTouchIdAuth = true;

  # System settings
  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      ApplePressAndHoldEnabled = false;
      AppleShowAllExtensions = true;
      KeyRepeat = 2;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSAutomaticWindowAnimationsEnabled = false;
      NSDocumentSaveNewDocumentsToCloud = false;
      NSNavPanelExpandedStateForSaveMode = true;
      PMPrintingExpandedStateForPrint = true;
    };
    LaunchServices = {
      LSQuarantine = false;
    };
    trackpad = {
      TrackpadRightClick = true;
      TrackpadThreeFingerDrag = true;
      Clicking = true;
    };
    finder = {
      AppleShowAllFiles = true;
      FXDefaultSearchScope = "SCcf";
      CreateDesktop = false;
      FXEnableExtensionChangeWarning = false;
      QuitMenuItem = true;
      ShowPathbar = true;
      ShowStatusBar = true;
      _FXShowPosixPathInTitle = true;
      _FXSortFoldersFirst = true;
    };
    dock = {
      expose-animation-duration = 0.15;
      show-recents = false;
      showhidden = true;
      persistent-apps = [
        "/Applications/Brave Browser.app"
        "${pkgs.alacritty}/Applications/Alacritty.app"
        "${pkgs.telegram-desktop}/Applications/Telegram.app"
      ];
      tilesize = 30;
      wvous-bl-corner = 4;
      wvous-br-corner = 2;
    };
    screencapture = {
      location = "/Users/${userConfig.name}/Downloads/temp";
      type = "png";
      disable-shadow = true;
    };
  };

  # System packages
  environment.systemPackages = with pkgs; [
    (python3.withPackages (ps: with ps; [pip virtualenv]))
    awscli2
    delta
    du-dust
    eza
    fd
    gnupg
    jq
    kubectl
    lazydocker
    nh
    openconnect
    pipenv
    ripgrep
    telegram-desktop
    terraform
    terragrunt
  ];

  # Zsh configuration
  programs.zsh.enable = true;

  # Fonts configuration
  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["Meslo" "JetBrainsMono"];})
    roboto
  ];

  homebrew = {
    enable = true;
    casks = [
      "aerospace"
      "anki"
      "brave-browser"
      "flameshot"
      "obs"
      "raycast"
    ];
    taps = [
      "nikitabobko/tap"
    ];
    onActivation.cleanup = "zap";
  };

  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = 5;
}
