-- Install package manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system { 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath }
end
vim.opt.rtp:prepend(lazypath)

-- Add plugins
require('lazy').setup({
  'fatih/vim-go', -- Go support
  'p00f/nvim-ts-rainbow', -- Rainbow parentheses
  'tpope/vim-fugitive', -- Git commands in nvim
  'tpope/vim-rhubarb', -- Fugitive-companion to interact with github
  'Shougo/denite.nvim',
  'Shougo/neosnippet',
  'Shougo/neosnippet-snippets',
  'numToStr/Comment.nvim', -- "gc" to comment visual regions/lines
  'stevearc/oil.nvim', -- More modern netrw
  'navarasu/onedark.nvim', -- Colorscheme
  'nvim-lualine/lualine.nvim', -- Fancier statusline
  'Xuyuanp/nerdtree-git-plugin',
  'vim-airline/vim-airline',
  'chrisbra/csv.vim', -- CSV file helpers
  'christoomey/vim-tmux-navigator',
  'ctrlpvim/ctrlp.vim', -- CtrlP is installed to support tag finding in vim-go
  'editorconfig/editorconfig-vim',
  'plasticboy/vim-markdown', -- Markdown syntax highlighting
  'lukas-reineke/indent-blankline.nvim', -- Add indentation guides even on blank lines
  'lewis6991/gitsigns.nvim', -- Add git related info in the signs columns and popups
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "hcl",
        "terraform",
      },
    },
  }, -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter-textobjects', -- Additional textobjects for treesitter
  'neovim/nvim-lspconfig', -- Collection of configurations for built-in LSP client
  'williamboman/mason.nvim', -- Automatically install LSPs to stdpath for neovim
  'williamboman/mason-lspconfig.nvim', -- ibid
  'folke/neodev.nvim', -- Lua language server configuration for nvim
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
  },
  -- Fuzzy Finder (files, lsp, etc)
  { 'nvim-telescope/telescope.nvim', version = '*', dependencies = { 'nvim-lua/plenary.nvim' } },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you have trouble with this installation, refer to the README for telescope-fzf-native.
    build = 'make',
  },
  -- Colorschemes
  'NLKNguyen/papercolor-theme',
  'altercation/vim-colors-solarized',
  'ayu-theme/ayu-vim',
  'cocopon/iceberg.vim',
  'dikiaap/minimalist',
  'kaicataldo/material.vim',
  'rakr/vim-one'
}, {})

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Set colorscheme (order is important here)
vim.o.termguicolors = true
vim.cmd.colorscheme 'onedark'

-- Set statusbar
require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'onedark',
    component_separators = '|',
    section_separators = '',
  },
}

-- Enable Comment.nvim
require('Comment').setup()

-- Remap space as leader key
vim.keymap.set({ 'n', 'v' }, ',', '<Nop>', { silent = true })
vim.g.mapleader = ','
vim.g.maplocalleader = ','

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Add indent guides
require("ibl").setup({
	indent = { char = "┊" },
	whitespace = { remove_blankline_trail = false },
})

-- Gitsigns
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
  on_attach = function(bufnr)
    vim.keymap.set('n', '[c', require('gitsigns').prev_hunk, { buffer = bufnr })
    vim.keymap.set('n', ']c', require('gitsigns').next_hunk, { buffer = bufnr })
  end,
}

-- Oil
require('oil').setup()
vim.keymap.set('n', '-', function() require('oil').open() end, { desc = 'Open parent directory' })

-- Telescope
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native
require('telescope').load_extension 'fzf'

-- Add leader shortcuts
vim.keymap.set('n', '<leader><space>', function() require('telescope.builtin').buffers { sort_lastused = true } end)
vim.keymap.set('n', '<leader>sf', function() require('telescope.builtin').find_files { previewer = false } end)
vim.keymap.set('n', '<leader>sb', function() require('telescope.builtin').current_buffer_fuzzy_find() end)
vim.keymap.set('n', '<leader>sh', function() require('telescope.builtin').help_tags() end)
vim.keymap.set('n', '<leader>st', function() require('telescope.builtin').tags() end)
vim.keymap.set('n', '<leader>sd', function() require('telescope.builtin').grep_string() end)
vim.keymap.set('n', '<leader>sp', function() require('telescope.builtin').live_grep() end)
vim.keymap.set('n', '<leader>?', function() require('telescope.builtin').oldfiles() end)

-- Treesitter configuration
-- Parsers must be installed manually via :TSInstall
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true, -- false will disable the whole extension
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  indent = {
    enable = true,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
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

-- Diagnostic settings
vim.diagnostic.config {
  virtual_text = false,
  update_in_insert = true,
}

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
vim.keymap.set('n', '<leader>Q', vim.diagnostic.setqflist)

-- LSP settings
require('mason').setup {}
require('mason-lspconfig').setup({
  ensure_installed = { "bashls", "html", "ts_ls" }
})

-- Add nvim-lspconfig plugin
local lspconfig = require 'lspconfig'
local on_attach = function(_, bufnr)
  local attach_opts = { silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, attach_opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, attach_opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, attach_opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, attach_opts)
  vim.keymap.set('n', '<C-s>', vim.lsp.buf.signature_help, attach_opts)
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, attach_opts)
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, attach_opts)
  vim.keymap.set('n', '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, attach_opts)
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, attach_opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, attach_opts)
  vim.keymap.set('n', 'so', require('telescope.builtin').lsp_references, attach_opts)
end

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Enable the following language servers
local servers = { 'clangd', 'rust_analyzer', 'pyright', 'ts_ls' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

require('neodev').setup {}

lspconfig.lua_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      completion = {
        callSnippet = 'Replace',
      },
    },
  },
}

-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'

luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}
-- vim: ts=2 sts=2 sw=2 et


-- local vim = vim
-- local Plug = vim.fn['plug#']

-- vim.call('plug#begin')

-- -- Dependencies
-- -- Depenency for Shougo/neosnippet
-- Plug('Shougo/neocomplcache')
-- -- This must come before plasticboy/vim-markdown
-- Plug('godlygeek/tabular')
-- -- Depenency for tpope/fugitive
-- Plug('tpope/vim-rhubarb')

-- -- General plugins
-- Plug('Shougo/denite.nvim')
-- Plug('Shougo/neosnippet')
-- -- Default snippets for many languages
-- Plug('Shougo/neosnippet-snippets')
-- -- Add git support for nerdtree
-- Plug('Xuyuanp/nerdtree-git-plugin')
-- Plug('vim-airline/vim-airline')
-- -- CSV file helpers
-- Plug('chrisbra/csv.vim')
-- Plug('christoomey/vim-tmux-navigator')
-- -- CtrlP is installed to support tag finding in vim-go
-- Plug('ctrlpvim/ctrlp.vim')
-- Plug('editorconfig/editorconfig-vim')
-- Plug('junegunn/fzf')
-- Plug('junegunn/fzf.vim')
-- Plug('junegunn/goyo.vim')
-- Plug('majutsushi/tagbar')
-- Plug('mg979/vim-visual-multi')
-- Plug('mhinz/vim-signify')
-- Plug('mileszs/ack.vim')
-- -- Support floating preview windows in neovim
-- Plug('ncm2/float-preview.nvim')
-- Plug('neomake/neomake')
-- Plug('preservim/nerdcommenter')
-- PlugPlug('preservim/nerdtree')
-- Plug('rbgrouleff/bclose.vim')
-- Plug('sbdchd/neoformat')
-- Plug('sebdah/vim-delve')
-- Plug('tpope/vim-fugitive')
-- Plug('tpope/vim-surround')
-- Plug('vimwiki/vimwiki')
-- -- vlang syntax highlighting
-- Plug('ollykel/v-vim')

-- -- Language support
-- -- TypeScript syntax
-- Plug('HerringtonDarkholme/yats.vim')            
-- -- PlantUML syntax highlighting
-- Plug('aklt/plantuml-syntax')                    
-- -- toml syntax highlighting
-- Plug('cespare/vim-toml')                        
-- -- nginx syntax highlighting
-- Plug('chr4/nginx.vim')                          
-- -- Fish syntax highlighting
-- Plug('dag/vim-fish')                            
-- -- Pug syntax highlighting
-- Plug('digitaltoad/vim-pug')                     
-- -- Go support
-- Plug('fatih/vim-go')                            
-- -- Terraform syntax highlighting
-- Plug('hashivim/vim-terraform')                  
-- -- GraphQL syntax highlighting and indentation
-- Plug('jparise/vim-graphql')                     
-- -- CoffeeScript syntax highlighting
-- Plug('kchmck/vim-coffee-script')                
-- -- API Blueprint syntax highlighting
-- Plug('kylef/apiblueprint.vim')                  
-- -- TypeScript syntax highlighting
-- Plug('leafgarland/typescript-vim')              
-- -- PostgreSQL syntax highlighting
-- Plug('lifepillar/pgsql.vim')                    
-- -- TypeScript auto completion
-- Plug('mhartington/nvim-typescript', { ['do'] = './install.sh' })
-- -- JSX syntax highlighting
-- Plug('mxw/vim-jsx')                             
-- -- JavaScript syntax highlighting
-- Plug('pangloss/vim-javascript')                 
-- -- Markdown syntax highlighting
-- Plug('plasticboy/vim-markdown')                 
-- -- Puppet syntax highlighting
-- Plug('rodjek/vim-puppet')                       
-- -- Thrift syntax highlighting
-- Plug('solarnz/thrift.vim')                      
-- -- Ruby support
-- Plug('vim-ruby/vim-ruby')                       
-- -- HAProxy syntax highlighting
-- Plug('zimbatm/haproxy.vim')                     

-- -- Colorschemes
-- Plug('NLKNguyen/papercolor-theme')
-- Plug('altercation/vim-colors-solarized')
-- Plug('ayu-theme/ayu-vim')
-- Plug('cocopon/iceberg.vim')
-- Plug('dikiaap/minimalist')
-- Plug('kaicataldo/material.vim', { ['branch'] = 'main' })
-- Plug('rakr/vim-one')
-- Plug('ulwlu/elly.vim')

-- vim.call('plug#end')

-- -- ----------------------------------------------
-- --  General settings
-- -- ----------------------------------------------
-- -- take indent for new line from previous line
-- vim.opt.autoindent = true
-- -- enable smart indentation
-- vim.opt.smartindent = true
-- -- reload file if the file changes on the disk
-- vim.opt.autoread = true
-- -- write when switching buffers
-- vim.opt.autowrite = true
-- -- write on :quit
-- vim.opt.autowriteall = true
-- vim.opt.clipboard= "unnamedplus"
-- -- highlight the 80th column as an indicator
-- vim.opt.colorcolumn = "81"
-- -- highlight the current line for the cursor
-- vim.opt.cursorline = true
-- vim.opt.encoding = "utf-8"
-- -- expands tabs to spaces
-- vim.opt.expandtab = true
-- -- show trailing whitespace
-- vim.opt.list = true
-- vim.opt.listchars = {
--     tab = "» ",
--     trail = "·",
--     extends = "›",
--     precedes = "‹",
--     nbsp = "␣",
-- }
-- -- disable spelling
-- vim.opt.nospell = true
-- -- disable swapfile usage
-- vim.opt.noswapfile = true
-- vim.opt.nowrap = true
-- -- No bells!
-- vim.opt.noerrorbells = true
-- -- I said, no bells!
-- vim.opt.novisualbell = true
-- -- show number ruler
-- vim.opt.number = true
-- -- show relative numbers in the ruler
-- vim.opt.relativenumber = true
-- vim.opt.ruler = true
-- -- set vims text formatting options
-- vim.opt.formatoptions = "tcqronj"         
-- vim.opt.softtabstop = "2"
-- vim.opt.tabstop = "2"
-- -- let vim set the terminal title
-- vim.opt.title = true
-- -- redraw the status bar often
-- vim.opt.updatetime = "100"

-- -- neovim specific settings
-- if has('nvim') then
--     -- Set the Python binaries neovim is using. Please note that you will need to
--     -- install the neovim package for these binaries separately like this for
--     -- example:
--     -- pip3.6 install -U neovim
--     vim.g.python_host_prog = '/usr/bin/python2'
--     vim.g.python3_host_prog = '/usr/bin/python3'
-- end

-- -- Enable mouse if possible
-- if has('mouse') then
--     vim.opt.mouse = "a"
-- end

-- -- Allow vim to set a custom font or color for a word
-- -- syntax enable

-- -- Set the leader button
-- vim.opt.mapleader = ','

-- -- ----------------------------------------------
-- --  Editing
-- -- ----------------------------------------------
-- -- Compete options for the pop up menu for autocompletion.
-- vim.opt.completeopt = "menu,noselect"

-- -- remove the horrendous preview window
-- vim.opt.completeopt = preview

-- -- ----------------------------------------------
-- --  Colors
-- -- ----------------------------------------------

-- -- For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
-- -- Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
-- --  < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
-- if (has("termguicolors")) then
--   vim.opt.termguicolors = true
-- end

-- vim.opt.background = "dark"

-- -- Material colorscheme settings
-- vim.g.material_theme_style = 'darker-community'

-- -- Ayu colorscheme settings
-- vim.opt.ayucolor = 'dark'

-- -- One colorscheme settings
-- vim.g.one_allow_italics = 1

-- vim.cmd("colorscheme ayu")

-- -- ----------------------------------------------
-- --  Searching
-- -- ----------------------------------------------
-- vim.opt.incsearch = true                     -- move to match as you type the search query
-- vim.opt.hlsearch = true                      -- disable search result highlighting

-- if has('nvim') then
--     vim.opt.inccommand = split          -- enables interactive search and replace
-- end

-- -- Clear search highlights
-- vim.keymap.set('n', '<Leader>c', '<cmd>nohlsearch<cr>')


-- -- These mappings will make it so that going to the next one in a search will
-- -- center on the line it's found in.
-- -- nnoremap n nzzzv
-- -- nnoremap N Nzzzv

-- -- ----------------------------------------------
-- --  Navigation
-- -- ----------------------------------------------

-- -- ... but skip the quickfix when navigating
-- -- augroup qf
-- --     autocmd!
-- --     autocmd FileType qf set nobuflisted
-- -- augroup END

-- -- Fix some common typos
-- vim.cmd([[
--     cnoreabbrev Q q
--     cnoreabbrev Q! q!
--     cnoreabbrev Qall qall
--     cnoreabbrev Qall! qall!
--     cnoreabbrev Qa qa
--     cnoreabbrev Qw qw
--     cnoreabbrev Qwa qwa
--     cnoreabbrev W w
--     cnoreabbrev W! w!
--     cnoreabbrev WQ wq
--     cnoreabbrev Wa wa
--     cnoreabbrev Wq wq
--     cnoreabbrev wQ wq
-- ]])

-- -- ----------------------------------------------
-- --  Splits
-- -- ----------------------------------------------
-- --  Create horizontal splits below the current window
-- vim.opt.splitbelow=true
-- vim.opt.splitright=true

-- -- Creating splits
-- map("n", "<leader>v", "<cmd>vsplit<cr>")
-- map("n", "<leader>h", "<cmd>split<cr>")

-- -- Closing splits
-- map("n", "<leader>q", "<cmd>close<cr>")

-- -- ----------------------------------------------
-- --  Tags
-- -- ----------------------------------------------
-- vim.opt.tags="tags;/"

-- -- ----------------------------------------------
-- --  Plugin: MattesGroeger/vim-bookmarks
-- -- ----------------------------------------------
-- -- Auto save bookmarks
-- vim.g.bookmark_auto_save = 1

-- -- Store the bookmarks in the projects
-- vim.g.bookmark_save_per_working_dir = 1

-- -- Disable the default key mappings
-- vim.g.bookmark_no_default_key_mappings = 1

-- -- Configure key mappings
-- -- This part also fixes conflicts with NERDTree
-- -- function! BookmarkMapKeys()
-- --     nmap Mm :BookmarkToggle<cr>
-- --     nmap Mi :BookmarkAnnotate<cr>
-- --     nmap Mn :BookmarkNext<cr>
-- --     nmap Mp :BookmarkPrev<cr>
-- --     nmap Ma :BookmarkShowAll<cr>
-- --     nmap Mc :BookmarkClear<cr>
-- --     nmap Mx :BookmarkClearAll<cr>
-- --     nmap Mkk :BookmarkMoveUp
-- --     nmap Mjj :BookmarkMoveDown
-- -- endfunction
-- -- function! BookmarkUnmapKeys()
-- --     unmap Mm
-- --     unmap Mi
-- --     unmap Mn
-- --     unmap Mp
-- --     unmap Ma
-- --     unmap Mc
-- --     unmap Mx
-- --     unmap Mkk
-- --     unmap Mjj
-- -- endfunction

-- -- vim.api.nvim_create_autocmd({ "BufEnter" }, {
-- --     pattern = "*",
-- --     callback = BookmarkMapKeys
-- -- })
-- -- autocmd BufEnter NERD_tree_* :call BookmarkUnmapKeys()

-- ----------------------------------------------
-- -- Plugin: hashivim/vim-terraform
-- ----------------------------------------------
-- -- Format on save
-- vim.g.terraform_fmt_on_save = 1

-- vim.g.terraform_align = 1

-- ----------------------------------------------
-- -- Plugin: bling/vim-airline
-- ----------------------------------------------
-- -- Show status bar by default.
-- vim.opt.laststatus=2

-- -- Enable top tabline.
-- vim.g["airline#extensions#tabline#enabled"] = 1

-- -- Disable showing tabs in the tabline. This will ensure that the buffers are
-- -- what is shown in the tabline at all times.
-- vim.g["airline#extensions#tabline#show_tabs"] = 0

-- -- Enable powerline fonts.
-- vim.g.airline_powerline_fonts = 0

-- -- Explicitly define some symbols that did not work well for me in Linux.
-- if !exists('g:airline_symbols') then
--     vim.g.airline_symbols = {}
-- end
-- vim.g.airline_symbols.branch = ''
-- vim.g.airline_symbols.maxlinenr = ''

-- ----------------------------------------------
-- -- Plugin: christoomey/vim-tmux-navigator
-- ----------------------------------------------
-- -- tmux will send xterm-style keys when its xterm-keys option is on.
-- -- if (&term =~ '^screen') then
-- --     execute "set <xUp>=\e[1;*A"
-- --     execute "set <xDown>=\e[1;*B"
-- --     execute "set <xRight>=\e[1;*C"
-- --     execute "set <xLeft>=\e[1;*D"
-- -- end

-- -- Tmux vim integration
-- -- vim.g.tmux_navigator_no_mappings = 1
-- -- vim.g.tmux_navigator_save_on_switch = 1

-- -- Move between splits with ctrl+h,j,k,l
-- -- nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
-- -- nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
-- -- nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
-- -- nnoremap <silent> <c-l> :TmuxNavigateRight<cr>
-- -- nnoremap <silent> <c-\> :TmuxNavigatePrevious<cr>

-- ----------------------------------------------
-- -- Plugin: 'ctrlpvim/ctrlp.vim'
-- ----------------------------------------------
-- -- Note: We are not using CtrlP much in this configuration. But vim-go depend on
-- -- it to run GoDecls(Dir).

-- -- Disable the CtrlP mapping, since we want to use FZF instead for <c-p>.
-- vim.g.ctrlp_map = ''

-- ----------------------------------------------
-- -- Plugin: easymotion/vim-easymotion
-- ----------------------------------------------
-- -- Enable support for bidirectional motions
-- -- map  <leader><leader>w <Plug>(easymotion-bd-w)
-- -- nmap <leader><leader>w <Plug>(easymotion-overwin-w)

-- ----------------------------------------------
-- -- Plugin: 'itchyny/calendar.vim'
-- ----------------------------------------------
-- -- Enable Google Calendar integration.
-- vim.g.calendar_google_calendar = 1

-- -- Enable Google Tasks integration.
-- vim.g.calendar_google_task = 1

-- -- Other options
-- vim.g.calendar_first_day = "monday"           -- Weeks starts with Monday
-- vim.g.calendar_date_endian = "big"            -- Format: year / month / day
-- vim.g.calendar_date_separator = "-"           -- Format: year - month - day
-- vim.g.calendar_week_number = 1                -- Show week numbers
-- vim.g.calendar_view = "days"                  -- Set days as the default view

-- ----------------------------------------------
-- -- Plugin: 'junegunn/fzf.vim'
-- ----------------------------------------------
-- -- nnoremap <c-p> :FZF<cr>
-- -- nnoremap <a-p> :FZF<cr>
-- -- nnoremap <a-c> :Commands<cr>
-- -- nnoremap <a-g> :Commits<cr>
-- -- nnoremap <a-s-g> :BCommits<cr>
-- -- nnoremap <a-d> :GitFiles?<cr>
-- -- nnoremap <a-f> :Ag<cr>
-- -- nnoremap <a-r> :Commands<cr>

-- -- Configure preview window
-- vim.g.fzf_preview_window = "['right:50%', 'ctrl-/']"

-- ----------------------------------------------
-- -- Plugin: 'majutsushi/tagbar'
-- ----------------------------------------------
-- -- Add shortcut for toggling the tag bar
-- -- nnoremap <F3> :TagbarToggle<cr>

-- -- Language: Go
-- -- Tagbar configuration for Golang
-- -- vim.g.tagbar_type_go = {
-- --     \ 'ctagstype' : 'go',
-- --     \ 'kinds'     : [
-- --         \ 'p:package',
-- --         \ 'i:imports:1',
-- --         \ 'c:constants',
-- --         \ 'v:variables',
-- --         \ 't:types',
-- --         \ 'n:interfaces',
-- --         \ 'w:fields',
-- --         \ 'e:embedded',
-- --         \ 'm:methods',
-- --         \ 'r:constructor',
-- --         \ 'f:functions'
-- --     \ ],
-- --     \ 'sro' : '.',
-- --     \ 'kind2scope' : {
-- --         \ 't' : 'ctype',
-- --         \ 'n' : 'ntype'
-- --     \ },
-- --     \ 'scope2kind' : {
-- --         \ 'ctype' : 't',
-- --         \ 'ntype' : 'n'
-- --     \ },
-- --     \ 'ctagsbin'  : 'gotags',
-- --     \ 'ctagsargs' : '-sort -silent'
-- -- \ }

-- ----------------------------------------------
-- -- Plugin: ncm2/float-preview.nvim
-- --
-- -- Create a preview dock based on Neovim's floating window concept.
-- ----------------------------------------------
-- -- Show the preview in a docked window. Alternatively it would float next to
-- -- the autocompletion window.
-- vim.g["float_preview#docked"] = 1

-- ----------------------------------------------
-- -- Plugin: plasticboy/vim-markdown
-- ----------------------------------------------
-- -- Disable folding
-- vim.g.vim_markdown_folding_disabled = 1

-- -- Auto shrink the TOC, so that it won't take up 50% of the screen
-- vim.g.vim_markdown_toc_autofit = 1

-- ----------------------------------------------
-- -- Plugin: rbgrouleff/bclose.vim
-- ----------------------------------------------
-- -- Close buffers
-- -- nnoremap <leader>w :Bclose<cr>

-- ----------------------------------------------
-- -- Plugin: mileszs/ack.vim
-- ----------------------------------------------
-- -- Open ack
-- -- nnoremap <leader>a :Ack!<space>

-- ----------------------------------------------
-- -- Plugin: neomake/neomake
-- ----------------------------------------------
-- -- Configure signs.
-- vim.g.neomake_error_sign   = {
--     text = "✖",
--     texthl = "NeomakeErrorSign"
-- }
-- vim.g.neomake_warning_sign = {
--     text = "∆",
--     texthl = "NeomakeWarningSign"
-- }
-- vim.g.neomake_message_sign = {
--     text = "➤",
--     texthl = "NeomakeMessageSign"
-- }
-- vim.g.neomake_info_sign    = {
--     text = "ℹ",
--     texthl = "NeomakeInfoSign"
-- }

-- ----------------------------------------------
-- -- Plugin: scrooloose/nerdtree
-- ----------------------------------------------
-- -- nnoremap <leader>d :NERDTreeToggle<cr>
-- -- nnoremap <leader>n :NERDTreeFocus<cr>
-- -- nnoremap <F2> :NERDTreeToggle<cr>

-- -- Files to ignore
-- let NERDTreeIgnore = [
--     \ '\~$',
--     \ '\.pyc$',
--     \ '^\.DS_Store$',
--     \ '^node_modules$',
--     \ '^.ropeproject$',
--     \ '^__pycache__$'
-- \]

-- -- Close vim if NERDTree is the only opened window.
-- autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | end

-- -- Show hidden files by default.
-- let NERDTreeShowHidden = 1

-- -- Allow NERDTree to change session root.
-- vim.g.NERDTreeChDirMode = 2

-- ----------------------------------------------
-- -- Plugin: sebdah/vim-delve
-- ----------------------------------------------
-- -- Set the Delve backend.
-- vim.g.delve_backend = "native"

-- ----------------------------------------------
-- -- Plugin: Shougo/neosnippet
-- ----------------------------------------------
-- -- Disable the default snippets (needed since we do not install
-- -- Shougo/neosnippet-snippets).
-- --
-- -- Below you can disable default snippets for specific languages. If you set the
-- -- Language to _ it sets the default for all languages.
-- vim.g.neosnippet#disable_runtime_snippets = {
--     \ 'go': 1
-- \}

-- -- Keybindings
-- imap <C-k> <Plug>(neosnippet_expand_or_jump)
-- smap <C-k> <Plug>(neosnippet_expand_or_jump)
-- xmap <C-k> <Plug>(neosnippet_expand_target)

-- -- Set the path to our snippets
-- vim.g.neosnippet#snippets_directory='~/.config/nvim/snippets'

-- ----------------------------------------------
-- -- Plugin: vimwiki/vimwiki
-- ----------------------------------------------
-- -- Path to wiki
-- vim.g.vimwiki_list = [{
--         \ 'path': '~/Dropbox/vimwiki',
--         \ 'syntax': 'markdown',
--         \ 'ext': '.vimwiki.markdown'}]

-- au FileType vimwiki set expandtab
-- au FileType vimwiki set shiftwidth=2
-- au FileType vimwiki set softtabstop=2
-- au FileType vimwiki set tabstop=2

-- ----------------------------------------------
-- -- Language: Golang
-- ----------------------------------------------
-- au FileType go set expandtab
-- au FileType go set shiftwidth=4
-- au FileType go set softtabstop=4
-- au FileType go set tabstop=2

-- -- Mappings
-- au FileType go nmap <F8> :GoMetaLinter<cr>
-- au FileType go nmap <F9> :GoCoverageToggle -short<cr>
-- au FileType go nmap <F10> :GoTest -short<cr>
-- au FileType go nmap <F12> <Plug>(go-def)
-- au Filetype go nmap <leader>ga <Plug>(go-alternate-edit)
-- au Filetype go nmap <leader>gah <Plug>(go-alternate-split)
-- au Filetype go nmap <leader>gav <Plug>(go-alternate-vertical)
-- au FileType go nmap <leader>gt :GoDeclsDir<cr>
-- au FileType go nmap <leader>gc <Plug>(go-coverage-toggle)
-- au FileType go nmap <leader>gd <Plug>(go-def)
-- au FileType go nmap <leader>gdv <Plug>(go-def-vertical)
-- au FileType go nmap <leader>gdh <Plug>(go-def-split)
-- au FileType go nmap <leader>gD <Plug>(go-doc)
-- au FileType go nmap <leader>gDv <Plug>(go-doc-vertical)

-- au filetype go inoremap <buffer> . .<C-x><C-o>

-- -- Run goimports when running gofmt
-- vim.g.go_fmt_command = "goimports"

-- -- Set neosnippet as snippet engine
-- vim.g.go_snippet_engine = "neosnippet"

-- -- Enable syntax highlighting per default
-- vim.g.go_highlight_types = 1
-- vim.g.go_highlight_fields = 1
-- vim.g.go_highlight_functions = 1
-- vim.g.go_highlight_methods = 1
-- vim.g.go_highlight_structs = 1
-- vim.g.go_highlight_operators = 1
-- vim.g.go_highlight_build_constraints = 1
-- vim.g.go_highlight_extra_types = 1

-- -- Show the progress when running :GoCoverage
-- vim.g.go_echo_command_info = 1

-- -- Show type information
-- vim.g.go_auto_type_info = 1

-- -- Highlight variable uses
-- vim.g.go_auto_sameids = 0

-- -- Fix for location list when vim-go is used together with Syntastic
-- vim.g.go_list_type = "quickfix"

-- -- Using gopls to find definitions and information.
-- vim.g.go_def_mode='gopls'
-- vim.g.go_info_mode='gopls'

-- -- Add the failing test name to the output of :GoTest
-- vim.g.go_test_show_name = 1

-- -- gometalinter configuration
-- vim.g.go_metalinter_command = ""
-- vim.g.go_metalinter_deadline = "5s"
-- vim.g.go_metalinter_enabled = [
--     \ 'deadcode',
--     \ 'gas',
--     \ 'goconst',
--     \ 'gocyclo',
--     \ 'golint',
--     \ 'gosimple',
--     \ 'ineffassign',
--     \ 'vet',
--     \ 'vetshadow'
-- \]

-- -- Set whether the JSON tags should be snakecase or camelcase.
-- vim.g.go_addtags_transform = "snakecase"

-- -- neomake configuration for Go.
-- vim.g.neomake_go_enabled_makers = [ 'go', 'gometalinter' ]
-- vim.g.neomake_go_gometalinter_maker = {
--   \ 'args': [
--   \   '--tests',
--   \   '--enable-gc',
--   \   '--concurrency=3',
--   \   '--fast',
--   \   '-D', 'aligncheck',
--   \   '-D', 'dupl',
--   \   '-D', 'gocyclo',
--   \   '-D', 'gotype',
--   \   '-E', 'misspell',
--   \   '-E', 'unused',
--   \   '%:p:h',
--   \ ],
--   \ 'append_file': 0,
--   \ 'errorformat':
--   \   '%E%f:%l:%c:%trror: %m,' .
--   \   '%W%f:%l:%c:%tarning: %m,' .
--   \   '%E%f:%l::%trror: %m,' .
--   \   '%W%f:%l::%tarning: %m'
--   \ }

-- ----------------------------------------------
-- -- Language: apiblueprint
-- ----------------------------------------------
-- au FileType apiblueprint set expandtab
-- au FileType apiblueprint set shiftwidth=4
-- au FileType apiblueprint set softtabstop=4
-- au FileType apiblueprint set tabstop=4

-- ----------------------------------------------
-- -- Language: Bash
-- ----------------------------------------------
-- au FileType sh set expandtab
-- au FileType sh set shiftwidth=2
-- au FileType sh set softtabstop=2
-- au FileType sh set tabstop=2

-- ----------------------------------------------
-- -- Language: C++
-- ----------------------------------------------
-- au FileType cpp set expandtab
-- au FileType cpp set shiftwidth=4
-- au FileType cpp set softtabstop=4
-- au FileType cpp set tabstop=4

-- ----------------------------------------------
-- -- Language: CSS
-- ----------------------------------------------
-- au FileType css set expandtab
-- au FileType css set shiftwidth=2
-- au FileType css set softtabstop=2
-- au FileType css set tabstop=2

-- ----------------------------------------------
-- -- Language: gitcommit
-- ----------------------------------------------
-- au FileType gitcommit setlocal spell
-- au FileType gitcommit setlocal textwidth=80

-- ----------------------------------------------
-- -- Language: fish
-- ----------------------------------------------
-- au FileType fish set expandtab
-- au FileType fish set shiftwidth=2
-- au FileType fish set softtabstop=2
-- au FileType fish set tabstop=2

-- ----------------------------------------------
-- -- Language: gitconfig
-- ----------------------------------------------
-- au FileType gitconfig set expandtab
-- au FileType gitconfig set shiftwidth=2
-- au FileType gitconfig set softtabstop=2
-- au FileType gitconfig set tabstop=2

-- ----------------------------------------------
-- -- Language: HTML
-- ----------------------------------------------
-- au FileType html set expandtab
-- au FileType html set shiftwidth=2
-- au FileType html set softtabstop=2
-- au FileType html set tabstop=2

-- ----------------------------------------------
-- -- Language: JavaScript
-- ----------------------------------------------
-- au FileType javascript set expandtab
-- au FileType javascript set shiftwidth=2
-- au FileType javascript set softtabstop=2
-- au FileType javascript set tabstop=2

-- ----------------------------------------------
-- -- Language: JSON
-- ----------------------------------------------
-- au FileType json set expandtab
-- au FileType json set shiftwidth=2
-- au FileType json set softtabstop=2
-- au FileType json set tabstop=2

-- ----------------------------------------------
-- -- Language: LESS
-- ----------------------------------------------
-- au FileType less set expandtab
-- au FileType less set shiftwidth=2
-- au FileType less set softtabstop=2
-- au FileType less set tabstop=2

-- ----------------------------------------------
-- -- Language: Make
-- ----------------------------------------------
-- au FileType make set expandtab
-- au FileType make set shiftwidth=2
-- au FileType make set softtabstop=2
-- au FileType make set tabstop=2

-- ----------------------------------------------
-- -- Language: Markdown
-- ----------------------------------------------
-- au FileType markdown setlocal spell
-- au FileType markdown set expandtab
-- au FileType markdown set shiftwidth=4
-- au FileType markdown set softtabstop=4
-- au FileType markdown set tabstop=4
-- au FileType markdown set syntax=markdown

-- ----------------------------------------------
-- -- Language: PlantUML
-- ----------------------------------------------
-- au FileType plantuml set expandtab
-- au FileType plantuml set shiftwidth=2
-- au FileType plantuml set softtabstop=2
-- au FileType plantuml set tabstop=2

-- ----------------------------------------------
-- -- Language: Protobuf
-- ----------------------------------------------
-- au FileType proto set expandtab
-- au FileType proto set shiftwidth=2
-- au FileType proto set softtabstop=2
-- au FileType proto set tabstop=2

-- ----------------------------------------------
-- -- Language: Python
-- ----------------------------------------------
-- au FileType python set expandtab
-- au FileType python set shiftwidth=4
-- au FileType python set softtabstop=4
-- au FileType python set tabstop=4

-- ----------------------------------------------
-- -- Language: Ruby
-- ----------------------------------------------
-- au FileType ruby set expandtab
-- au FileType ruby set shiftwidth=2
-- au FileType ruby set softtabstop=2
-- au FileType ruby set tabstop=2

-- --
-- -- Plugin: Enable neomake for linting.
-- --
-- -- Vim will load/evaluate code in order to provide completions. This may
-- -- cause some code execution, which may be a concern.
-- vim.g.rubycomplete_buffer_loading = 1

-- -- In context 1 above, Vim can parse the entire buffer to add a list of
-- -- classes to the completion results.
-- vim.g.rubycomplete_classes_in_global = 1

-- -- Vim can parse a Gemfile, in case gems are being implicitly required.
-- vim.g.rubycomplete_load_gemfile = 1

-- ----------------------------------------------
-- -- Language: SQL
-- ----------------------------------------------
-- au FileType sql set expandtab
-- au FileType sql set shiftwidth=2
-- au FileType sql set softtabstop=2
-- au FileType sql set tabstop=2

-- ----------------------------------------------
-- -- Language: Thrift
-- ----------------------------------------------
-- au FileType thrift set expandtab
-- au FileType thrift set shiftwidth=2
-- au FileType thrift set softtabstop=2
-- au FileType thrift set tabstop=2

-- ----------------------------------------------
-- -- Language: TOML
-- ----------------------------------------------
-- au FileType toml set expandtab
-- au FileType toml set shiftwidth=2
-- au FileType toml set softtabstop=2
-- au FileType toml set tabstop=2

-- ----------------------------------------------
-- -- Language: TypeScript
-- ----------------------------------------------
-- au FileType typescript set expandtab
-- au FileType typescript set shiftwidth=4
-- au FileType typescript set softtabstop=4
-- au FileType typescript set tabstop=4

-- ----------------------------------------------
-- -- Language: Vader
-- ----------------------------------------------
-- au FileType vader set expandtab
-- au FileType vader set shiftwidth=2
-- au FileType vader set softtabstop=2
-- au FileType vader set tabstop=2

-- ----------------------------------------------
-- -- Language: vimscript
-- ----------------------------------------------
-- au FileType vim set expandtab
-- au FileType vim set shiftwidth=4
-- au FileType vim set softtabstop=4
-- au FileType vim set tabstop=4

-- ----------------------------------------------
-- -- Language: YAML
-- ----------------------------------------------
-- --au FileType yaml set autoindent
-- --au FileType yml set autoindent
-- au FileType yaml,yml setlocal tabstop=2 softtabstop=2 expandtab shiftwidth=2
-- --au FileType yml set shiftwidth=2
-- --au FileType yml set softtabstop=2
-- --au FileType yml set tabstop=2

