{
  flake.modules.homeManager.k8s =
    { pkgs, ... }:
    let
      ks = pkgs.writeShellApplication {
        name = "ks";
        runtimeInputs = with pkgs; [
          granted
          kubectl
          kubectx
          python3
        ];
        text = ''
          exec python3 ${./scripts/bin/ks} "$@"
        '';
      };
      traverser = pkgs.writeShellApplication {
        name = "traverser";
        runtimeInputs = with pkgs; [
          kubectl
          python3
        ];
        text = ''
          exec python3 ${./scripts/bin/traverser} "$@"
        '';
      };
    in
    {
      home.packages =
        with pkgs;
        [
          kubectl
          kubectx
        ]
        ++ [
          ks
          traverser
        ];

      programs.zsh.shellAliases = {
        k = "kubectl";
        kctx = "kubectx";
        kns = "kubens";
      };

      programs.starship.settings = {
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
        helm.symbol = " ";
      };

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
    };
}
