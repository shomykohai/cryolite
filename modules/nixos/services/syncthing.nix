{
  lib,
  config,
  ...
}: {
  ## TODO: Uncouple syncthing from my user account, and make it configurable per-user basis
  services.syncthing = {
    user = "shomy";
    group = "users";
    enable = true;
    overrideDevices = true;
    overrideFolders = true;
    openDefaultPorts = true;
  };

  systemd.services.syncthing-init = {
    wantedBy = lib.mkForce (
      if config.system.desktopEnvironment != "none"
      then ["graphical.target"]
      else ["multi-user.target"]
    );
    after = lib.mkForce (
      ["syncthing.service"] ++ lib.optionals (config.system.desktopEnvironment != "none") ["graphical.target"]
    );
  };
}
