{
  flake.modules.homeManager.scripts =
    { lib, pkgs, ... }:
    let
      commonScripts = [
        "cd-to-project"
        "docker"
        "fif"
        "fkill"
        "ks"
        "pull-all"
        "traverser"
      ];

      linuxScripts = [
        "ocr"
        "toggle-screen-recording"
      ];

      scriptNames = commonScripts ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux linuxScripts;

      scripts = pkgs.stdenvNoCC.mkDerivation {
        pname = "personal-scripts";
        version = "0";
        src = ./bin;

        dontConfigure = true;
        dontBuild = true;

        installPhase = ''
          runHook preInstall

          for script in ${lib.escapeShellArgs scriptNames}; do
            install -Dm755 "$script" "$out/bin/$script"
          done

          runHook postInstall
        '';
      };
    in
    {
      home.packages = [ scripts ];
    };
}
