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

M.n("<leader>p", vim.cmd.Ex)

-- move lines
M.v('N', ":m '>+1<CR>gv=gv")
M.v('E', ":m '<-2<CR>gv=gv")

-- keep cursor when folding lines (disabled because j ist used for search)
-- M.n('J', 'mzJ`z')

-- half page jumps keep cursor in the middle
M.n('<C-d>', '<C-d>zz')
M.n('<C-u>', '<C-u>zz')

-- next/prev search result with j/J because n is mapped to movement (also keep cursor centered)
M.n('j', 'n')
M.n('J', 'Nzzzv')

-- space p to paste over selection while keeping previous copied item
-- "greatest remap ever" - ThePrimeagen
M.x('<leader>p', '"_dP')

-- yank to system clipboard
M.n('<leader>y', '"+y')
M.v('<leader>y', '"+y')
M.n('<leader>Y', '"+Y')

M.i('<C-c>', '<Esc>')

-- make Q unusable
M.n('Q', '<nop>')

M.n('<C-f>', '<cmd>silent !tmux neww tmux-sessionizer<CR>')
-- format file, not used and <leader>f is also bound to 'find files'
-- M.n('<leader>f', function() vim.lsp.buf.format())

-- quick fix navigation?
-- -- M.n('<C-n>', '<cmd>cprev<CR>zz')
-- M.n('<C-e>', '<cmd>cnext<CR>zz')
-- M.n('<leader>n', '<cmd>lprev<CR>zz')
-- M.n('<leader>e', '<cmd>lnext<CR>zz')

M.n('<leader>c', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
