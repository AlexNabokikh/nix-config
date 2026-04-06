{
  plugins = {
    sources = [
      {
        enabled = true;
        name = "Official Noctalia Plugins";
        url = "https://github.com/noctalia-dev/noctalia-plugins";
      }
    ];
    states = {
      privacy-indicator = {
        enabled = true;
        sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
      };
    };
    version = 1;
  };

  pluginSettings = {
    privacy-indicator = {
      hideInactive = true;
      enableToast = false;
      iconSpacing = 4;
      removeMargins = true;
      activeColor = "error";
      inactiveColor = "none";
    };
  };
}
