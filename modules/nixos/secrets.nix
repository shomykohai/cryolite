{
  lib,
  config,
  inputs,
  ...
}: let
  # Is hardcoding this a good idea? Perhaps, I might consider
  # making it configurable, but whatever :3
  vault = inputs.secrets-flake.vault or {};

  # Showcasing the pipe operator cause why not?
  getSecret = secretPath:
    secretPath
    |> lib.strings.splitString "."
    |> (path: lib.attrByPath path null vault)
    |> (
      value:
      # It wasn't working, thus I had to check every case.
      ## TODO: Find out which one is the what fixed the issue
        if builtins.isString value
        then value
        else if builtins.isAttrs value && value != {}
        then builtins.head (builtins.attrValues value)
        else if value != null
        then builtins.toString value
        else ""
    );
in {
  options = {
    secrets.ageKeyPath = lib.mkOption {
      type = lib.types.str;
      default = null;
      description = "Path to the age key file used by sops.";
    };
  };

  config = {
    sops.defaultSopsFile = "${inputs.secrets-flake}/secrets.yaml";
    sops.defaultSopsFormat = "yaml";

    sops.age.keyFile = config.secrets.ageKeyPath;
    # Good Idea? Surely not. Do I care? Not really.
    _module.args = {
      getSecret = getSecret;
    };
  };
}
