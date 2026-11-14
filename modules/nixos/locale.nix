{ config, ... }:
{
  time.timeZone = config.locale.timezone;

  i18n = {
    defaultLocale = config.locale.default;
    extraLocaleSettings = config.locale.extra;
  };
}
