{frostix, ...}: {
  services.udev = {
    packages = [frostix.mtkclient-git];
    extraRules = ''
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0e8d", ATTRS{idProduct}=="0003", TAG+="uaccess"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0e8d", ATTRS{idProduct}=="2000", TAG+="uaccess"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0e8d", ATTRS{idProduct}=="2001", TAG+="uaccess"
    '';
  };
}
