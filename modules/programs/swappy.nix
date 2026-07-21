{
  flake.modules.homeManager.swappy = {
    programs.swappy = {
      enable = true;
      settings.Default = {
        paint_mode = "arrow";
        save_dir = "$HOME/Pictures/Screenshots";
        save_filename_format = "screenshot-%Y%m%d-%H%M%S.png";
      };
    };
  };
}
