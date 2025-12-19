{
  config,
  getSecret,
  inputs,
  lib,
  ...
}: let
  mkGit = import ../../../lib/mkGit.nix;
in {
  sops.secrets."git/signing-key" = {
    format = "yaml";
    sopsFile = "${inputs.secrets-flake}/secrets.yaml";
    owner = "shomy";
    mode = "0400";
  };

  homix.".gitconfig" = {
    text = mkGit {
      inherit lib;
      config = {
        user = {
          name = getSecret "git.name";
          email = getSecret "git.email";
          signingkey = config.sops.secrets."git/signing-key".path;
        };
        init.defaultBranch = "main";
        gpg.format = "ssh";
        commit.gpgsign = true;
        tag.gpgsign = true;
      };
    };
  };
}
