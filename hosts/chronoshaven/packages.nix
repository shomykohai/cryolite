{
  pkgs,
  pkgsUnstable,
  frostix,
  ...
}: let
  # Stable packages
  stablePackages = with pkgs; [
    ghidra-bin
    frostix.dex2jar
    jadx
    musescore
  ];

  # Up to date packages
  unstablePackages = with pkgsUnstable; [
  ];
in {
  environment.systemPackages = stablePackages ++ unstablePackages;
}
