{
  flake.modules.homeManager.waylandCapture =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      screenshotsDir = "${config.xdg.userDirs.pictures}/Screenshots";
      tesseract = pkgs.tesseract.override {
        enableLanguages = [
          "eng"
          "pol"
          "rus"
        ];
      };
      wayblast = pkgs.writeShellApplication {
        name = "wayblast";
        runtimeInputs = with pkgs; [
          coreutils
          grim
          slurp
          util-linux
          wayfreeze
        ];
        text = builtins.readFile ../programs/scripts/bin/wayblast;
      };
      ocr = pkgs.writeShellApplication {
        name = "ocr";
        runtimeInputs = [
          pkgs.coreutils
          pkgs.wl-clipboard
          tesseract
          wayblast
        ];
        text = builtins.readFile ../programs/scripts/bin/ocr;
      };
      toggleScreenRecording = pkgs.writeShellApplication {
        name = "toggle-screen-recording";
        runtimeInputs = with pkgs; [
          coreutils
          findutils
          gpu-screen-recorder
          libnotify
          procps
          psmisc
          xdg-utils
        ];
        text =
          builtins.replaceStrings
            [ ''RECORDINGS_DIR="$HOME/Videos"'' ]
            [ "RECORDINGS_DIR=${lib.escapeShellArg config.xdg.userDirs.videos}" ]
            (builtins.readFile ../programs/scripts/bin/toggle-screen-recording);
      };
    in
    {
      home.packages = with pkgs; [
        gpu-screen-recorder
        grim
        libnotify
        ocr
        psmisc
        slurp
        tesseract
        toggleScreenRecording
        wayblast
        wayfreeze
        wl-clipboard
      ];

      home.activation.createScreenshotsDirectory = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run mkdir -p ${lib.escapeShellArg screenshotsDir}
      '';

      programs.swappy = {
        enable = true;
        settings.Default = {
          paint_mode = "arrow";
          save_dir = screenshotsDir;
          save_filename_format = "screenshot-%Y%m%d-%H%M%S.png";
        };
      };
    };
}
