{
  lib,
  config,
  pkgs,
  ...
}: {
  programs.kitty = lib.mkIf config.dotfiles.graphical.enable {
    enable = true;
    settings = {
      font_family = config.dotfiles.theme.font.name;
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      font_size = 20;
      theme = "Catppuccin-Mocha";
      background_opacity = 0.8;
      background_blur = 3;
    };
    keybindings = let
      mod =
        if pkgs.stdenv.isDarwin
        then "cmd"
        else "ctrl+shift";
    in {
      "${mod}+t" = "new_tab_with_cwd";
    };
    autoThemeFiles = let
      theme = "Catppuccin-${lib.toSentenceCase config.dotfiles.theme.variant}";
    in {
      dark = theme;
      noPreference = theme;
      light = "Catppuccin-Latte";
    };
  };
}
