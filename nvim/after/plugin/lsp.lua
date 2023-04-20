local lsp = require('lsp-zero')

lsp.preset('recommended')

lsp.ensure_installed({
  'tsserver',
  'eslint',
  'lua_ls',
  'rust_analyzer',
})

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  ['<C-Space>'] = cmp.mapping.complete(),
})

-- lsp.set_preferences({
  -- sign_icons = { }
-- })

local cmp_sources = lsp.defaults.cmp_sources()

--for _, source in pairs(cmp_sources) do
    -- source.keyword_length = 1
--end

lsp.setup_nvim_cmp({
  mapping = cmp_mappings,
  sources = cmp_sources
})

lsp.on_attach(function(client, bufnr)
  print("lsp attached")
  local opts = { buffer = bufnr, remap = false }
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)

  -- also allow code action/quick fix in insert mode
  vim.keymap.set("i", "<F4>", function() vim.lsp.buf.code_action() end, opts)
end)

lsp.setup()

require('lspconfig.configs').eye = {
    default_config = {
        name = 'eye',
        cmd = { 'eyelang', 'lsp' },
        filetypes = { 'eye' },
        root_dir = require('lspconfig.util').root_pattern({'main.eye'})
    }
}


vim.diagnostic.config({
    virtual_text = true,
})

local lspconfig = require'lspconfig'

lspconfig.eye.setup({})

lspconfig.lua_ls.setup {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
}

--lspconfig.rust_analyzer.setup {
--    -- cmd = { "rustup", "run", "nightly", "rust-analyzer" }
--    settings = {
--        ["rust-analyzer"] = {
--            diagnostics = { disabled = { 'inactive-code' } }
--        }
--    }
--}

