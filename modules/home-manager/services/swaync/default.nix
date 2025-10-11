{ ... }:
{
  # Tempoary use overlay until new release
  nixpkgs.overlays = [
    (self: prev: {
      swaynotificationcenter = prev.swaynotificationcenter.overrideAttrs (oldAttrs: {
        src = prev.fetchFromGitHub {
          owner = "ErikReider";
          repo = "SwayNotificationCenter";
          rev = "d95a18896b0013cdc5193c63ceb34fef1e956f02";
          sha256 = "sha256-+9d/qhsw4GOgdraNj0i94n8BY5LF+NV48+YpyijukDk=";
        };
        version = "0.12.2-pr654";
        nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ prev.blueprint-compiler ];
        buildInputs = oldAttrs.buildInputs ++ [
          prev.gtk4
          prev.gtk4-layer-shell
          prev.libadwaita
          prev.pantheon.granite7
        ];
      });
    })
  ];

  # Manage swaync service via Home-manager
  services.swaync = {
    enable = true;
    settings = {
      control-center-height = 800;
      control-center-width = 400;
      fit-to-screen = false;
      notification-grouping = false;
      notification-window-width = 350;
      notification-icon-size = 32;
      notification-action-filter = {
        hide-all-actions = {
          use-regex = true;
          id-matcher = ".*";
        };
      };
    };
  };

  # Enable catppuccin theming for swaync.
  catppuccin.swaync = {
    enable = true;
    font = "Roboto Nerd Font";
  };
}
