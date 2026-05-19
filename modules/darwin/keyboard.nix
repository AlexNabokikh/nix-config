{
  flake.modules.darwin.base = {
    system.keyboard = {
      enableKeyMapping = true;
      nonUS.remapTilde = true;
    };

    system.defaults.CustomUserPreferences = {
      "com.apple.symbolichotkeys" = {
        AppleSymbolicHotKeys = {
          # Show Notification Center → Option+N
          "163" = {
            enabled = true;
            value = {
              parameters = [
                110
                45
                524288
              ];
              type = "standard";
            };
          };

          # Screenshot and recording options → Shift+Option+R
          "184" = {
            enabled = true;
            value = {
              parameters = [
                114
                15
                655360
              ];
              type = "standard";
            };
          };

          # Select previous input source → disabled
          "60".enabled = false;

          # Select next input source → Option+Space
          "61" = {
            enabled = true;
            value = {
              parameters = [
                32
                49
                524288
              ];
              type = "standard";
            };
          };

          # Show Spotlight search → disabled
          "64".enabled = false;

          # Show Spotlight file-search window → disabled
          "65".enabled = false;

          # Paste without formatting → Control+Command+C
          "238" = {
            enabled = true;
            value = {
              parameters = [
                99
                8
                1310720
              ];
              type = "standard";
            };
          };

          # Show Help menu → disabled
          "98" = {
            enabled = false;
            value = {
              parameters = [
                47
                44
                1179648
              ];
              type = "standard";
            };
          };
        };
      };

      "com.brave.Browser".NSUserKeyEquivalents = {
        "Actual Size" = "^0";
        "Close Tab" = "^w";
        "Find..." = "^f";
        "New Private Window" = "^$n";
        "New Tab" = "^t";
        "Reload This Page" = "^r";
        "Reopen Closed Tab" = "^$t";
        "Zoom In" = "^=";
        "Zoom Out" = "^-";
      };

      "-g".NSUserKeyEquivalents = {
        "Lock Screen" = "@^l";
        "Paste and Match Style" = "^$v";
      };
    };
  };
}
