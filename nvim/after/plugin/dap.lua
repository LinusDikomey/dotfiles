
vim.keymap.set('n', '<F5>', ":lua require'dap'.continue()<CR>")
vim.keymap.set('n', '<F10>', ":lua require'dap'.step_out()<CR>")
vim.keymap.set('n', '<F11>', ":lua require'dap'.step_over()<CR>")
vim.keymap.set('n', '<F12>', ":lua require'dap'.step_into()<CR>")

vim.keymap.set('n', '<leader>b', ":lua require'dap'.toggle_breakpoint()<CR>")
vim.keymap.set('n', '<leader>D', ":lua require'dapui'.toggle()<CR>")

local dap = require('dap')

dap.adapters.codelldb = {
  type = 'server',
  port = "${port}",
  executable = {
    command = vim.fn.expand('$HOME/.local/share/nvim/mason/bin/codelldb'),
    args = {"--port", "${port}"},
  }
}

dap.configurations.rust = {
    {
        type = 'codelldb';
        request = 'launch';
        name = 'Run project';
        program = function()
            local cmd = 'cat Cargo.toml | rg \'name = "(.*)"\' -or \'$1\''
            local name = vim.fn.system({ 'bash', '-c', cmd })
            name = vim.trim(name)
            vim.fn.system({ 'cargo', 'build' })
            return vim.fn.getcwd() .. '/target/debug/' .. name
        end,
        args = { 'run', 'a.eye' }, -- TODO: make this editable (per-project) somehow?
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        sourceLanguages = { 'rust' }
    }
}

require('dapui').setup()
