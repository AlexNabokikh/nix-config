{ lib, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    defaultKeymap = "viins";
    initContent = lib.optionalString pkgs.stdenv.hostPlatform.isLinux ''
      open() {
        xdg-open "$@" </dev/null >/dev/null 2>&1 &!
      }
    '';
  };
}
