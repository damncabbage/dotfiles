-- luacheck: ignore
if not vim then
  vim = {}
end

--------------------------------------------------------
-- Neovide configuration
--------------------------------------------------------
-- Done first so that bootstrapping plugins etc still looks nice
if vim.g.neovide then
  vim.g.neovide_cursor_animation_length = 0.05
  vim.opt.guifont = "Codelia,Hack_Nerd_Font:h14"
  vim.opt.guioptions = "i"
end

--------------------------------------------------------
-- Plugins
--------------------------------------------------------
-- Packer is the new Bundle/Vundle/Plug I guess?
-- Make sure we can bootstrap it.
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
  -- pls manage yourself kthx
  use 'wbthomason/packer.nvim'

  -- Themes
  use 'theacodes/witchhazel'
  use 'Th3Whit3Wolf/one-nvim'
  use 'morhetz/gruvbox'

  -- Displays nice git diff information in the sidebar
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  }

  -- Displays LSP information like compile errors inline.
  use {
    'folke/trouble.nvim',
    config = function()
      require('trouble').setup()
    end
  }

  -- CtrlP but modern i guess. Can also search LSP results.
  use {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.0',
    requires = { {'nvim-lua/plenary.nvim'} },
  }

  -- LSP support. Initialisation is in a separate block later, since init order
  -- of these plugins is important.
  use {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  }

  -- AST parsing for better syntax highlighting.
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      require('nvim-treesitter.install').update({ with_sync = true })
    end,
  }

  -- Completion
  -- `nvim-cmp` is the main plugin. Everything else is just input sources for
  -- it to get completions from.
  use {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/nvim-cmp',
    'dcampos/nvim-snippy',
    'dcampos/cmp-snippy',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'hrsh7th/cmp-nvim-lsp-document-symbol',
  }

  -- Fancy icons
  use {
    'kyazdani42/nvim-web-devicons',
    config = function()
      require('nvim-web-devicons').setup {
        default = true
      }
    end
  }
  use { 'onsails/lspkind.nvim' }

  -- Status line and tab line
  use 'nvim-lualine/lualine.nvim'
  use {
    'kdheepak/tabline.nvim',
    config = function()
      require('tabline').setup {
        enable = true,
        options = {
          show_bufnr = false,
          show_tabs_always = false,
          show_filename_only = true,
        }
      }
    end
  }

  -- Parallel undo histories, for a scatter-brained fool like me
  use 'mbbill/undotree'

  -- Show me what my shortcuts are
  use {
    'folke/which-key.nvim',
    config = function()
      require("which-key").setup {
      }
    end
  }

  -- Keep last, in order to bootstrap successfully.
  if packer_bootstrap then
    require('packer').sync()
  end
end)

--------------------------------------------------------
-- General Settings
--------------------------------------------------------
vim.opt.scrolloff = 8
vim.g.mapleader = ","
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.relativenumber = false

-- Searching
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.smartcase = true

-- Pretty
vim.opt.termguicolors = true
vim.cmd "colorscheme one-nvim"

-- Line-wrapping
vim.opt.wrap = true
vim.opt.linebreak = true   -- Avoid line-wrapping in the middle of a word.
vim.opt.breakindent = true -- Hanging indent soft-wrap ...
vim.opt.sbr = "↪ "         -- ... prefixed by an arrow, and a space (to make it line up with a match 2-space indent).
vim.opt.breakindentopt = "min:20,shift:0"

-- Persistent undo
local undo_path = vim.fn.stdpath('data')..'/undo'
if vim.fn.empty(vim.fn.glob(undo_path)) > 0 then
  vim.fn.system({"mkdir", "-p", undo_path})
end
vim.opt.undofile = true
vim.opt.undodir = undo_path..'/'
vim.opt.swapfile = false

vim.opt.textwidth = 0
vim.opt.list = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.cc = '81'
vim.opt.ruler = true
vim.opt.scrolloff = 2 -- Keep some space at the bottom of the window

-- Buffers and Tabs
-- Tab-moving (complementing gt and gT)
vim.keymap.set('n', 'mt', ':tabmove +1<cr>')
vim.keymap.set('n', 'mT', ':tabmove -1<cr>')

-- Buffer navigation
vim.keymap.set('n', 'gb', ':bnext<cr>')
vim.keymap.set('n', 'gB', ':bprevious<cr>')

-- Return to last edit position when opening files
vim.cmd [[
  augroup last_edit
    autocmd!
    autocmd BufReadPost *
         \ if line("'\"") > 0 && line("'\"") <= line("$") |
         \   exe "normal! g`\"" |
         \ endif
  augroup end
]]
vim.opt.viminfo = "%,"..vim.opt.viminfo._value -- Remember info about open buffers on close

-- Source the vimrc file after saving it
vim.cmd [[
  augroup sourcing
    autocmd!
    autocmd bufwritepost init.lua source $MYVIMRC
  augroup end
]]

--------------------------------------------------------
-- Shell-related business
--------------------------------------------------------
-- Write without auto-formatters or other autocommand-driven actions.
vim.cmd [[
  command! W :noautocmd write
]]

-- Load in aliases+functions to make them available in a :!... command.
vim.env.BASH_ENV = "~/.config/nvim/bash.sh"

-- Shortcut to open a terminal buffer at the bottom of the screen, and switch to it.
vim.keymap.set('n', '<leader>!', ':botright split<cr>:term<cr>', {
  desc = "Open terminal buffer in a bottom h-split"
})

-- Allow typing into term buffers on open
vim.cmd [[
  autocmd TermOpen * startinsert
]]

-- Rebind the clunky C-\ C-n to the quicker esc-esc
vim.keymap.set('t', '<esc><esc>', '<C-\\><C-n>')

--------------------------------------------------------
-- Treesitter configuration
--------------------------------------------------------
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "cpp", "lua", "rust", "ruby", "javascript", "typescript" },
  sync_install = true,
  auto_install = true,

  highlight = {
    enable = true,
  },
}

--------------------------------------------------------
-- Search Configuration
--------------------------------------------------------
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = require('telescope.actions').close
      },
    },
  }
}
vim.keymap.set('n', '<C-p>', function()
  require('telescope.builtin').find_files(require('telescope.themes').get_dropdown({}))
end)

vim.keymap.set('n', '<leader>p', function()
  require('telescope.builtin').registers(require('telescope.themes').get_cursor({}))
end)

--------------------------------------------------------
-- Language Server Configuration
--------------------------------------------------------
require('mason').setup()
require('mason-lspconfig').setup()

local lspconfig = require("lspconfig")
require("mason-lspconfig").setup_handlers {
  function (server_name)
    lspconfig[server_name].setup {}
  end
}

--------------------------------------------------------
-- Autocompletion
--------------------------------------------------------
vim.opt.completeopt = {"menu", "menuone", "noselect", "preview"}

require('snippy').setup {}
local cmp_icons = require('lspkind')

local cmp = require('cmp')
cmp.setup {
  snippet = {
    -- A snippet engine is required. Don't ask me why.
    expand = function(args)
      require('snippy').expand_snippet(args.body)
    end,
  },
  formatting = {
    format = cmp_icons.cmp_format({
      mode = 'symbol',
      maxwidth = 50,
    })
  },
  mapping = cmp.mapping.preset.insert({
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        if #cmp.get_entries() == 1 then
          cmp.confirm({ select = true })
        else
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        end
      else
        fallback()
      end
    end, {"i", "s", "c"}),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
  }),
  sources = {
    { name = 'nvim_lsp_signature_help' },
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'buffer' },
  }
}
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'nvim_lsp_document_symbol' },
    { name = 'buffer' },
  }
})
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'path' },
    { name = 'cmdline' },
  }
})

--------------------------------------------------------
-- Status Line
--------------------------------------------------------
require('lualine').setup {
  theme = 'onedark',
  options = {
    component_separators = '',
    section_separators = '',
  },

  -- Override 'encoding': Don't display if encoding is UTF-8.
  encoding = function()
    local ret, _ = (vim.bo.fenc or vim.go.enc):gsub("^utf%-8$", "")
    return ret
  end,
  -- fileformat: Don't display if &ff is unix.
  fileformat = function()
    local ret, _ = vim.bo.fileformat:gsub("^unix$", "")
    return ret
  end,
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {function() return require('nvim-treesitter').statusline({}) end},
    lualine_x = {encoding, fileformat, 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
}

--------------------------------------------------------
-- Undo Tree
--------------------------------------------------------
vim.keymap.set('n', '<leader>u', ':UndotreeToggle<CR>')
vim.g.undotree_WindowLayout = 3
vim.g.undotree_SetFocusWhenToggle = 1
