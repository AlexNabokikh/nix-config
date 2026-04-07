{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      formatter = pkgs.nixfmt;
    };
}
