{
  config,
  lib,
  pkgs,
  ...
}:
let
  colors = config.lib.stylix.colors.withHashtag;
  copyCmd = if pkgs.stdenv.hostPlatform.isDarwin then "pbcopy" else "wl-copy";
in
{
  stylix.targets = {
    fzf.enable = true;
    starship.enable = true;
  };

  programs = {
    zsh = {
      enable = true;
      defaultKeymap = "viins";
      shellAliases.ff = "fastfetch --structure-disabled title";
      initContent = lib.mkMerge [
        (lib.mkIf pkgs.stdenv.hostPlatform.isLinux ''
          open() {
            xdg-open "$@" </dev/null >/dev/null 2>&1 &!
          }
        '')
        (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin ''
          # macOS terminal/keyboard mapping for ALT-C.
          bindkey 'ć' fzf-cd-widget
        '')
      ];
    };

    starship = {
      enable = true;
      settings = {
        add_newline = false;
        format =
          "$username$hostname$directory"
          + "$git_branch$git_commit$git_state$git_status"
          + "$nix_shell$cmd_duration"
          + "$line_break$jobs$status$character";
        kubernetes = {
          disabled = false;
          symbol = "󱃾 ";
          format = "[$symbol$context( $namespace)]($style)";
          contexts = [
            {
              context_pattern = ".*/(?P<cluster>.+)";
              context_alias = "$cluster";
            }
          ];
        };
        right_format = "$kubernetes";
      };
    };

    atuin = {
      enable = true;
      settings = {
        inline_height = 25;
        invert = true;
        search_mode = "fuzzy";
      };
      flags = [ "--disable-up-arrow" ];
    };

    eza = {
      enable = true;
      extraOptions = [ "--group-directories-first" ];
    };

    fastfetch.enable = true;

    fzf = {
      enable = true;
      historyWidget.command = "";

      defaultOptions = [
        "--bind '?:toggle-preview'"
        "--bind 'ctrl-e:execute(nvim -- {+})'"
        "--bind 'ctrl-y:execute-silent(echo {+} | ${copyCmd})'"
        "--height=40%"
        "--info=inline"
        "--layout=reverse"
        "--marker='✓'"
        "--pointer='▶'"
        "--prompt='~ '"
      ];

      # Match other TUIs: regular text instead of base04 and no rosewater highlight.
      colors = with colors; {
        fg = lib.mkForce base05;
        "fg+" = lib.mkForce base05;
        "bg+" = lib.mkForce base02;
        gutter = base00;
        border = base03;
      };
    };
  };

  xdg.configFile."fastfetch/config.jsonc".source =
    "${config.programs.fastfetch.package}/share/fastfetch/presets/examples/12.jsonc";
}
