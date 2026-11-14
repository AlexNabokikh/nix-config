{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    kubectl
    kubectx
  ];

  programs.zsh.shellAliases = {
    k = "kubectl";
    kctx = "kubectx";
    kns = "kubens";
  };

  stylix.targets.k9s.enable = true;

  programs.k9s = {
    enable = true;
    settings.k9s = {
      ui = {
        headless = true;
        logoless = true;
      };
    };
    hotKeys = {
      shift-1 = {
        shortCut = "Shift-1";
        description = "Show pods";
        command = "pods";
      };
      shift-2 = {
        shortCut = "Shift-2";
        description = "Show deployments";
        command = "dp";
      };
      shift-3 = {
        shortCut = "Shift-3";
        description = "Show nodes";
        command = "nodes";
      };
      shift-4 = {
        shortCut = "Shift-4";
        description = "Show services";
        command = "services";
      };
      shift-5 = {
        shortCut = "Shift-5";
        description = "Show Ingress";
        command = "ingress";
      };
      shift-6 = {
        shortCut = "Shift-6";
        description = "Show Pulses";
        command = "pulses";
      };
      shift-7 = {
        shortCut = "Shift-7";
        description = "Show Events";
        command = "events";
      };
    };
  };

  # The pinned Stylix target puts ui.skin at the root instead of under k9s.
  xdg.configFile."k9s/config.yaml".source = lib.mkForce (
    (pkgs.formats.yaml { }).generate "k9s-config" (
      lib.recursiveUpdate { k9s.ui.skin = "stylix"; } (removeAttrs config.programs.k9s.settings [ "ui" ])
    )
  );
}
