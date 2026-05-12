{
  pkgs,
  pkgsUnstable,
  ...
}: let
  # Stable packages
  stablePackages = builtins.attrValues {
    inherit (pkgs)
    ghidra-bin
    dex2jar
    jadx
    # Music
    musescore
    ;
  };

  # Up to date packages
  unstablePackages = builtins.attrValues {
    # inherit (pkgsUnstable)
  };
in {
  environment.systemPackages = stablePackages ++ unstablePackages;
}
