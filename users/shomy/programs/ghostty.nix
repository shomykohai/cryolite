{pkgs, ...}: {
  environment.systemPackages = [pkgs.ghostty];

  homix.".config/ghostty/config" = {
    text = ''
      theme = "Rose Pine Moon"
      shell-integration = zsh

      bold-is-bright = "true"

      keybind = ctrl+shift+r=reload_config
    '';
    copy = true;
  };
}
