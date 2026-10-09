{
  flake.modules.darwin.keyboard = {
    system.defaults.CustomUserPreferences = {
      "com.apple.symbolichotkeys" = {
        AppleSymbolicHotKeys = {
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

      NSGlobalDomain.NSUserKeyEquivalents = {
        "Lock Screen" = "@^l";
        "Paste and Match Style" = "^$v";
      };
    };

    # /usr/bin/hidutil under System Settings → Privacy & Security → Input Monitoring.
    # Use +, then Command+Shift+G in the file chooser to enter /usr/bin/hidutil.
    launchd.user.agents.keyboard-remap.serviceConfig = {
      ProgramArguments = [
        "/usr/bin/hidutil"
        "property"
        "--matching"
        (builtins.toJSON {
          Product = "Apple Internal Keyboard / Trackpad";
          PrimaryUsagePage = 1;
          PrimaryUsage = 6;
        })
        "--set"
        (builtins.toJSON {
          UserKeyMapping = [
            {
              # Fn (0xff00000003) -> left Control (0x7000000e0).
              HIDKeyboardModifierMappingSrc = 1095216660483;
              HIDKeyboardModifierMappingDst = 30064771296;
            }
            {
              # Right Command -> right Option
              HIDKeyboardModifierMappingSrc = 30064771303;
              HIDKeyboardModifierMappingDst = 30064771302;
            }
            # Section symbol ->  backtick/tilde
            {
              HIDKeyboardModifierMappingSrc = 30064771125;
              HIDKeyboardModifierMappingDst = 30064771172;
            }
            {
              HIDKeyboardModifierMappingSrc = 30064771172;
              HIDKeyboardModifierMappingDst = 30064771125;
            }
          ];
        })
      ];
      RunAtLoad = true;
      KeepAlive = false;
      StandardOutPath = "/tmp/keyboard-remap.log";
      StandardErrorPath = "/tmp/keyboard-remap.err.log";
    };
  };
}
