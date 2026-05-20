{
  flake.modules.darwin.sudo =
    { config, ... }:
    {
      security.pam.services.sudo_local.touchIdAuth = true;
      security.sudo.extraConfig = "${config.primaryUser}    ALL = (ALL) NOPASSWD: ALL";
    };
}
