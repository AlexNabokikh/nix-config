{...}: {
  # Gen AI models runner
  services.ollama = {
    enable = true;
    # Enable AMD GPU acceleration
    # acceleration = "rocm";
  };
}
