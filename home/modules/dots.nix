{flakePath, ...}: {
  # Create symlinks for configuration files
  home.file.".config/" = {
    source = "${flakePath}/home/config";
    recursive = true;
  };
}
