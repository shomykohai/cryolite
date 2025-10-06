{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.spicetify-nix.nixosModules.spicetify
  ];

  programs.spicetify = let
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
  in {
    enable = true;
    enabledExtensions = builtins.attrValues {
      inherit
        (spicePkgs.extensions)
        adblockify
        beautifulLyrics
        hidePodcasts
        ;
    };
    theme = spicePkgs.themes.onepunch;
  };
}
