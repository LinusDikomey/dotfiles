
local on_attach = function (bufnr)
    local api = require('nvim-tree.api')

    local function opts(desc)
        return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end
    api.config.mappings.default_on_attach(bufnr)

    vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node, opts('CD'))
    vim.keymap.del('n', 's', { buffer = bufnr })
    vim.keymap.del('n', 'e', { buffer = bufnr })
end

require('nvim-tree').setup({
    on_attach = on_attach,
})
