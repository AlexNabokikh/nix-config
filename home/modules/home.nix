{username, ...}: {
  # Home-Manager configuration for the user's home environment
  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
  };
}
