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

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr, opts)
  for key, map in pairs(mappings.lsp) do
    local func = map[1]
    local desc = map[2]
    local map_opts = map[3]
    if desc then
      desc = 'LSP: ' .. desc
    end
    vim.keymap.set('n', key, func, { buffer = bufnr, desc = desc } or map_opts or opts)
  end

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()
require('mason-lspconfig').setup()

local servers = {
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end,
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
