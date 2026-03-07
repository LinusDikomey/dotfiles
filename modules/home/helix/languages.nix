{pkgs, ...}: {
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
}
