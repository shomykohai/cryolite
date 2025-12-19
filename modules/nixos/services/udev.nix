{frostix, ...}: {
  services.udev = {
    packages = [frostix.mtkclient-git];
    extraRules = ''
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0e8d", ATTRS{idProduct}=="2000", MODE="0660", GROUP="dialout"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0e8d", ATTRS{idProduct}=="0003", MODE="0660", GROUP="dialout"
    '';
  };
}
