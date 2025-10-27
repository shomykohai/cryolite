{frostix, ...}: {
  services.udev = {
    packages = [frostix.mtkclient-git];
  };
}
