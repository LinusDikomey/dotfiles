{
  lib,
  config,
  ...
}: {
  options.dotfiles.keymap = let
    key = default:
      lib.mkOption {
        inherit default;
        type = lib.types.singleLineStr;
      };
  in {
    left = key "h";
    down = key "j";
    up = key "k";
    right = key "l";
    insert = key "i";
    match = key "m";
    next = key "n";
    end = key "e";
    above_down = key "u";
    above_up = key "i";

    layout.colemak_dh = lib.mkOption {
      description = "Enable Colemak DH default layout";
      default = true;
      type = lib.types.bool;
    };
  };
  config.dotfiles.keymap = lib.mkIf config.dotfiles.keymap.layout.colemak_dh {
    left = "m";
    down = "n";
    up = "e";
    right = "i";
    insert = "l";
    match = "h";
    next = "k";
    end = "j";
    above_down = "l";
    above_up = "u";
  };
}
