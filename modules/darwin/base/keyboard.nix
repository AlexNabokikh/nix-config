{
  flake.modules.darwin.base = {
    system.keyboard = {
      enableKeyMapping = true;
      nonUS.remapTilde = true;
    };
  };
}
