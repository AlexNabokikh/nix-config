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
            "attack": 5.0,
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
            "release": 75.0,
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
            "threshold": -20.0,
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
          "deesser#0": {
            "bypass": false,
            "detection": "RMS",
            "f1-freq": 3000.0,
            "f1-level": -6.0,
            "f2-freq": 5000.0,
            "f2-level": -6.0,
            "f2-q": 1.5000000000000004,
            "input-gain": 0.0,
            "laxity": 15,
            "makeup": 0.0,
            "mode": "Wide",
            "output-gain": 0.0,
            "ratio": 5.0,
            "sc-listen": false,
            "threshold": -20.0
          },
          "equalizer#0": {
            "balance": 0.0,
            "bypass": false,
            "input-gain": 0.0,
            "left": {
              "band0": {
                "frequency": 50.0,
                "gain": 3.0,
                "mode": "RLC (BT)",
                "mute": false,
                "q": 0.7,
                "slope": "x1",
                "solo": false,
                "type": "Hi-pass",
                "width": 4.0
              },
              "band1": {
                "frequency": 90.0,
                "gain": 3.0,
                "mode": "RLC (MT)",
                "mute": false,
                "q": 0.7,
                "slope": "x1",
                "solo": false,
                "type": "Lo-shelf",
                "width": 4.0
              },
              "band2": {
                "frequency": 425.0,
                "gain": -2.0,
                "mode": "BWC (MT)",
                "mute": false,
                "q": 0.9999999999999998,
                "slope": "x2",
                "solo": false,
                "type": "Bell",
                "width": 4.0
              },
              "band3": {
                "frequency": 3500.0,
                "gain": 3.0,
                "mode": "BWC (BT)",
                "mute": false,
                "q": 0.7,
                "slope": "x2",
                "solo": false,
                "type": "Bell",
                "width": 4.0
              },
              "band4": {
                "frequency": 9000.0,
                "gain": 2.0,
                "mode": "LRX (MT)",
                "mute": false,
                "q": 0.7,
                "slope": "x1",
                "solo": false,
                "type": "Hi-shelf",
                "width": 4.0
              }
            },
            "mode": "IIR",
            "num-bands": 5,
            "output-gain": 0.0,
            "pitch-left": 0.0,
            "pitch-right": 0.0,
            "right": {
              "band0": {
                "frequency": 50.0,
                "gain": 3.0,
                "mode": "RLC (BT)",
                "mute": false,
                "q": 0.7,
                "slope": "x1",
                "solo": false,
                "type": "Hi-pass",
                "width": 4.0
              },
              "band1": {
                "frequency": 90.0,
                "gain": 3.0,
                "mode": "RLC (MT)",
                "mute": false,
                "q": 0.7,
                "slope": "x1",
                "solo": false,
                "type": "Lo-shelf",
                "width": 4.0
              },
              "band2": {
                "frequency": 425.0,
                "gain": -2.0,
                "mode": "BWC (MT)",
                "mute": false,
                "q": 0.9999999999999998,
                "slope": "x2",
                "solo": false,
                "type": "Bell",
                "width": 4.0
              },
              "band3": {
                "frequency": 3500.0,
                "gain": 3.0,
                "mode": "BWC (BT)",
                "mute": false,
                "q": 0.7,
                "slope": "x2",
                "solo": false,
                "type": "Bell",
                "width": 4.0
              },
              "band4": {
                "frequency": 9000.0,
                "gain": 2.0,
                "mode": "LRX (MT)",
                "mute": false,
                "q": 0.7,
                "slope": "x1",
                "solo": false,
                "type": "Hi-shelf",
                "width": 4.0
              }
            },
            "split-channels": false
          },
          "gate#0": {
            "attack": 1.0,
            "bypass": false,
            "curve-threshold": -50.0,
            "curve-zone": -2.0,
            "dry": -100.0,
            "hpf-frequency": 10.0,
            "hpf-mode": "off",
            "hysteresis": true,
            "hysteresis-threshold": -3.0,
            "hysteresis-zone": -1.0,
            "input-gain": 0.0,
            "lpf-frequency": 20000.0,
            "lpf-mode": "off",
            "makeup": 1.0,
            "output-gain": 3.0,
            "reduction": -15.0,
            "release": 200.0,
            "sidechain": {
              "input": "Internal",
              "lookahead": 0.0,
              "mode": "RMS",
              "preamp": 0.0,
              "reactivity": 10.0,
              "source": "Middle",
              "stereo-split-source": "Left/Right"
            },
            "stereo-split": false,
            "wet": -1.0
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
            "release": 5.0,
            "sidechain-preamp": 0.0,
            "stereo-link": 100.0,
            "threshold": -1.0
          },
          "plugins_order": [
            "deepfilternet#0",
            "stereo_tools#0",
            "gate#0",
            "deesser#0",
            "compressor#0",
            "equalizer#0",
            "speex#0",
            "limiter#0"
          ],
          "speex#0": {
            "bypass": false,
            "enable-agc": false,
            "enable-denoise": false,
            "enable-dereverb": false,
            "input-gain": 0.0,
            "noise-suppression": -70,
            "output-gain": 0.0,
            "vad": {
              "enable": true,
              "probability-continue": 90,
              "probability-start": 95
            }
          },
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
