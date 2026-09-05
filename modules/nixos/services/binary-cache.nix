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
      "https://attic.services.itssho.my/sunrise"
      "https://attic.services.itssho.my/sunset"
    ];
    trusted-public-keys = ["sunrise:/7pI1oAoU8oO1b5DiJIrv/V6oYeUE8kfD2t2sgeti98=" "sunset:S+4aNsqbQNAvBfSLS/q/dmiOY7MK272I2AEOFqmrvs0="];
    netrc-file = config.sops.templates.netrc.path;
  };
}
