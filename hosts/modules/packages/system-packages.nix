{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    #* AI Tools
    gemini-cli # AI-powered command-line interface
    llmfit
    ollama # Local AI model manager and runner
    opencode # AI coding agent for the terminal

    #* DevOps & Infrastructure
    ansible # IT automation and configuration management
    awscli2 # AWS Command Line Interface
    cloudflared # Cloudflare Tunnel client
    docker-compose # Multi-container Docker application tool
    doppler # Doppler CLI for secrets management
    gh # GitHub CLI
    hcp # HashiCorp Cloud Platform CLI
    kubernetes-helm # Kubernetes package manager
    k3d # Lightweight Kubernetes in Docker
    kubectl # Kubernetes command-line tool
    kubectx # Switch between Kubernetes contexts
    lazydocker # Terminal UI for Docker management
    opentofu # Open-source infrastructure as code tool
    packer # Infrastructure as code tool for image building
    talosctl # CLI for managing Talos Linux clusters
    terraform # Infrastructure as code tool

    #* Development Tools
    codex # OpenAI Codex CLI
    delta # Enhanced git diff viewer
    direnv # Environment variable manager
    glow # Markdown terminal viewer
    gnupg # GNU Privacy Guard
    hugo # Fast static site generator
    mise # Runtime environment manager
    tree-sitter # Parser generator for nvim-treesitter

    #* Networking
    doggo # DNS client
    lazyssh # Minimal SSH config tool
    nmap # Network exploration tool

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
    ruff # Extremely fast Python linter
    uv # Fast Python package installer and resolver

    #* System Utilities
    bashInteractive # Modern GNU Bash shell
    dust # Intuitive disk usage analyzer
    duf # Disk usage statistics utility
    home-manager # Nix user environment manager
    nh # Nix command wrapper and helper
    mkpasswd # Generate hashed passwords
    openconnect # VPN client
    pre-commit # Git pre-commit hook framework
    sshpass # Non-interactive SSH password auth
    sops # Secrets management tool
    tree # Directory structure viewer

    #* Modern CLI Replacements
    eza # Modern replacement for ls
    fd # Friendly alternative to find
    ripgrep # Fast alternative to grep
    zoxide # Smarter cd command

    #* Task Runners and Processors
    go-task # Task runner for Go projects
    jq # Command-line JSON processor
    just # Modern command runner
    yq # Command-line YAML processor

    #* Terminal Recording
    vhs # Terminal GIF/video recorder

    #* Miscellaneous
    cmatrix # Terminal Matrix animation
  ];
}
