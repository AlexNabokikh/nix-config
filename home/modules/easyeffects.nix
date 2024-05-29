{...}: {
  # Install easyeffects via home-manager module
  services.easyeffects = {
    enable = true;
    preset = "rode";
  };

  # Source easyeffects preset from the home-manager store

  xdg.configFile = {
    "easyeffects/input/rode.json".text = ''
          {
        "input": {
          "blocklist": [],
          "compressor#0": {
            "attack": 2.0,
            "boost-amount": 6.0,
            "boost-threshold": -72.0,
            "bypass": false,
            "dry": -100.0,
            "hpf-frequency": 10.0,
            "hpf-mode": "off",
            "input-gain": 0.0,
            "knee": -6.0,
            "lpf-frequency": 20000.0,
            "lpf-mode": "off",
            "makeup": 0.0,
            "mode": "Downward",
            "output-gain": 0.0,
            "ratio": 4.0,
            "release": 200.0,
            "release-threshold": -40.0,
            "sidechain": {
              "lookahead": 0.0,
              "mode": "RMS",
              "preamp": 0.0,
              "reactivity": 10.0,
              "source": "Middle",
              "stereo-split-source": "Left/Right",
              "type": "Feed-forward"
            },
            "stereo-split": false,
            "threshold": -16.0,
            "wet": 0.0
          },
          "deepfilternet#0": {
            "attenuation-limit": 100.0,
            "max-df-processing-threshold": 20.0,
            "max-erb-processing-threshold": 30.0,
            "min-processing-buffer": 0,
            "min-processing-threshold": -10.0,
            "post-filter-beta": 0.02
          },
          "limiter#0": {
            "alr": false,
            "alr-attack": 5.0,
            "alr-knee": 0.0,
            "alr-release": 50.0,
            "attack": 1.0,
            "bypass": false,
            "dithering": "16bit",
            "external-sidechain": false,
            "gain-boost": true,
            "input-gain": 0.0,
            "lookahead": 5.0,
            "mode": "Herm Wide",
            "output-gain": 0.0,
            "oversampling": "Half x2(2L)",
            "release": 20.0,
            "sidechain-preamp": 0.0,
            "stereo-link": 100.0,
            "threshold": -3.0
          },
          "plugins_order": [
            "deepfilternet#0",
            "stereo_tools#0",
            "compressor#0",
            "limiter#0"
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
