{
  flake.modules.darwin.systemPreferences =
    { config, ... }:
    {
      system.defaults = {
        controlcenter = {
          BatteryShowPercentage = true;
          NowPlaying = false;
        };

        NSGlobalDomain = {
          "com.apple.sound.beep.volume" = 0.000;
          AppleInterfaceStyle = "Dark";
          ApplePressAndHoldEnabled = false;
          AppleShowAllExtensions = true;
          InitialKeyRepeat = 20;
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
        };

        dock = {
          autohide = true;
          expose-animation-duration = 0.15;
          show-recents = false;
          showhidden = true;
          persistent-apps = [ ];
          tilesize = 30;
          wvous-bl-corner = 1;
          wvous-br-corner = 1;
          wvous-tl-corner = 1;
          wvous-tr-corner = 1;
        };

        screencapture = {
          location = "/Users/${config.primaryUser}/Downloads/temp";
          type = "png";
          disable-shadow = true;
        };

        CustomUserPreferences = {
          "com.caldis.Mos".hideStatusItem = true;

          NSGlobalDomain."com.apple.mouse.linear" = true;
        };
      };
    };
}
