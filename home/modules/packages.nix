{pkgs, ...}: {
  # ensure common packages are installed
  home.packages = with pkgs;
    [
      awscli2
      dig
      docker
      du-dust
      eza
      fd
      jq
      kubectl
      lazydocker
      nh
      openconnect
      pipenv
      python3
      ripgrep
      terraform
      terragrunt
    ]
    ++ lib.optionals stdenv.isDarwin [
      colima
    ]
    ++ lib.optionals (!stdenv.isDarwin) [
      anki
      pavucontrol
      pulseaudio
      tesseract
      unzip
      wl-clipboard
    ];
}
