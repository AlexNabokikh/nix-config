# Module: Darwin Common Configuration
# Purpose: Shared macOS settings for all Darwin systems
# Platform: macOS only
{
  pkgs,
  outputs,
  userConfig,
  ...
}: {
  # Homebrew package manager configuration
  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = "${userConfig.name}";
    autoMigrate = true;
  };

  # Configure nixpkgs behavior and overlays
  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    overlays = [
      outputs.overlays.stable-packages
      outputs.overlays.fish-no-tests
      outputs.overlays.direnv-no-tests
    ];
    config.allowUnfree = true;
  };

  # Configure Nix package manager behavior
  nix = {
    settings.experimental-features = "nix-command flakes";
    optimise.automatic = true;
    package = pkgs.nix;
    gc = {
      automatic = true;
      interval = {Weekday = 7;}; # Run on Sunday
      options = "--delete-older-than 30d";
    };
  };

  # Configure the user account
  users.users.${userConfig.name} = {
    name = "${userConfig.name}";
    home = "/Users/${userConfig.name}";
  };

  # System-wide macOS settings
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

    LaunchServices.LSQuarantine = false;

    trackpad = {
      TrackpadRightClick = true;
      TrackpadThreeFingerDrag = true;
      Clicking = true;
    };

    finder = {
      AppleShowAllFiles = true;
      CreateDesktop = false;
      FXDefaultSearchScope = "SCcf";
      FXEnableExtensionChangeWarning = false;
      FXPreferredViewStyle = "Nlsv";
      QuitMenuItem = true;
      ShowPathbar = true;
      ShowStatusBar = true;
      _FXShowPosixPathInTitle = true;
      _FXSortFoldersFirst = true;
      FXRemoveOldTrashItems = true;
      NewWindowTarget = "Home";
    };

    dock = {
      expose-animation-duration = 0.15;
      show-recents = false;
      showhidden = true;
      tilesize = 60;
      wvous-bl-corner = 1;
      wvous-br-corner = 1;
      wvous-tl-corner = 1;
      wvous-tr-corner = 1;
    };

    screencapture = {
      location = "/Users/${userConfig.name}/Downloads/temp";
      type = "png";
      disable-shadow = true;
    };

    menuExtraClock.Show24Hour = true;
  };

  # Keyboard settings
  system.keyboard = {
    enableKeyMapping = true;
    userKeyMapping = [
      {
        # Remap §± key to ~ (tilde)
        HIDKeyboardModifierMappingDst = 30064771125;
        HIDKeyboardModifierMappingSrc = 30064771172;
      }
    ];
  };

  # Post-activation script for Spotlight shortcut
  system.activationScripts.postActivation.text = ''
    # Set Spotlight shortcut to Option + Space
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 "
      <dict>
        <key>enabled</key><true/>
        <key>value</key><dict>
          <key>type</key><string>standard</string>
          <key>parameters</key>
          <array>
            <integer>32</integer>
            <integer>49</integer>
            <integer>524288</integer>
          </array>
        </dict>
      </dict>
    "
  '';

  # Enable Zsh as the default shell
  programs.zsh.enable = true;

  # Install system fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.meslo-lg
    roboto
  ];
}
