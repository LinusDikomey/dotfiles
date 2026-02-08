{
  config,
  lib,
  ...
}: {
  programs.zed-editor = {
    enable = config.dotfiles.coding.enable && config.dotfiles.graphical.enable;

    # only allow this file as a single source of truth
    mutableUserSettings = false;
    mutableUserKeymaps = false;

    extensions = [
      "catppuccin"
    ];
    userSettings = {
      languages.Rust.wrap_guides = [100];
      helix_mode = true;
      relative_line_numbers = "wrapped";
      disable_ai = true;
      buffer_font_size = 18;
      cursor_blink = false;
      file_scan_exclusions = [
        "**/.git"
        "**/.svn"
        "**/.hg"
        "**/.jj"
        "**/CVS"
        "**/.DS_Store"
        "**/Thumbs.db"
        "**/.classpath"
        "**/.settings"
        "*.meta"
        "*.csproj"
      ];
      preview_tabs.enable_preview_from_file_finder = true;
      tab_bar.show = false;
      title_bar = {
        show_sign_in = false;
        show_menus = false;
      };
      git.inline_blame.enabled = false;
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      theme = "Catppuccin ${lib.toSentenceCase config.dotfiles.theme.variant}";
      ui_font_size = 20;
      vim_mode = true;
    };
    userKeymaps = [
      {
        # global context everywhere except in terminal
        context = "!Terminal";
        bindings = {
          ctrl-i = "pane::GoForward";
          ctrl-o = "pane::GoBack";
          ctrl-b = "workspace::ToggleLeftDock";
        };
      }
      {
        # toggling terminal should work in all contexts
        bindings = {
          ctrl-j = "terminal_panel::Toggle";
        };
      }
      {
        # pickers
        context = "((vim_mode == helix_normal || vim_mode == helix_select) && !menu) || EmptyPane";
        bindings = {
          "space / " = "pane::DeploySearch";
          "space f" = "file_finder::Toggle";
          "space b" = "tab_switcher::Toggle";
          "space d" = "diagnostics::DeployCurrentFile";
          "space shift-d" = "diagnostics::Deploy";
          "space e" = "editor::Hover";
          "space g u" = "git::Restore";
        };
      }
      {
        # panes
        context = "VimControl || !Editor && !Terminal";
        bindings = {
          "ctrl-w e" = "workspace::ActivatePaneUp";
          "ctrl-w i" = "workspace::ActivatePaneRight";
          "ctrl-w m" = "workspace::ActivatePaneLeft";
          "ctrl-w n" = "workspace::ActivatePaneDown";
        };
      }
      {
        # Normal/Select mode
        context = "Editor && (vim_mode == helix_normal || vim_mode == helix_select) && !menu";
        bindings = {
          m = "vim::WrappingLeft";
          n = "vim::Down";
          e = "vim::Up";
          i = "vim::WrappingRight";
          shift-n = "vim::JoinLines";
          "g m" = "vim::StartOfLine";
          "g i" = "vim::EndOfLine";
          h = "vim::PushHelixMatch";
          j = "vim::NextWordEnd";
          shift-j = ["vim::NextWordEnd" {ignore_punctuation = true;}];
          k = "vim::MoveToNextMatch";
          shift-k = "vim::MoveToPreviousMatch";
          l = "vim::HelixInsert";
          shift-l = "vim::InsertBefore";
        };
      }
      {
        context = "vim_operator == helix_m";
        bindings = {
          h = "vim::Matching";
        };
      }
      {
        context = "(OutlinePanel && not_editing) || (GitPanel && ChangesList)";
        bindings = {
          n = "menu::SelectNext";
          e = "menu::SelectPrevious";
        };
      }
    ];
  };
}
