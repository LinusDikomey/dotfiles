{inputs', ...}: {
  programs.yazi = {
    enable = true;
    package = inputs'.self.packages.yazi;
  };
}
