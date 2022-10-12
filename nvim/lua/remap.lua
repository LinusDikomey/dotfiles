
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

vim.g.mapleader = ' '

M.n('m', 'h')
M.n('n', 'j')
M.n('e', 'k')
M.n('i', 'l')

M.n('l', 'i')
M.n('L', 'I')
M.n('j', 'n')
M.n('J', 'N')

M.n('<leader>p', '<cmd>Ex<CR>')
