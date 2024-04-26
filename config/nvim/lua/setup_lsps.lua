return function(config)
  -- [[ Configure LSP ]]
  --  This function gets run when an LSP connects to a particular buffer.
  local on_attach = function(_, bufnr, opts)
    for key, map in pairs(config.mappings) do
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

  -- Setup neovim lua configuration
  require('neodev').setup()

  -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

  -- Ensure the servers above are installed
  local mason_lspconfig = require 'mason-lspconfig'

  mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(config.mason_installed),
  }

  mason_lspconfig.setup_handlers {
    function(server_name)
      print('mason server name' .. server_name)
      require('lspconfig')[server_name].setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = config.mason_installed[server_name],
        filetypes = (config.mason_installed[server_name] or {}).filetypes,
      }
    end,
  }

  for name, settings in pairs(config.manual) do
    require('lspconfig')[name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = settings,
    }
  end
end
