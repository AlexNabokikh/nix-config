{
  flake.modules.homeManager.scripts =
    { lib, pkgs, ... }:
    let
      scriptNames = [
        "cd-to-project"
        "fif"
        "fkill"
      ];

      scripts = pkgs.runCommand "personal-scripts" { } ''
        for script in ${lib.escapeShellArgs scriptNames}; do
          install -Dm755 "${./bin}/$script" "$out/bin/$script"
        done
      '';
    in
    {
      home.packages = [ scripts ];
    };
}
