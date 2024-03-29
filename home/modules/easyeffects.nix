{...}: {
  # Install easyeffects via home-manager module
  services.easyeffects = {
    enable = true;
    preset = "rode";
  };

  # Source easyeffects preset from the home-manager store
  home.file = {
    ".config/easyeffects/input/rode.json".text = ''
      {
      		"input": {
      				"blocklist": [],
      				"deepfilternet#0": {
      						"attenuation-limit": 100.0,
      						"max-df-processing-threshold": 20.0,
      						"max-erb-processing-threshold": 30.0,
      						"min-processing-buffer": 0,
      						"min-processing-threshold": -10.0,
      						"post-filter-beta": 0.02
      				},
      				"plugins_order": [
      						"deepfilternet#0",
      						"stereo_tools#0"
      				],
      				"stereo_tools#0": {
      						"balance-in": 0.0,
      						"balance-out": 0.0,
      						"bypass": false,
      						"delay": 0.0,
      						"input-gain": 0.0,
      						"middle-level": 0.0,
      						"middle-panorama": 0.0,
      						"mode": "LR > LL (Mono Left Channel)",
      						"mutel": false,
      						"muter": false,
      						"output-gain": 0.0,
      						"phasel": false,
      						"phaser": false,
      						"sc-level": 1.0,
      						"side-balance": 0.0,
      						"side-level": 0.0,
      						"softclip": false,
      						"stereo-base": 0.0,
      						"stereo-phase": 0.0
      				}
      		}
      }
    '';
  };
}
