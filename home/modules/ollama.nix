# Module: Ollama
# Purpose: Configures Ollama local AI model manager
# Platform: macOS
{
  config,
  lib,
  ...
}: {
  homebrew.globalTaps = ["ollama/ollama"];
  homebrew.casks = ["ollama"];

  home.sessionVariables = {
    OLLAMA_MODELS = "${config.home.homeDirectory}/ollama/models";
  };

  launchd.agents.ollama = {
    enable = true;
    config = {
      RunAtLoad = true;
      EnvironmentVariables = {
        OLLAMA_MODELS = "${config.home.homeDirectory}/ollama/models";
      };
    };
  };
}
