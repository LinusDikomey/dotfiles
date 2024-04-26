-- Linus Dikomey's Neovim config.
-- To switch navigation keys for a different keyboard layout easily:
-- Change `hjkl_remap` in lua/map.lua (default is for Colemak DH).
--
-- Some bindings are inspired by helix. Many actions are available behind the leader key (space).
-- which-key provides previews of available key combinations for better discoverability

-- Any completions longer than this will be cut off to prevent gigantic completion lists.
local max_completion_len = 35

-- Set <space> as the leader key
local leader = ' '

vim.g.mapleader = leader
vim.g.maplocalleader = leader

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure plugins ]]
local plugins = require('plugins')
require('lazy').setup(plugins, {})

-- Configure options
require('options')

-- Configure the keymaps
local mappings = require('map')
local icons = require('icons')

-- [[ Highlight on yank ]]
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Telescope ]]
-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

require('setup_lsps') {
  mappings = mappings.lsp,
  mason_installed = {
    lua_ls = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
  },
  -- configure language servers that are already installed by the system
  manual = {
    rust_analyzer = {},
    clangd = {},
  }

}

-- [[ Configure nvim-cmp ]]
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

local formatting_style = {
  -- default fields order i.e completion word + item.kind + item.kind icons
  -- fields = field_arrangement[cmp_style] or { "abbr", "kind", "menu" },

  format = function(_, item)
    item.kind = (icons[item.kind] or item.kind)
    if string.len(item.abbr) > max_completion_len then
      item.abbr = string.sub(item.abbr, 1, max_completion_len - 1) .. '󰇘'
    end

    return item
  end,
}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert(mappings.cmp),
  formatting = formatting_style,
  sources = {
    { name = 'nvim_lsp' },
    -- { name = 'luasnip' },
  },
}

local signs = { Error = "● ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({
  virtual_text = {
    prefix = '●'
  },
  signs = true,
  underline = true,
  update_in_insert = true,
  severity_sort = true,
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
