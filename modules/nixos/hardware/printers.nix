{pkgs, ...}: {
  hardware.sane.enable = true;
  hardware.sane.extraBackends = [pkgs.hplipWithPlugin];
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
}
