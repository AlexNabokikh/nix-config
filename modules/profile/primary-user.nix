{
  flake.modules.generic.primaryUser =
    { lib, ... }:
    {
      options.primaryUser = lib.mkOption {
        type = lib.types.str;
        description = "Primary username for this system";
      };
    };
}
