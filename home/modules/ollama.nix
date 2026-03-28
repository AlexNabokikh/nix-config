# Module: Ollama
# Purpose: Configures Ollama local AI model manager
# Platform: macOS
{config, ...}: {
  home.sessionVariables = {
    OLLAMA_MODELS = "${config.home.homeDirectory}/ollama/models";
  };
}
