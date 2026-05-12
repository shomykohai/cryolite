{
  pkgs,
  pkgsUnstable,
  frostix,
  ...
}: let
  # Stable packages
  stablePackages = [
    frostix.dex2jar
    pkgs.jadx
    pkgs.musescore
    # UART!!
    pkgs.tio
    # MediaTek stuff!!
    frostix.antumbra
  ];

  # Up to date packages
  unstablePackages = [
    pkgsUnstable.ghidra-bin
  ];
in {
  environment.systemPackages = stablePackages ++ unstablePackages;
}
