{
  inputs,
  config,
  ...
}: {
  sops.secrets."ssh/priv" = {
    format = "yaml";
    sopsFile = "${inputs.secrets-flake}/hosts/${config.networking.hostName}.yaml";
    owner = "shomy";
    mode = "0400";
    path = "/home/shomy/.ssh/id_ed25519";
  };
}
