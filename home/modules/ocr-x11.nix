{pkgs, ...}: {
  # Ensure required packages for OCR installed
  home.packages = with pkgs; [
    maim
    tesseract
    xclip
  ];
}
