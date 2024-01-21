{pkgs, ...}: {
  # Ensure saml2aws package installed
  home.packages = with pkgs; [
    saml2aws
  ];

  # Set session duration via env vars
  home.sessionVariables = {
    SAML2AWS_SESSION_DURATION = "3600";
  };
}
