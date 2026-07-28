{
  flake.modules.darwin.sudo =
    { config, ... }:
    {
      security.sudo.extraConfig = "${config.primaryUser}    ALL = (ALL) NOPASSWD: ALL";
    };
}
