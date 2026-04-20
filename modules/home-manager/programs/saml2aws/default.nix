{
  flake.modules.homeManager.programsSaml2aws =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.saml2aws ];

      home.sessionVariables = {
        AWS_REGION = "eu-west-1";
        SAML2AWS_SESSION_DURATION = "3600";
      };
    };
}
