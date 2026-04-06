{ ... }:
{
  flake.modules.nixos.base = { config, ... }: {
    time.timeZone = config.profile.locale.timezone;

    i18n.defaultLocale = config.profile.locale.default;
    i18n.extraLocaleSettings = config.profile.locale.extra;
  };
}
