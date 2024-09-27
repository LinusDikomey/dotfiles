-- Keyboard layout config. If you use querty, just change this to {'h','j','k','l'}
local hjkl_remap = { 'm', 'n', 'e', 'i' } -- Colemak DH

-- [[ Apply hjkl remap ]]
local hjkl_original = { 'h', 'j', 'k', 'l' }
local directions = { 'left', 'down', 'up', 'right' }
for i = 1, 4 do
  if hjkl_remap[i] ~= hjkl_original[i] then
    local to = hjkl_remap[i]
    local from = hjkl_original[i]
    local dir = directions[i]
    -- swap new key with original key
    vim.keymap.set({ 'n', 'x' }, to, from, { silent = true })
    vim.keymap.set({ 'n', 'x' }, from, to)
    -- also swap in uppercase
    vim.keymap.set({ 'n', 'x' }, string.upper(to), string.upper(from), { silent = true })
    vim.keymap.set({ 'n', 'x' }, string.upper(from), string.upper(to))

    -- apply to window/split navigation
    vim.keymap.set('n', '<C-w>' .. to, '<C-w>' .. from, { desc = 'Go to ' .. dir .. ' window' })
    vim.keymap.set('n', '<C-' .. to .. '>', '<C-w><C-' .. from .. '>',
      { desc = 'Move focus to the ' .. dir .. 'window' })
    -- TODO: Deleting doesn't work, window commands are builtin in some way.
    -- Movement commands will exist twice in which-key for now.
    -- vim.keymap.del('n', '<C-w>' .. hjkl_original[i])
  end
end

-- [[ Basic Keymaps ]]

-- previous/next location
vim.keymap.set('n', '<C-i>', '<C-i>')
vim.keymap.set('n', '<C-o>', '<C-o>')

vim.keymap.set({ 'i', 'c' }, '<M-BS>', '<C-W>', { desc = 'alt+backspace to delete whole word' })
-- undo with shift+u like in helix
vim.keymap.set('n', 'U', '<C-r>')

-- Goto start/end of line
vim.keymap.set('n', 'g' .. hjkl_remap[1], '0')
vim.keymap.set('n', 'g' .. hjkl_remap[4], '$')

-- move lines
vim.keymap.set('v', string.upper(hjkl_remap[2]), ":m '>+1<CR>gv=gv")
vim.keymap.set('v', string.upper(hjkl_remap[3]), ":m '<-2<CR>gv=gv")

-- pasting over text in visual mode doesn't replace clipboard
vim.keymap.set('x', 'p', '"_dP')

-- Keymaps for better default experience
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', hjkl_remap[2], "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('n', hjkl_remap[3], "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- open neotree
vim.keymap.set('n', '<leader>F', ':Neotree reveal float<CR>', { desc = 'Show current file in file tree' })

-- leap in both directions with f
vim.keymap.set({ 'n', 'x', 'o' }, 'f', '<Plug>(leap)')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

vim.keymap.set('n', '<tab>', '<C-w>w')

vim.api.nvim_create_user_command('LiveGrepGitRoot', require('live_grep_git_root'), {})

-- vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader>o', require('telescope.builtin').buffers,
  { desc = 'Find [o]pen buffers' })

vim.keymap.set('n', '<leader>l', require('telescope.builtin').current_buffer_fuzzy_find,
  { desc = '[l]ocal buffer fuzzy search' })

local telescope_builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>b', telescope_builtin.buffers,
  { desc = 'Find existing [b]uffers' })
vim.keymap.set('n', '<leader>l', telescope_builtin.current_buffer_fuzzy_find,
  { desc = '[l]ocal buffer fuzzy search' })
vim.keymap.set('n', '<leader><space>', telescope_builtin.resume, { desc = 'Search resume ' })
vim.keymap.set('n', '<leader>gf', telescope_builtin.git_files, { desc = 'Search [g]it [f]iles' })
vim.keymap.set('n', '<leader>f', telescope_builtin.find_files, { desc = 'Search [f]iles' })
vim.keymap.set('n', '<leader>?', telescope_builtin.help_tags, { desc = 'Search Help' })
-- vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>/', telescope_builtin.live_grep, { desc = 'Search by Grep' })
vim.keymap.set('n', '<leader>g/', ':LiveGrepGitRoot<cr>', { desc = '[G]it Root: Search by [G]rep' })
vim.keymap.set('n', '<leader>d', telescope_builtin.diagnostics, { desc = '[D]iagnostics' })

vim.keymap.set('n', '<leader>c', function()
  telescope_builtin.find_files { cwd = vim.fn.stdpath 'config' }
end, { desc = 'Search neovim [c]onfig' })

local cmp = require 'cmp'
local luasnip = require 'luasnip'
local cmp_map = {
  ['<C-n>'] = cmp.mapping.select_next_item(),
  ['<C-p>'] = cmp.mapping.select_prev_item(),
  ['<C-u>'] = cmp.mapping.scroll_docs(-4),
  ['<C-d>'] = cmp.mapping.scroll_docs(4),
  ['<C-Space>'] = cmp.mapping.complete {},
  ['<CR>'] = cmp.mapping.confirm {
    behavior = cmp.ConfirmBehavior.Replace,
    select = true,
  },
  ['<Tab>'] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    elseif luasnip.expand_or_locally_jumpable() then
      luasnip.expand_or_jump()
    else
      fallback()
    end
  end, { 'i', 's' }),
  ['<S-Tab>'] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    elseif luasnip.locally_jumpable(-1) then
      luasnip.jump(-1)
    else
      fallback()
    end
  end, { 'i', 's' }),
}

-- rename doesn't work with lsp_map
vim.keymap.set('n', '<leader>r', function()
    return ":IncRename " .. vim.fn.expand("<cword>")
  end,
  { expr = true, desc = 'LSP: rename' }
)

local lsp_map = {
  ['<leader>a'] = { vim.lsp.buf.code_action, 'Code [a]ction' },
  ['gd'] = { require('telescope.builtin').lsp_definitions, '[g]oto [d]efinition' },
  ['gr'] = { require('telescope.builtin').lsp_references, '[g]oto [r]eferences' },
  ['gI'] = { require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation' },
  ['<leader>D'] = { require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition' },
  ['<leader>s'] = { require('telescope.builtin').lsp_document_symbols, 'Document [s]ymbols' },
  ['<leader>S'] = { require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Workspace [S]ymbols' },
  ['<leader>k'] = { vim.lsp.buf.hover, 'Hover Documentation' },
  ['<C-k>'] = { vim.lsp.buf.signature_help, 'Signature Documentation' },
  ['gD'] = { vim.lsp.buf.declaration, '[G]oto [D]eclaration' },
  ['<leader>wa'] = { vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder' },
  ['<leader>wr'] = { vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder' },
  ['<leader>wl'] = {
    function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
    '[W]orkspace [L]ist Folders'
  },
}

return { cmp = cmp_map, lsp = lsp_map }
