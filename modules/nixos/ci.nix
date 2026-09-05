{lib, ...}: {
  sops.validateSopsFiles = lib.mkForce false;
}
