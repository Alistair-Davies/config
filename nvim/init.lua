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

vim.keymap.set("n", "<Space>", "<Nop>")
vim.g.mapleader = " "

vim.opt.wildignore = {"*/node_modules/*", "*/static/*", "*/tmp/*", "*/.mypy_cache/*"}

local Plug = vim.fn['plug#']


vim.call('plug#begin', '~/.config/nvim/plugged')

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-file-browser.nvim'
Plug 'muchzill4/telescope-yacp.nvim'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'janko-m/vim-test'
Plug 'muchzill4/doubletrouble'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'folke/trouble.nvim'
Plug 'kyazdani42/nvim-web-devicons'

vim.call('plug#end')


local opts = {noremap=true, silent=true}

vim.keymap.set('n', '<Leader>ff', ':Telescope find_files<CR>', { noremap = true })
vim.keymap.set('n', '<Leader>fg', ':Telescope live_grep<CR>', { noremap = true })
vim.keymap.set('n', '<Leader>fb', ':Telescope buffers<CR>', { noremap = true })
vim.keymap.set('n', '<Leader>fd', ':Telescope file_browser<CR>', { noremap = true })
vim.keymap.set('n', '<Leader>fh', ':Telescope help_tags<CR>', { noremap = true })
vim.keymap.set('n', '<Leader>pp', ':Telescope yacp<CR>', { noremap = true })
vim.keymap.set('n', '<Leader>pr', ':Telescope yacp replay<CR>', { noremap = true })
vim.keymap.set('n', '<Leader>tt', ':TestFile<CR>', opts)
vim.keymap.set('n', '<Leader>ts', ':TestSuite<CR>', opts)
vim.keymap.set('n', '<Leader>m', ':lua vim.lsp.buf.formatting()<CR>")', opts)
vim.keymap.set('n', '<Leader>we', ':TroubleToggle<CR>', opts)
vim.keymap.set('n', '<Leader>ww', ':TroubleToggle workspace_diagnostics<CR>', opts)
vim.keymap.set('n', '<Leader>o', ':Project<space>', { noremap = true})
vim.keymap.set('n', '<Leader>s', ':w<CR>', { noremap = true })


local on_attach = function(client, bufnr)
  vim.keymap.set('n', '<Leader>gd', ':lua vim.lsp.buf.definition()<CR>', opts)
  vim.keymap.set('n', '<Leader>gh', ':lua vim.lsp.buf.hover()<CR>', opts)
  vim.keymap.set('n', '<Leader>gg', ':TroubleToggle lsp_references<CR>")', opts)
end

vim.api.nvim_command("colorscheme doubletrouble")

vim.api.nvim_create_user_command(
    'Project',
    function(opts)
      vim.api.nvim_command(string.format("lcd `z -e %s`", opts.args))
    end, 
    { nargs = 1, complete="dir"}
)


-- janko-m/vimtest
vim.g['test#python#runner'] = 'pytest'

-- Telescope file browser
local telescope = require("telescope")
telescope.load_extension "file_browser"


-- Command Line Palette
telescope.setup {
  extensions = {
    yacp = {
      palette = {
         { name = "pre-commit", cmd = "sp | term pre-commit run --all-files"},
         { name = "open files with conflicts", cmd = "args `git diff --name-only --diff-filter=U`"},
         { name = "clear buffers", cmd = ":%bd|edit#|bd#"},
         { name = "new tab", cmd = ":tabnew"},
      }
    }
  }
}
telescope.load_extension "yacp"


local ok, lspconfig = pcall(require, "lspconfig")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true


-- Treesitter
require('nvim-treesitter.configs').setup {
  ensure_installed = { 'typescript', 'rust', 'python', 'yaml', 'markdown' },
  highlight = { enable = true },
  indent = { enable = true },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}


local context = require "treesitter-context"
if context then
  context.setup {
    max_lines = 1,
    trim_scope = "inner",
    mode = "topline",
  }
end


-- Rust. brew install rust-analyzer
lspconfig.rust_analyzer.setup{}

-- C and C++ lsp. brew install llvm
-- lspconfig.clangd.setup{}

-- Python.
-- pyright: npm install -g pyright
-- lspconfig.pyright.setup{
--  on_attach = on_attach,
--  settings = {
--    python = {
--      venvPath = ".venv"
--    }
--  }
--}

-- jedi: pipx install jedi-language-server
lspconfig.jedi_language_server.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}


-- CSS
-- npm i -g vscode-langservers-extracted
lspconfig.cssls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}


-- null-ls
local ls = require('null-ls')
ls.setup({
  sources = {
    ls.builtins.diagnostics.mypy,
    ls.builtins.diagnostics.flake8,
    ls.builtins.formatting.black,
    ls.builtins.formatting.isort,
    ls.builtins.formatting.prettier,
  },
})


-- Trouble
require('trouble').setup{}

local cmp = require'cmp'
cmp.setup{
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'vsnip' },
  }),
  mapping = {
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
  }
}
