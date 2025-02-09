{pkgs, ...}: {
  hardware.amdgpu.opencl.enable = true;
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [rocmPackages.clr.icd];
  };

  services.ollama = {
    enable = true;
    package = pkgs.stable.ollama;
    acceleration = "rocm";
    rocmOverrideGfx = "11.0.0";
  };
}
