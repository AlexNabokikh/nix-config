{
  config,
  lib,
  pkgs,
  ...
}:
let
  copyCmd = if pkgs.stdenv.hostPlatform.isDarwin then "pbcopy" else "wl-copy";
in
{
  programs = {
    zsh = {
      enable = true;
      defaultKeymap = "viins";
      shellAliases = {
        ff = "fastfetch --structure-disabled title";
        pt = "podman-tui";
        terraform = "tofu";
      };
      initContent = lib.mkMerge [
        (lib.optionalString pkgs.stdenv.hostPlatform.isLinux ''
          open() {
            xdg-open "$@" </dev/null >/dev/null 2>&1 &!
          }
        '')
        (lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
          # macOS terminal/keyboard mapping for ALT-C (Polish language layout).
          bindkey 'ć' fzf-cd-widget
        '')
      ];
    };

    # Atuin owns Ctrl-R; fzf's history widget is disabled below to avoid conflict.
    atuin = {
      enable = true;
      settings = {
        inline_height = 25;
        invert = true;
        search_mode = "fuzzy";
      };
      flags = [ "--disable-up-arrow" ];
    };

    fzf = {
      enable = true;
      historyWidget.command = "";
      defaultOptions = [
        "--bind '?:toggle-preview'"
        "--bind 'ctrl-e:execute(nvim -- {+})'"
        "--bind 'ctrl-y:execute-silent(echo {+} | ${copyCmd})'"
        "--color=base16,gutter:-1,border:bright-black"
        "--height=40%"
        "--info=inline"
        "--layout=reverse"
        "--marker='✓'"
        "--pointer='▶'"
        "--prompt='~ '"
      ];
    };

    eza = {
      enable = true;
      extraOptions = [ "--group-directories-first" ];
    };

    fastfetch.enable = true;

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
  };

  xdg.configFile."fastfetch/config.jsonc".source =
    "${config.programs.fastfetch.package}/share/fastfetch/presets/examples/12.jsonc";
}
