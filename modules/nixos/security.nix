{pkgs, ...}: {
  # Secret management
  environment.systemPackages = [
    pkgs.sops
  ];

  security = {
    sudo.enable = false;
    sudo-rs.enable = true;
    sudo-rs.extraConfig = ''
      Defaults env_keep += "SSH_AUTH_SOCK"
    '';
    polkit.enable = true;
    rtkit.enable = true; # Needed for realtime audio apparently

    # pam = {
    #   services = {
    #     login = {
    #       enableGnomeKeyring = true; # Enable GNOME Keyring integration
    #     };
    #   };
    # };
  };
}
