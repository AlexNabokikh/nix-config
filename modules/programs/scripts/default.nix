{
  flake.modules.homeManager.scripts =
    { lib, pkgs, ... }:
    let
      commonScripts = [
        "cd-to-project"
        "fif"
        "fkill"
      ];

      linuxScripts = [
        "ocr"
        "toggle-screen-recording"
        "wayblast"
      ];

      scriptNames = commonScripts ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux linuxScripts;

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
