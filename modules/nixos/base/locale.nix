{ config, ... }:
{
  flake.modules.nixos.locale = {
    time.timeZone = config.profile.locale.timezone;

    i18n.defaultLocale = config.profile.locale.default;
    i18n.extraLocaleSettings = config.profile.locale.extra;
  };
}
