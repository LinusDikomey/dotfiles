-- relative line numbers
vim.o.relativenumber = true
vim.o.rnu = true

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- set text width, display ruler at column
-- Rust for example will set this to 99, we also use that
vim.o.textwidth = 99
vim.o.colorcolumn = tostring(vim.o.textwidth + 1)

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- new split opening direction
vim.o.splitright = true
vim.o.splitbelow = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 7

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

vim.o.termguicolors = true

-- Indent using 4 spaces by default.
-- Will be overwritten if vim-sleuth detects a different indentation width.
vim.o.shiftwidth = 4

-- how many spaces a tab takes up
vim.o.tabstop = 4

vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '•', nbsp = '␣' }
