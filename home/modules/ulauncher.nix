{pkgs, ...}: {
  # Ulauncher plugins dependecies installation via overlay
  nixpkgs = {
    overlays = [
      (final: prev: {
        ulauncher = prev.ulauncher.overrideAttrs (old: {
          propagatedBuildInputs = with prev.python3Packages;
            old.propagatedBuildInputs
            ++ [
              thefuzz
              tornado
            ];
        });
      })
    ];
  };

  # Ulauncher package
  home.packages = with pkgs; [
    ulauncher
  ];

  # Ulauncher service configuration
  systemd.user.services.ulauncher = {
    Unit = {
      Description = "ulauncher application launcher service";
      Documentation = "https://ulauncher.io";
      PartOf = ["graphical-session.target"];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.bash}/bin/bash -lc '${pkgs.ulauncher}/bin/ulauncher --hide-window --no-window-shadow'";
      Restart = "always";
    };

    Install.WantedBy = ["graphical-session.target"];
  };
}
