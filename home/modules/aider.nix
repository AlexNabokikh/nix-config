# Module: Aider Configuration
# Purpose: Configure Aider AI pair programming tool with OpenRouter LLM support
# Platform: All
{
  config,
  pkgs,
  ...
}: {
  # Install aider via homebrew (nixpkgs-unstable has test failures)
  # Use: brew install aider-chat
  # home.packages = with pkgs; [
  #   aider-chat
  # ];

  # Configure aider with OpenRouter
  home.file.".aider.conf.yml" = {
    text = ''
      # Aider Configuration
      # See: https://aider.chat/docs/config/

      # Use OpenRouter for LLM
      model: openrouter/stepfun/step-3.5-flash:free
      openai-api-base: https://openrouter.ai/api/v1

      # Recommended settings for better experience
      auto-commits: true
      auto-lint: true
      dark-mode: true
    '';
  };
}
