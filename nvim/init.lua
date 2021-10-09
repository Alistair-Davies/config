vim.opt.ruler = true
vim.opt.hidden = true
vim.opt.number = true
vim.opt.showcmd = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.mouse = "a"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.clipboard = "unnamed"
vim.opt.termguicolors = true
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.wildignore = {"*/node_modules/*", "*/static/*", "*/tmp/*"}

local Plug = vim.fn['plug#']


vim.call('plug#begin', '~/.config/nvim/plugged')

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'janko-m/vim-test'
Plug 'muchzill4/doubletrouble'

vim.call('plug#end')


vim.api.nvim_set_keymap('n', '<Leader>ff', ':Telescope find_files<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>fg', ':Telescope live_grep<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>fb', ':Telescope buffers<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>fd', ':Telescope file_browser<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>fh', ':Telescope help_tags<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>t', ':TestFile<CR>', { noremap = true, silent = true })

local on_attach = function(client, bufnr)
  vim.api.nvim_set_keymap('n', '<Leader>gd', ':lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<Leader>gh', ':lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<Leader><C-k>', ':lua vim.lsp.buf.signature_help()<CR>', { noremap = true, silent = true })

  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end


vim.api.nvim_command("colorscheme doubletrouble")

-- janko-m/vimtest
vim.g['test#python#runner'] = 'pytest'

local ok, lspconfig = pcall(require, "lspconfig")
lspconfig.jedi_language_server.setup {
  on_attach = on_attach
}

require('lspconfig').pyright.setup{
  on_attach = on_attach,
  settings = {
  }
}
