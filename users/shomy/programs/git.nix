{getSecret, ...}: {
  programs.git = {
    enable = true;
    lfs.enable = true;
    config = {
      user = {
        name = getSecret "git.name";
        email = getSecret "git.email";
      };
      init = {
        defaultBranch = "main";
      };
    };
  };
}
