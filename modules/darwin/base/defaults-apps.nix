{ ... }:
{
  flake.modules.darwin.base = {
    system.defaults.CustomUserPreferences = {
      "com.apple.symbolichotkeys" = {
        AppleSymbolicHotKeys = {
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
          "60".enabled = false;
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
          "64".enabled = false;
          "65".enabled = false;
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
        "Close Tab" = "^w";
        "Find..." = "^f";
        "New Private Window" = "^$n";
        "New Tab" = "^t";
        "Reload This Page" = "^r";
        "Reopen Closed Tab" = "^$t";
        "Reset zoom" = "^0";
        "Zoom In" = "^=";
        "Zoom Out" = "^-";
      };

      "com.caldis.Mos".hideStatusItem = true;

      "com.dwarvesv.minimalbar" = {
        areSeparatorsHidden = 1;
        isAutoHide = 1;
        isAutoStart = 1;
        isShowPreferences = 0;
        numberOfSecondForAutoHide = 5;
      };

      NSGlobalDomain."com.apple.mouse.linear" = true;

      "-g".NSUserKeyEquivalents = {
        "Lock Screen" = "@^l";
        "Paste and Match Style" = "^$v";
      };
    };
  };
}
