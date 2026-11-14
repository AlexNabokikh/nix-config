{
  config,
  lib,
  pkgs,
  ...
}:
{
  home = {
    packages =
      with pkgs;
      [
        dig
        fd
        jq
        nh
        nodejs
        openconnect
        opentofu
        pipenv
        python3
        ripgrep
        telegram-desktop
      ]
      ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
        anki-bin
        mos
      ]
      ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
        anki
        gcc
        gnumake
        unzip
        wl-clipboard
      ];

    sessionPath = [ "${config.home.homeDirectory}/go/bin" ];
  };

  programs.zsh.shellAliases.terraform = "tofu";

  stylix.targets = {
    btop.enable = true;
    opencode.enable = true;
  };

  programs = {
    awscli.enable = true;
    brave.enable = true;
    go.enable = true;
    granted.enable = true;

    btop = {
      enable = true;
      settings = {
        vim_keys = true;
        proc_sorting = "memory";
      };
    };

    opencode = {
      enable = true;
      mutableSettings = true;
      # The pinned Stylix target generates the theme but selects it via V1's tui.json.
      tui = lib.mkForce { };
      cli.theme = {
        name = "stylix";
        mode = "dark";
      };
    };
  };
}
