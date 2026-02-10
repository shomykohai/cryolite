{config, ...}: {
  sops.secrets."cache/attic-token" = {};

  sops.templates.netrc = {
    content = ''
      machine attic.services.itssho.my
        login token
        password ${config.sops.placeholder."cache/attic-token"}
    '';
    owner = "root";
    group = "root";
    mode = "0600";
  };

  nix.settings = {
    substituters = [
      "https://attic.services.itssho.my/umbra"
    ];
    trusted-public-keys = ["umbra:hogFc/tNDw5cXhdBfFagDNEEiR6NGspXBzyVJhzka/4="];
    netrc-file = config.sops.templates.netrc.path;
  };
}
