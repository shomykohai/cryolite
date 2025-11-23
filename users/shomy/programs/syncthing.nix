{
  config,
  inputs,
  getSecret,
  ...
}: {
  # Host specific secrets
  sops.secrets."syncthing/key" = {
    format = "yaml";
    sopsFile = "${inputs.secrets-flake}/hosts/${config.networking.hostName}.yaml";
  };

  sops.secrets."syncthing/cert" = {
    format = "yaml";
    sopsFile = "${inputs.secrets-flake}/hosts/${config.networking.hostName}.yaml";
  };

  services.syncthing = {
    key = config.sops.secrets."syncthing/key".path;
    cert = config.sops.secrets."syncthing/cert".path;
    configDir = "/home/shomy/.config/syncthing";
    dataDir = "/home/shomy/.config/syncthing";
    settings = {
      devices = {
        aristotledenial.id = getSecret "syncthing.devices.aristotledenial";
        anamnesis.id = getSecret "syncthing.devices.anamnesis";
      };
      folders = {
        "obsidian-vault" = {
          id = getSecret "syncthing.folders.obsidian-vault-id";
          path = "/home/shomy/Documents/Obsidian/The Mind";
          devices = [
            "aristotledenial"
          ];
          ignorePerms = true;
        };
      };
    };
  };
}
