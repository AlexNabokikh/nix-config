{
  flake.modules.nixos.zsh =
    { config, pkgs, ... }:
    {
      programs.zsh.enable = true;
      users.users.${config.primaryUser}.shell = pkgs.zsh;
    };

  flake.modules.homeManager.zsh =
    {
      lib,
      pkgs,
      ...
    }:
    {
      programs.zsh = {
        enable = true;
        shellAliases = {
          ff = "fastfetch";

          # git
          gaa = "git add --all";
          gcam = "git commit --all --message";
          gcl = "git clone";
          gco = "git checkout";
          ggl = "git pull";
          ggp = "git push";

          # OpenTofu/Terraform compatibility
          terraform = "tofu";

          # kubectl
          k = "kubectl";
          kctx = "kubectx";
          kns = "kubens";
          kgno = "kubectl get node";
          kdno = "kubectl describe node";
          kgp = "kubectl get pods";
          kep = "kubectl edit pods";
          kdp = "kubectl describe pods";
          kdelp = "kubectl delete pods";
          kgs = "kubectl get svc";
          kes = "kubectl edit svc";
          kds = "kubectl describe svc";
          kdels = "kubectl delete svc";
          kgi = "kubectl get ingress";
          kei = "kubectl edit ingress";
          kdi = "kubectl describe ingress";
          kdeli = "kubectl delete ingress";
          kgns = "kubectl get namespaces";
          kens = "kubectl edit namespace";
          kdns = "kubectl describe namespace";
          kdelns = "kubectl delete namespace";
          kgd = "kubectl get deployment";
          ked = "kubectl edit deployment";
          kdd = "kubectl describe deployment";
          kdeld = "kubectl delete deployment";
          kgsec = "kubectl get secret";
          kdsec = "kubectl describe secret";
          kdelsec = "kubectl delete secret";

          pt = "podman-tui";

          v = "nvim";
          vi = "nvim";
          vim = "nvim";

          ls = "eza --icons always"; # default view
          ll = "eza -bhl --icons --group-directories-first"; # long list
          la = "eza -abhl --icons --group-directories-first"; # all list
          lt = "eza --tree --level=2 --icons"; # tree
        }
        // lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
          open = "xdg-open";
        };
        initContent = ''
          # bindings
          bindkey -e
          bindkey '^H' backward-delete-word
          bindkey '^[[1;5C' forward-word
          bindkey '^[[1;5D' backward-word

          # open commands in $EDITOR with C-v
          autoload -z edit-command-line
          zle -N edit-command-line
          bindkey "^v" edit-command-line

          ${lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
            # Enable ALT-C fzf keybinding on Mac
            bindkey 'ć' fzf-cd-widget
          ''}
        '';
      };
    };
}
