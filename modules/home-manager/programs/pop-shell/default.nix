{...}: {
  # Source Gnome pop-shell extention config from the home-manager
  xdg.configFile = {
    "pop-shell/config.json".text = ''
      {
        "float": [
          {
            "class": "ulauncher"
          },
          {
            "class": "org.gnome.Calculator"
          }
        ],
        "skiptaskbarhidden": [],
        "log_on_focus": false
      }
    '';
  };
}
