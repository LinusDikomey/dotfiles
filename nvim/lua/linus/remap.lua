vim.g.mapleader = " "

local function bind(op, outer_opts)
    outer_opts = outer_opts or {noremap = true}
    return function(lhs, rhs, opts)
        opts = vim.tbl_extend('force',
            outer_opts,
            opts or {}
        )
        vim.keymap.set(op, lhs, rhs, opts)
    end
end

local M = {
    nremap = bind('n', {noremap = true}),
    n = bind('n'),
    v = bind('v'),
    x = bind('x'),
    i = bind('i'),
}

-- remap for colemak dh
M.n('m', 'h')
M.n('n', 'j')
M.n('e', 'k')
M.n('i', 'l')

-- insert with l/start of line with L
M.n('l', 'i')
M.n('L', 'I')

-- also in visual mode
M.v('m', 'h')
M.v('n', 'j')
M.v('e', 'k')
M.v('i', 'l')

M.v('l', 'i')
M.v('L', 'I')

M.n("<leader>p", ":NvimTreeToggle<CR>") -- can also use vim.cmd.Ex

-- move lines
M.v('N', ":m '>+1<CR>gv=gv")
M.v('E', ":m '<-2<CR>gv=gv")

-- keep cursor when folding lines (disabled because j is used for search)
-- M.n('J', 'mzJ`z')

-- half page jumps with N/E that keep cursor in the middle
M.n('N', '<C-d>zz')
M.n('E', '<C-u>zz')

-- next/prev search result with j/J because n is mapped to movement (also keep cursor centered)
M.n('j', 'n')
M.n('J', 'Nzzzv')

-- space p to paste over selection while keeping previous copied item
M.x('<leader>p', '"_dP')

-- yank to system clipboard
M.n('<leader>y', '"+y')
M.v('<leader>y', '"+y')
M.n('<leader>Y', '"+Y')

M.i('<C-c>', '<Esc>')

-- make Q unusable
M.n('Q', '<nop>')

M.n('<C-f>', '<cmd>silent !tmux new tmux-sessionizer<CR>')
-- format file, not used and <leader>f is also bound to 'find files'
-- M.n('<leader>f', function() vim.lsp.buf.format())

-- quick fix navigation?
-- -- M.n('<C-n>', '<cmd>cprev<CR>zz')
-- M.n('<C-e>', '<cmd>cnext<CR>zz')
-- M.n('<leader>n', '<cmd>lprev<CR>zz')
-- M.n('<leader>e', '<cmd>lnext<CR>zz')

M.n('<leader>c', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

M.n('<leader>d', ':TroubleToggle<CR>')

-- clear search
M.n('<leader>/', ':noh<CR>', { silent = true })

-- splits
M.n('sh', ':split<CR>')
M.n('sv', ':vsplit<CR>')
M.n('sm', '<C-w>h')
M.n('sn', '<C-w>j')
M.n('se', '<C-w>k')
M.n('si', '<C-w>l')


-- previous/next location
M.n('<C-t>', '<C-i>')
M.n('<C-g>', '<C-o>')


-- Use Telescope for goto definition/references
M.n("gd", ':Telescope lsp_definitions<CR>', { silent = true })
M.n("gr", ':Telescope lsp_references<CR>', { silent = true })

-- Diagnostics
M.n("<C-d>", ':Telescope diagnostics<CR>', { silent = true})

-- Exit terminal mode with Escape
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
