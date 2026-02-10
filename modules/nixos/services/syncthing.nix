{...}: {
  ## TODO: Uncouple syncthing from my user account, and make it configurable per-user basis
  services.syncthing = {
    user = "shomy";
    group = "users";
    enable = true;
    overrideDevices = true;
    overrideFolders = true;
    openDefaultPorts = true;
  };
}
