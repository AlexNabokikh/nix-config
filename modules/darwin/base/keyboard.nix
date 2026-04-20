{
  flake.modules.darwin.base = {
    system.keyboard = {
      enableKeyMapping = true;
      userKeyMapping = [
        {
          HIDKeyboardModifierMappingDst = 30064771125;
          HIDKeyboardModifierMappingSrc = 30064771172;
        }
      ];
    };
  };
}
