require('plugins')
require('lsp.rust')
require('remap')

-- vim.opt.guicursor = ""
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.gdefault = true

vim.opt.smartindent = true

vim.opt.wrap = false

-- theming / colors

vim.g.tokyonight_transparent_sidebar = true
vim.g.tokyonight_transparent = true
vim.opt.background = 'dark'


require('tokyonight').setup({
    style = 'storm',
    transparent = true,
    styles = {
    -- Style to be applied to different syntax groups
    -- Value is any valid attr-list value for `:help nvim_set_hl`
    -- comments = { italic = true },
    -- keywords = { italic = true },
    functions = {},
    variables = {},
    -- Background styles. Can be "dark", "transparent" or "normal"
    -- sidebars = "dark", -- style for sidebars, see below
    -- floats = "dark", -- style for floating windows
  },
})

local cmp = require('cmp')
cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        end,
    },
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' }, -- For vsnip users.
        -- { name = 'luasnip' }, -- For luasnip users.
        -- { name = 'ultisnips' }, -- For ultisnips users.
        -- { name = 'snippy' }, -- For snippy users.
    }, {
        { name = 'buffer' },
    })
})


vim.cmd('colorscheme tokyonight')

