{
  pkgs,
  pkgsUnstable,
  frostix,
  ...
}: let
  # Stable packages
  stablePackages = with pkgs; [
    frostix.dex2jar
    jadx
    musescore
    # UART!!
    tio
    # MediaTek stuff!!
    frostix.antumbra
  ];

  # Up to date packages
  unstablePackages = with pkgsUnstable; [
    ghidra-bin
  ];
in {
  environment.systemPackages = stablePackages ++ unstablePackages;
}
