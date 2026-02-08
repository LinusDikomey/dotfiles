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
          inherit (lib) toUpper;
          inherit (config.dotfiles) keymap;
          match_mode = {
            ${keymap.match} = "match_brackets";
            s = "surround_add";
            r = "surround_replace";
            d = "surround_delete";
            a = "select_textobject_around";
            i = "select_textobject_inner";
          };
          g_mode =
            {
              h = "no_op";
              l = "no_op";
            }
            // {
              ${keymap.left} = "goto_line_start";
              ${keymap.right} = "goto_line_end";
            };
        in {
          normal = {
            ${keymap.left} = "move_char_left";
            ${keymap.down} = "move_visual_line_down";
            ${toUpper keymap.down} = "join_selections";
            "A-${toUpper keymap.down}" = "join_selections_space";
            ${keymap.up} = "move_visual_line_up";
            ${toUpper keymap.up} = "keep_selections";
            ${keymap.right} = "move_char_right";

            ${keymap.next} = "search_next";
            ${toUpper keymap.next} = "search_prev";
            ${keymap.end} = "move_next_word_end";
            ${toUpper keymap.end} = "move_next_long_word_end";
            ${keymap.insert} = "insert_mode";
            "C-u" = "jump_forward";
            "C-y" = "jump_backward";

            # it's a bit stupid but alt-d only works on mac like this because it yields √
            "√" = "delete_selection_noyank";

            ${keymap.match} = match_mode;
            g = g_mode;

            z =
              {
                j = "no_op";
                k = "no_op";
              }
              // {
                ${keymap.down} = "scroll_down";
                ${keymap.up} = "scroll_up";
              };

            "C-w" = let
              defaultHomeRow = ["h" "j" "k" "l"];
              directions = ["left" "down" "up" "right"];
            in
              builtins.listToAttrs (
                builtins.concatMap (key: [
                  {
                    name = key;
                    value = "no_op";
                  }
                  {
                    name = toUpper key;
                    value = "no_op";
                  }
                  {
                    name = "C-${key}";
                    value = "no_op";
                  }
                ])
                defaultHomeRow
              )
              // builtins.listToAttrs (
                builtins.concatMap (dir: [
                  {
                    name = keymap.${dir};
                    value = "jump_view_${dir}";
                  }
                  {
                    name = toUpper keymap.${dir};
                    value = "swap_view_${dir}";
                  }
                  {
                    name = "C-${keymap.${dir}}";
                    value = "swap_view_${dir}";
                  }
                ])
                directions
              );
            " ".g = {
              u = ":reset-diff-change";
              b = ":! git blame -L %{cursor_line},+1 %{buffer_name}";
              c = "changed_file_picker";
            };

            " ".B.D = [":run-shell-command rm %{buffer_name}" ":buffer-close!"];
            " ".e = "hover";
            " ".o = [
              ":sh rm -f /tmp/files2open"
              ":set mouse false"
              ":insert-output ${pkgs.yazi}/bin/yazi \"%{buffer_name}\" --chooser-file=/tmp/files2open"
              ":redraw"
              ":set mouse true"
              ":open /tmp/files2open"
              "select_all"
              "split_selection_on_newline"
              "goto_file"
              ":buffer-close! /tmp/files2open"
            ];
          };

          select = {
            ${keymap.left} = "extend_char_left";
            ${keymap.down} = "extend_visual_line_down";
            ${keymap.up} = "extend_visual_line_up";
            ${keymap.right} = "extend_char_right";
            ${keymap.next} = "extend_search_next";
            ${toUpper keymap.next} = "extend_search_prev";

            ${keymap.end} = "extend_next_word_end";
            ${toUpper keymap.end} = "extend_next_long_word_end";

            ${keymap.match} = match_mode;
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
              args = ["fmt" "-"];
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
