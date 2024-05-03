{...}: {
  # Source Gnome pop-shell extention config from the home-manager
  xdg.configFile = {
    "pop-shell/config.json".text = ''
      {
        "float": [
          {
            "class": "pop-shell-example",
            "title": "pop-shell-example"
          },
          {
            "class": "ulauncher",
            "title": "Ulauncher - Application Launcher"
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
