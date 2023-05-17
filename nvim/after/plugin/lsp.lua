local servers = { 'clangd', 'rust_analyzer', 'lua_ls' }

local function border(hl_name)
  return {
    { "╭", hl_name },
    { "─", hl_name },
    { "╮", hl_name },
    { "│", hl_name },
    { "╯", hl_name },
    { "─", hl_name },
    { "╰", hl_name },
    { "│", hl_name },
  }
end

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover,
    { border = 'rounded' }
)

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local on_attach = function(_, bufnr)
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
end

require('mason').setup()
local mason_lspconfig = require 'mason-lspconfig'
mason_lspconfig.setup {
    ensure_installed = servers,
}

mason_lspconfig.setup_handlers {
    function(server_name)
        require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
        }
    end,
}

local cmp = require 'cmp'
local luasnip = require 'luasnip'

luasnip.config.setup {}
local cmp_select = { behavior = cmp.SelectBehavior.Select }
cmp.setup {
    completion = {
        completeopt = "menu,menuone",
    },
    preselect = cmp.PreselectMode.Item,
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert {
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ["<CR>"] = cmp.mapping.confirm({
            -- behavior = cmp.ConfirmBehavior.Replace,
            select = false,
        }),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-n>'] = cmp.mapping.scroll_docs(4),
        ['<C-e>'] = cmp.mapping.scroll_docs(-4),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
    --    { name = 'nvim_lua' },
        { name = 'path' },
    }
}

local configs = require 'lspconfig.configs'

configs.eye = {
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

local lspconfig = require 'lspconfig'

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
    --capabilities = capabilities,
--    on_attach = on_attach,
--    cmd = { "rustup", "run", "nightly", "rust-analyzer" },
--    settings = {
--        ["rust-analyzer"] = {
--            diagnostics = { disabled = { 'inactive-code' } }
--        }
--    }
--}

