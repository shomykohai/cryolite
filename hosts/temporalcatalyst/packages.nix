{
  pkgs,
  pkgsUnstable,
  ...
}: let
  # Stable packages
  stablePackages = with pkgs; [
    ghidra-bin
    dex2jar
    jadx
    # Music
    musescore
  ];

  # Up to date packages
  unstablePackages = with pkgsUnstable; [
  ];
in {
  environment.systemPackages = stablePackages ++ unstablePackages;
}
