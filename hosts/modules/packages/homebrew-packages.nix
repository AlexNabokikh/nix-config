_: {
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap"; # Remove outdated versions and unused packages
      upgrade = true;
    };

    # Homebrew Additional Repositories (kept for casks)
    taps = [
      "nikitabobko/tap"
      "powershell/tap"
      "Adembc/homebrew-tap"
      "manaflow-ai/cmux"
    ];

    casks = [
      #* AI Tools
      # "claude" # Claude AI client
      "claude-code" # Claude CLI
      # "chatgpt" # ChatGPT desktop client
      # "kiro" # AI editor
      # "antigravity" # AI coding assistant
      # "ollama-app" # Local AI model manager and runner
      # "block-goose" # AI coding agent
      "cmux" # AI terminal multiplexer
      "codex" # Codex desktop client
      "claudebar"
      "cursor" # AI editor
      "block-goose" # AI coding assistant
      "lm-studio" # Local AI model runner and chat interface
      "opencode-desktop"

      #* Authentication & Security
      "1password" # Secure password manager
      "1password-cli" # Command-line interface for 1Password

      #* 3D Printing
      # "autodesk-fusion"
      "bambu-studio" # 3D printer
      # "openscad@snapshot"
      # "blender"

      #* Productivity & Utilities
      # "rectangle"
      # "tolaria"
      "capacities" # Connected knowledge management tool
      "fliqlo" # Digital clock screensaver
      "hiddenbar" # Menu bar icon organization tool
      # "keycastr"
      # "hyperkey"
      "keyclu"
      "numi" # Calculator and unit converter
      # "shottr"
      "appcleaner" # Thorough app uninstaller
      # "tailscale" #! installed from App Store
      "wifiman"
      "clop" # Clipboard manager
      # "disk-inventory-x"
      "daisydisk" # Disk space analyzer
      # "transmission"

      #* DevOps & Containers
      # "headlamp"
      "freelens" # Kubernetes IDE (OpenLens)
      "orbstack" # Fast, lightweight Docker alternative
      # "vagrant"

      #* Virtualization
      "citrix-workspace" # Client for virtual desktops

      #* Display & Graphics
      "displaylink" # Driver for USB display adapters

      #* System Enhancements
      "aerospace" # Tiling window manager for macOS
      "commander-one" # Dual-pane file manager
      "raycast" # Spotlight replacement and productivity launcher
      "stats" # System monitoring tool for macOS menubar

      #* Development Tools
      "gcloud-cli" # Google Cloud SDK command-line tools
      "obsidian" # Knowledge base and note-taking tool
      # "logseq"
      "powershell" # Cross-platform automation tool
      "termius" # Cross-platform SSH client and terminal
      "visual-studio-code" # Code editor
      # "zed"
      "pycharm" # IDE for Python development
      # "ghostty"
      "warp" # Modern terminal with AI features

      #* Browsers & Communication
      # "vivaldi"
      "discord" # Communication platform
      "brave-browser" # Privacy-focused web browser
      "netdownloadhelpercoapp"
      "telegram" # Messaging application
      "whatsapp" # Secure messaging application
      # "zen-browser"
      "microsoft-teams"

      #* Media Players
      "iina" # Modern media player for macOS

      #* Gaming
      # "steam"

      #* Fonts
      "font-hack-nerd-font" # Developer-oriented font with programming glyphs

      #* Database Tools
      "beekeeper-studio" # Modern SQL client
    ];
  };
}
