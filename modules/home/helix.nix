{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.dotfiles.helix;
in {
  options.dotfiles.helix = {
    enable = lib.mkOption {
      description = "Helix editor support";
      default = true;
    };
    defaultEditor = lib.mkOption {default = true;};
  };

  config = lib.mkIf cfg.enable {
    programs.helix = {
      enable = true;
      defaultEditor = cfg.defaultEditor;
      settings = {
        theme = "catppuccin_macchiato";

        editor = {
          line-number = "relative";
          shell = ["nu" "-c"];
          auto-format = true;
          rulers = [100];
          color-modes = true;
          end-of-line-diagnostics = "hint";

          inline-diagnostics.cursor-line = "error";
          cursor-shape.insert = "bar";
          lsp.display-messages = true;
          indent-guides.render = true;

          whitespace.render.tab = "all";
        };

        keys = let
          match_mode = {
            h = "match_brackets";
            s = "surround_add";
            r = "surround_replace";
            d = "surround_delete";
            a = "select_textobject_around";
            i = "select_textobject_inner";
          };
          g_mode = {
            h = "no_op";
            l = "no_op";
            m = "goto_line_start";
            i = "goto_line_end";
          };
        in {
          normal = {
            m = "move_char_left";
            n = "move_visual_line_down";
            N = "join_selections";
            "A-N" = "join_selections_space";
            e = "move_visual_line_up";
            E = "keep_selections";
            i = "move_char_right";

            j = "search_next";
            J = "search_prev";
            k = "move_next_word_end";
            K = "move_next_long_word_end";
            l = "insert_mode";
            "C-u" = "jump_forward";
            "C-y" = "jump_backward";

            # it's a bit stupid but alt-d only works on mac like this because it yields √
            "√" = "delete_selection_noyank";

            h = match_mode;
            g = g_mode;

            z = {
              j = "no_op";
              k = "no_op";
              n = "scroll_down";
              e = "scroll_up";
            };

            "C-w" = {
              h = "no_op";
              j = "no_op";
              k = "no_op";
              l = "no_op";
              H = "no_op";
              J = "no_op";
              K = "no_op";
              L = "no_op";
              "C-h" = "no_op";
              "C-j" = "no_op";
              "C-k" = "no_op";
              "C-l" = "no_op";
              m = "jump_view_left";
              n = "jump_view_down";
              e = "jump_view_up";
              i = "jump_view_right";
              M = "swap_view_left";
              N = "swap_view_down";
              E = "swap_view_up";
              I = "swap_view_right";
            };

            " ".g = {
              u = ":reset-diff-change";
              b = ":! git blame -L %{cursor_line},+1 %{buffer_name}";
              c = "changed_file_picker";
            };

            " ".B.D = [":run-shell-command rm %{buffer_name}" ":buffer-close!"];
          };

          select = {
            m = "extend_char_left";
            n = "extend_visual_line_down";
            e = "extend_visual_line_up";
            i = "extend_char_right";
            j = "extend_search_next";
            J = "extend_search_prev";

            h = match_mode;
            g = g_mode;
          };
        };
      };
      languages = {
        language-server = {
          rust-analyzer.config = {
            diagnostics.disabled = ["inactive-code"];
            check.command = "clippy";
          };

          eye = {
            command = "eye";
            args = ["lsp"];
          };

          pyright = {
            command = "pyright-langserver";
            args = ["--stdio"];
          };
        };

        language = [
          {
            name = "rust";
            auto-format = true;
          }
          {
            name = "eye";
            scope = "source.eye";
            file-types = ["eye"];
            roots = ["main.eye"];
            comment-token = "#";
            block-comment-tokens = [
              {
                start = "#-";
                end = "-#";
              }
            ];
            language-servers = ["eye"];
            grammar = "eye";
            indent = {
              tab-width = 2;
              unit = "  ";
            };
            auto-pairs = {
              "(" = ")";
              "[" = "]";
              "{" = "}";
              "\"" = "\"";
            };
            formatter = {
              command = "eye";
              args = ["fmt-stdin"];
            };
            auto-format = true;
          }
          {
            name = "gon";
            scope = "source.gon";
            file-types = ["gon"];
            roots = [];
            comment-token = "//";
            grammar = "gon";
          }
          {
            name = "python";
            language-servers = ["pyright"];
            formatter = {
              command = "black";
              args = ["--line-length" "100" "--quiet" "-"];
            };
          }
          {
            name = "latex";
            soft-wrap.enable = true;
            soft-wrap.wrap-at-text-width = true;
            text-width = 99;
          }
          {
            name = "nix";
            formatter.command = "${pkgs.alejandra}/bin/alejandra";
            auto-format = true;
          }
        ];

        grammar = [
          {
            name = "eye";
            source = {
              git = "https://github.com/LinusDikomey/tree-sitter-eye";
              rev = "c8d2f3d14c59281a3872c0320b87cdf9c2e520e6";
            };
          }
          {
            name = "gon";
            source = {
              git = "https://github.com/LinusDikomey/tree-sitter-gon";
              rev = "f93d6509a3517aec5b97e5533aa354f0d0006f76";
            };
          }
        ];
      };
    };
    home.file = let
      treeSitterEye = pkgs.fetchFromGitHub {
        owner = "LinusDikomey";
        repo = "tree-sitter-eye";
        rev = "96eea2d00bbb4ed06fa29d22f7f508124abe01bc";
        sha256 = "sha256-K14lGWjIztdBuM/kgoWXTSVn1tKzKrAqX3l91cqM/Ak=";
      };
    in {
      ".config/helix/runtime/queries/eye/locals.scm".source = "${treeSitterEye}/queries/locals.scm";
      ".config/helix/runtime/queries/eye/highlights.scm".source = "${treeSitterEye}/queries/highlights.scm";
    };
  };
}
