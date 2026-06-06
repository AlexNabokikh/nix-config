{...}: {
  # Install VSCode server for this user
  imports = [
    (let
      vscodeSrv = fetchTarball {
        url = "https://github.com/msteen/nixos-vscode-server/tarball/master";
        sha256 = "0xjal4zcbmdjdaspfkjbpx1680q7390wfzmj7iad04kp3pc9syf8";
      };
    in "${vscodeSrv}/modules/vscode-server/home.nix")
  ];
  services.vscode-server.enable = true;
}
