
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "javascript", "typescript", "c", "cpp", "lua", "rust" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  highlight = {
    -- `false` will disable the whole extension
    enable = true,
  },
}

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.eye = {
  install_info = {
    url = "~/dev/tree-sitter-eye", -- local path or git repo
    files = {"src/parser.c", "src/scanner.c"},
    -- optional entries:
    generate_requires_npm = false, -- if stand-alone parser without npm dependencies
    requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
  }
}
parser_config.gon = {
    install_info = {
        url = "~/dev/tree-sitter-gon",
        files = {"src/parser.c"},
        generate_requires_npm = false,
        requires_generate_from_grammar = false,
    }
}

vim.treesitter.language.register("eye", "eye")
