{...}: {
  # CoreCtrl for hardware monitoring and tuning
  programs.corectrl = {
    enable = true;
    gpuOverclock = {
      enable = true;
      ppfeaturemask = "0xffffffff";
    };
  };

  # Do not ask for password when launching corectrl
  security.polkit.extraConfig = ''
    polkit.addRule(function (action, subject) {
      if ((action.id == "org.corectrl.helper.init" ||
          action.id == "org.corectrl.helperkiller.init") &&
          subject.local == true &&
          subject.active == true &&
          subject.isInGroup("users")) {
        return polkit.Result.YES;
      }
    });
  '';
}
