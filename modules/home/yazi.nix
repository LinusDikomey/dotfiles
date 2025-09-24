{
  programs.yazi = {
    enable = true;
    keymap = {
      mgr.prepend_keymap = [
        {
          on = "m";
          run = "leave";
        }
        {
          on = "n";
          run = "arrow next";
        }
        {
          on = "e";
          run = "arrow prev";
        }
        {
          on = "i";
          run = "enter";
        }
        {
          on = "M";
          run = "back";
        }
        {
          on = "I";
          run = "forward";
        }
        {
          on = "N";
          run = "seek -5";
        }
        {
          on = "E";
          run = "seek 5";
        }
      ];
    };
  };
}
