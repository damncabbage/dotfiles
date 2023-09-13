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
  use 'tssm/fairyfloss.vim'
  use 'theacodes/witchhazel'
  use 'Th3Whit3Wolf/one-nvim'
  use 'morhetz/gruvbox'
  use 'folke/tokyonight.nvim'

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

  -- Indentation using in-built commentstring
  use 'terrortylor/nvim-comment'

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

  -- TODO: configure
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icons
    }
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
  use 'AndrewRadev/bufferize.vim'

  -- Buffer management
  use 'kazhala/close-buffers.nvim'

  -- Session management
  use {
    'rmagatti/auto-session',
    config = function()
      require("auto-session").setup {
        log_level = "info",
        auto_session_enabled = false, -- no automatic save+restore
        auto_session_use_git_branch = true,
      }
      vim.opt.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
    end
  }

  -- EditorConfig support for project-level settings
  use 'editorconfig/editorconfig-vim'

  -- Dev Tools
  -- TODO: figure out if this is needed/useful
  -- use 'sakhnik/nvim-gdb'

  -- Keep last, in order to bootstrap successfully.
  if packer_bootstrap then
    require('packer').sync()
  end
end)

--------------------------------------------------------
-- Tiny Helpers
--------------------------------------------------------
local is_mouse_enabled = function()
  return string.find(vim.opt.mouse._value, 'a')
end

--------------------------------------------------------
-- General Settings
--------------------------------------------------------
vim.opt.scrolloff = 8
vim.g.mapleader = ","
vim.opt.number = true
vim.opt.relativenumber = false

vim.opt.title = true -- Set the terminal window title

-- Searching
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.smartcase = true

-- Pretty
vim.opt.termguicolors = true
vim.cmd "colorscheme tokyonight"
--vim.cmd "colorscheme one-nvim"
--vim.cmd "colorscheme witchhazel-hypercolor"

-- Line-wrapping
vim.opt.wrap = true
vim.opt.linebreak = true   -- Avoid line-wrapping in the middle of a word.
vim.opt.breakindent = true -- Hanging indent soft-wrap ...
vim.opt.sbr = " "         -- ... prefixed by an arrow, and a space (to make it line up with a match 2-space indent).
vim.opt.breakindentopt = "min:20,shift:0"
vim.opt.shiftround = true  -- Round to nearest shiftwidth value

-- Compatibility
vim.opt.fixendofline = false -- Keep no-end-of-line if a file has that.

-- Persistent undo
local undo_path = vim.fn.stdpath('data')..'/undo'
if vim.fn.empty(vim.fn.glob(undo_path)) > 0 then
  vim.fn.system({"mkdir", "-p", undo_path})
end
vim.opt.undofile = true
vim.opt.undodir = undo_path..'/'
vim.opt.swapfile = false

vim.opt.textwidth = 0
vim.opt.list = true -- Show tabs as >, trailing spaces as -, nbsp as +.
vim.opt.cc = '81'
vim.opt.ruler = true
vim.opt.scrolloff = 2 -- Keep some space at the bottom of the window

-- Indentation
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true

-- Stay in visual mode while indenting
vim.keymap.set('v', '<', '<gv', {})
vim.keymap.set('v', '>', '>gv', {})

-- Resize panes on window/viewport resize
vim.api.nvim_command('autocmd VimResized * wincmd =')

-- Mouse
vim.opt.mouse = 'a'
vim.keymap.set('n', '<leader>M', function()
  -- TODO: this wipes out all existing mouse settings; seems bad.
  vim.opt.mouse = is_mouse_enabled() and '' or 'a'
end, {desc = "Toggle Mouse-enabled"})

-- Paste
vim.keymap.set('n', '<leader>P', function()
  if vim.opt.paste._value then
    vim.opt.paste = false
  else
    vim.opt.paste = true
  end
end, {desc = "Toggle Paste-enabled"})

-- Mouse-mode + Paste
vim.keymap.set('v', '<M-c>', '"+y', {desc = "Copy to system clipboard" })

-- Buffers and Tabs
-- Tab-moving (complementing gt and gT)
vim.keymap.set('n', 'mt', ':tabmove +1<cr>')
vim.keymap.set('n', 'mT', ':tabmove -1<cr>')

-- Buffer navigation
vim.keymap.set('n', 'gb', ':bnext<cr>')
vim.keymap.set('n', 'gB', ':bprevious<cr>')

-- Autoclose those damn netrw buffers
vim.g.netrw_fastbrowse = 0

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
-- Remember info about open buffers on close.
-- This would be 'vim.opt.viminfo:prepend("%")', but this doesn't seem to work on 0.8.x...?
vim.opt.viminfo = "%,"..vim.opt.viminfo._value

-- Source the vimrc file after saving it
vim.cmd [[
  augroup sourcing
    autocmd!
    autocmd bufwritepost init.lua source $MYVIMRC
  augroup end
]]

--------------------------------------------------------
-- Commenting
--------------------------------------------------------
require('nvim_comment').setup {
  marker_padding = true, -- no space after comment markers
  create_mappings = false,
}
vim.keymap.set('v', '<leader>/', ':CommentToggle<cr>')
vim.keymap.set('n', '<leader>/', ':CommentToggle<cr>')

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
  ensure_installed = {
    "c",
    "cpp",
    "elixir",
    "html",
    "javascript",
    "lua",
    "python",
    "ruby",
    "rust",
    "typescript",
  },
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

vim.keymap.set('n', '<C-p>f', '<cmd>Telescope find_files theme=dropdown<cr>')
vim.keymap.set('n', '<C-p>r', '<cmd>Telescope registers theme=cursor<cr>')
vim.keymap.set('n', '<C-p>b', '<cmd>Telescope buffers theme=ivy previewer=false<cr>')

vim.keymap.set('n', '<leader>lr', '<cmd>Telescope lsp_references theme=dropdown<cr>')
vim.keymap.set('n', '<leader>lg', '<cmd>Telescope lsp_definitions theme=cursor<cr>')
vim.keymap.set('n', '<leader>lG', '<cmd>Telescope lsp_type_definitions theme=cursor<cr>')

-- Show LSP errors + warnings
--vim.keymap.set('n', '<leader>le', '<cmd>Telescope diagnostics bufnr=0<cr>')
vim.keymap.set('n', '<leader>le', '<cmd>TroubleToggle<cr>')

vim.keymap.set('n', '<leader>lR', vim.lsp.buf.rename, {desc="LSP Rename"})

vim.keymap.set('n', '<leader>lt', vim.lsp.buf.hover, {desc="LSP Hover Info"})

vim.keymap.set('i', '<leader>lc', vim.lsp.buf.completion, {desc="LSP Complete"})

--------------------------------------------------------
-- Language Server Configuration
--------------------------------------------------------
require('mason').setup()
require('mason-lspconfig').setup()

local lspconfig = require("lspconfig")
local masonLspConfig = require("mason-lspconfig")
masonLspConfig.setup {
  ensure_installed = {
    'clangd',
    -- 'elixirls',
    'html',
    'rust_analyzer',
    'solargraph',
    'tsserver',
  },
}
masonLspConfig.setup_handlers {
  function (server_name)
    if server_name == "pylsp" then
      lspconfig[server_name].setup{
        settings = {
          pylsp = {
            plugins = {
              pycodestyle = {
                ignore = {'E265'}
              }
            }
          }
        }
      }
    else
      lspconfig[server_name].setup {}
    end
  end
}

vim.api.nvim_create_user_command('LspFormat', function(_)
  if vim.lsp.buf.format then
    vim.lsp.buf.format()
  elseif vim.lsp.buf.formatting then
    vim.lsp.buf.formatting()
  end
end, { desc = 'Format current buffer with LSP' })

-- Autoformat on request
vim.keymap.set({'n', 'v'}, '<leader>lf', vim.lsp.buf.format, { remap = false })

function format_range_operator()
  local old_func = vim.go.operatorfunc
  _G.op_func_formatting = function()
    local start = vim.api.nvim_buf_get_mark(0, '[')
    local finish = vim.api.nvim_buf_get_mark(0, ']')
    vim.lsp.buf.format({ range = { start = start, ["end"] = finish }})
    vim.go.operatorfunc = old_func
    _G.op_func_formatting = nil
  end
  vim.go.operatorfunc = 'v:lua.op_func_formatting'
  vim.api.nvim_feedkeys('g@', 'n', false)
end
vim.api.nvim_set_keymap("n", "gm", "<cmd>lua format_range_operator()<CR>", {noremap = true})

-- ... and on save:
-- TODO: maybe hook into gg=G formatter thingy
--vim.cmd [[
--  augroup LspFormat
--]]

-- TODO: neovim nerdtree equivalent

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
do
  -- mode: Include 'Mouse' and 'Paste' info
  local mode = function()
    local ms = require('lualine.utils.mode').get_mode()
    if is_mouse_enabled() then
      ms = ms .. ' '
    end
    if vim.opt.paste:get() then
      ms = ms .. ' '
    end
    return ms
  end
  -- encoding: Don't display if encoding is UTF-8.
  local encoding = function()
    local ret, _ = (vim.bo.fenc or vim.go.enc):gsub("^utf%-8$", "")
    return ret
  end
  -- fileformat: Don't display if &ff is unix.
  local fileformat = function()
    local ret, _ = vim.bo.fileformat:gsub("^unix$", "")
    return ret
  end
  -- statusline: Handle nil return values for :term buffers
  local statusline = function()
    local ret = require('nvim-treesitter').statusline({})
    return (ret or '')
  end
  local filetype = {'filetype', colored = false, icon_only = true}

  require('lualine').setup {
    theme = 'onedark',
    options = {
      component_separators = '',
      section_separators = '',
    },
    sections = {
      lualine_a = {mode},
      lualine_b = {'branch', 'diff', 'diagnostics'},
      lualine_c = {statusline},
      lualine_x = {encoding, fileformat, filetype},
      lualine_y = {'progress'},
      lualine_z = {'location'}
    },
  }
end

--------------------------------------------------------
-- Undo Tree
--------------------------------------------------------
vim.keymap.set('n', '<leader>u', ':UndotreeToggle<CR>')
vim.g.undotree_WindowLayout = 3
vim.g.undotree_SetFocusWhenToggle = 1

--------------------------------------------------------
-- Close Buffers
--------------------------------------------------------
vim.keymap.set('n', '<leader>bd', ':BDelete! hidden<CR>')

--------------------------------------------------------
-- Tree/Dir Navigation
--------------------------------------------------------
-- A little bit of vim-vinegar.
-- (Hit - to navigate to the directory the current file
-- sits in.)
vim.keymap.set('n', '-', function()
  -- i can't be arsed to convert this to lua
  vim.cmd [[
    let fname = expand('%:t')
    edit %:h
    normal! gg
    call search('\<'.fname.'\>')
  ]]
end, { desc = "Vinegarette" })

--------------------------------------------------------
-- Daily Planner
--------------------------------------------------------
do
  next_day = function()
    local fdir = vim.fn.expand('%:h')
    local fname = vim.fn.expand('%:t:r')
    local nfname = string.gsub(
      vim.fn.system("gdate -d '" .. fname .. " +1 day' +%F"),
      "%c+$",
      ""
    )
    vim.cmd.edit(fdir .. "/" .. nfname .. ".txt")
  end
  vim.api.nvim_create_user_command('NextDay', next_day, {})
end
