_: {
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap"; # Remove outdated versions and unused packages
      upgrade = true;
    };

    # Homebrew Additional Repositories
    taps = [
      "nikitabobko/tap"
      "powershell/tap"
      "Adembc/homebrew-tap"
    ];

    brews = [
      #* AI Tools
      "lazyssh"
      "gemini-cli" # AI-powered command-line interface

      #* DevOps & Infrastructure
      "awscli" # AWS Command Line Interface
      "docker-compose" # Tool for defining and running multi-container Docker applications
      # "doppler" # Doppler CLI for secrets management
      "helm" # Kubernetes package manager
      "k3d" # Lightweight Kubernetes in Docker
      "kubectx" # Switch between Kubernetes contexts
      "kubectl" # Kubernetes command-line tool
      "opentofu" # Open-source infrastructure as code tool

      #* Networking
      "nmap" # Network exploration and security auditing tool

      #* Development Tools (CLI)
      "hugo" # Fast static site generator
      "mise"
      "nodejs" # JavaScript runtime environment
      "ruff" # Extremely fast Python linter

      "bash" # Unix shell and command language
      "uv" # Extremely fast Python package installer and resolver, written in Rust
      "lazyssh"
    ];

    casks = [
      #* AI Tools
      "kiro" #  AI editor
      # "claude" # Claude AI client
      "cursor" # AI  editor
      "lm-studio" # Local AI model runner and chat interface

      #* Authentication & Security
      "1password" # Secure password manager
      "1password-cli" # Command-line interface for 1Password

      #* 3D printing
      # "autodesk-fusion" # 3D modeling and design software
      "bambu-studio" # 3D printer
      "openscad@snapshot" # Open-source 3D CAD software
      # "blender" # 3D design

      #* Productivity & Utilities
      # "rectangle" # Window management for macOS
      "notion" # All-in-one workspace for notes, tasks, and collaboration
      "capacities" # Connected knowledge management tool
      "fliqlo" # Digital clock screensaver
      "hiddenbar" # Menu bar icon organization tool
      # "keycastr" # Show keystrokes in the menu bar
      "hyperkey"
      "keyclu"
      "numi" # Calculator and unit converter
      "shottr" # Feature-rich screenshot tool
      "appcleaner" # Thorough app uninstaller
      # "tailscale" # Zero trust VPN #! installed from App Store
      "wifiman"
      "clop" # Clipboard manager
      "disk-inventory-x" # Disk inventory tool
      "daisydisk" # Disk space analyzer
      # "transmission" # Lightweight BitTorrent client

      #* DevOps & Containers
      "lens" # Kubernetes IDE (OpenLens)
      "orbstack" # Fast, lightweight Docker and Linux machine alternative
      "vagrant" # Tool for building and managing virtual machine environments

      #* Virtualization
      "citrix-workspace" # Client for accessing virtual desktops and applications

      #* Display & Graphics
      "displaylink" # Driver for USB display adapters

      #* System Enhancements
      "aerospace" # Tiling window manager for macOS
      "commander-one" # Dual-pane file manager for macOS
      "raycast" # Powerful spotlight replacement and productivity launcher
      "stats" # System monitoring tool for macOS menubar

      #* Development Tools
      "gcloud-cli" # Google Cloud SDK command-line tools
      "obsidian" # Powerful knowledge base and note-taking tool
      "powershell" # Cross-platform automation and configuration tool
      "termius" # Cross-platform SSH client and terminal
      "visual-studio-code" # Popular code editor
      "pycharm" # IDE for Python development
      "warp" # Modern terminal with AI featuresj

      #* Browsers & Communication
      "vivaldi" # Feature-rich web browser with customization options
      "brave-browser" # Privacy-focused web browser with ad blocker
      "netdownloadhelpercoapp"
      "telegram" # Messaging application
      "whatsapp" # Secure messaging application      # "zen-browser" # Privacy-focused web browser
      "microsoft-teams"

      #* Media Players
      "iina" # Modern media player for macOS

      #* Gaming
      # "steam" # Gaming platform and digital distribution service

      #* Fonts
      "font-hack-nerd-font" # Developer-oriented font with glyphs for programming
    ];
  };
}
