{ ... }:
{
  # Install and configure Golang via home-manager module
  programs.go = {
    enable = true;
    env = {
      GOBIN = "go/bin";
      GOPATH = "go";
    };
  };

  # Ensure Go bin in the PATH
  home.sessionPath = [
    "$HOME/go/bin"
  ];
}
