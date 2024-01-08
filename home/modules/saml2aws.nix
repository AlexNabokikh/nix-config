{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # List of packages installed for the user
  home.packages = with pkgs; [
    saml2aws
  ];

  # Environment session variables
  home.sessionVariables = {
    SAML2AWS_SESSION_DURATION = "3600";
  };
}
