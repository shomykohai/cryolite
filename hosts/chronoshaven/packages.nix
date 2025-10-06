{
  pkgs,
  pkgsUnstable,
  frostix,
  ...
}: let
  # Stable packages
  stablePackages = with pkgs; [
    ghidra-bin
    eclipses.eclipse-java
    frostix.dex2jar
    jadx
    android-studio
  ];

  # Up to date packages
  unstablePackages = with pkgsUnstable; [
  ];
in {
  environment.systemPackages = stablePackages ++ unstablePackages;
}
