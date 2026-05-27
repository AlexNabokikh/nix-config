{pkgs, ...}: {
  environment = {
    systemPackages = with pkgs; [
      #* DevOps & Infrastructure
      ansible # IT automation and configuration management
      # awscli2 # AWS Command Line Interface for managing AWS services - temporarily disabled due to hash mismatch
      cloudflared # Cloudflare Tunnel client
      doppler # Doppler CLI for secrets management
      hcp # HashiCorp Cloud Platform CLI for managing HashiCorp cloud resources
      kubernetes-helm # Kubernetes package manager
      k3d # Lightweight Kubernetes in Docker
      kubectl # Kubernetes command-line tool
      lazydocker # Terminal UI for Docker management and monitoring
      oci-cli # Oracle Cloud Infrastructure CLI
      packer # Infrastructure as code tool for image building
      terraform # Infrastructure as code tool for infrastructure provisioning
      terraformer # Terraform state management tool for importing existing resources

      #* Development Tools
      codex # OpenAI Codex CLI
      delta # Enhanced git diff viewer with syntax highlighting
      direnv # Environment variable manager for project-specific environments
      glow # Markdown terminal viewer from Charmbracelet
      gnupg # GNU Privacy Guard for encryption and signing
      tree-sitter # Parser generator tool and incremental parsing library for nvim-treesitter

      #* Networking
      doggo # DNS client

      #* Language-Specific Tools
      bun # JavaScript runtime and package manager
      nodejs # JavaScript runtime environment
      (python3.withPackages (ps:
        with ps; [
          dnspython # DNS toolkit for Python
          jmespath # JSON query language for Python
          pip # Python package installer
          virtualenv # Python virtual environment creator
        ]))
      pipenv # Python dependency management tool

      #* System Utilities
      dust # Intuitive disk usage analyzer with visual output
      duf # Disk usage statistics utility with friendly UI
      home-manager # Nix user environment manager
      nh # Nix command wrapper and helper
      mkpasswd # Generate hashed passwords
      openconnect # VPN client compatible with Cisco AnyConnect
      pre-commit # Git pre-commit hook framework
      sshpass # Non-interactive ssh password authentication
      sops # Secrets management tool
      tree # Directory structure viewer

      #* Modern CLI Replacements
      eza # Modern replacement for ls with more features
      fd # User-friendly alternative to find
      ripgrep # Fast alternative to grep with better syntax

      #* Task Runners and Processors
      go-task # Task runner for Go projects
      jq # Command-line JSON processor
      just # Modern command runner alternative to make
      yq # Command-line YAML processor

      #* Terminal Recording
      vhs # Terminal GIF/video recorder with code-based scripting

      #* Miscellaneous
      cmatrix # Terminal based "The Matrix" like animation
    ];
  };
}
