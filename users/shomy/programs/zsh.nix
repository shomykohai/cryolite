{pkgs, ...}: {
  programs.pay-respects = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    autosuggestions.async = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch --flake $HOME/.dotfiles#$(hostname)";
      py-venv = "python -m venv .venv && source .venv/bin/activate";
      ws = "cd ~/workspace";
      nd = "nix develop";
    };

    ohMyZsh = {
      enable = true;
      plugins = ["git"];
      theme = "awesomepanda";
    };
    histSize = 10000;

    interactiveShellInit = ''
      # Set up fpath for completions
      typeset -U path cdpath fpath manpath
      for profile in ''${(z)NIX_PROFILES}; do
        fpath+=($profile/share/zsh/site-functions $profile/share/zsh/$ZSH_VERSION/functions $profile/share/zsh/vendor-completions)
      done

      # Oh-My-Zsh Configuration
      export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh
      plugins=(git)
      ZSH_THEME="awesomepanda"
      source $ZSH/oh-my-zsh.sh

      # Autosuggestions (needs to be after oh-my-zsh)
      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      ZSH_AUTOSUGGEST_STRATEGY=(history)

      # Pay-respects setup
      eval "$(${pkgs.pay-respects}/bin/pay-respects zsh --alias)"

      # Ghostty integration
      if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
        source "$GHOSTTY_RESOURCES_DIR"/shell-integration/zsh/ghostty-integration
      fi

      # Syntax highlighting (load last)
      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
      ZSH_HIGHLIGHT_HIGHLIGHTERS+=()


      export WORKSPACE="/mnt/workspace"
      export GITHUB="$WORKSPACE/GitHub"

      ws() {
        cd "$WORKSPACE"
      }

      wsg() {
        if [[ -z "$1" ]]; then
          cd "$GITHUB"
        else
          cd "$GITHUB/$1"
        fi
      }

      _wsg() {
        local -a dirs
        dirs=()
        for dir in "$GITHUB"/*/; do
          [[ -d "$dir" ]] && dirs+=("$(basename "$dir")")
        done
        _describe 'projects' dirs
      }

      ns() {
        nix-shell "$@"
      }

      compdef _wsg wsg
    '';
  };
}
