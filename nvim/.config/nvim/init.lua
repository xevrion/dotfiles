--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||   KICKSTART.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================

What is Kickstart?

  Kickstart.nvim is *not* a distribution.

  Kickstart.nvim is a starting point for your own configuration.
    The goal is that you can read every line of code, top-to-bottom, understand
    what your configuration is doing, and modify it to suit your needs.

    Once you've done that, you can start exploring, configuring and tinkering to
    make Neovim your own! That might mean leaving Kickstart just the way it is for a while
    or immediately breaking it into modular pieces. It's up to you!

    If you don't know anything about Lua, I recommend taking some time to read through
    a guide. One possible example which will only take 10-15 minutes:
      - https://learnxinyminutes.com/docs/lua/

    After understanding a bit more about Lua, you can use `:help lua-guide` as a
    reference for how Neovim integrates Lua.
    - :help lua-guide
    - (or HTML version): https://neovim.io/doc/user/lua-guide.html

Kickstart Guide:

  TODO: The very first thing you should do is to run the command `:Tutor` in Neovim.

    If you don't know what this means, type the following:
      - <escape key>
      - :
      - Tutor
      - <enter key>

    (If you already know the Neovim basics, you can skip this step.)

  Once you've completed that, you can continue working through **AND READING** the rest
  of the kickstart init.lua.

  Next, run AND READ `:help`.
    This will open up a help window with some basic information
    about reading, navigating and searching the builtin help documentation.

    This should be the first place you go to look when you're stuck or confused
    with something. It's one of my favorite Neovim features.

    MOST IMPORTANTLY, we provide a keymap "<space>sh" to [s]earch the [h]elp documentation,
    which is very useful when you're not exactly sure of what you're looking for.

  I have left several `:help X` comments throughout the init.lua
    These are hints about where to find more information about the relevant settings,
    plugins or Neovim features used in Kickstart.

   NOTE: Look for lines like this

    Throughout the file. These are for you, the reader, to help you understand what is happening.
    Feel free to delete them once you know what you're doing, but they should serve as a guide
    for when you are first encountering a few different constructs in your Neovim config.

If you experience any errors while trying to install kickstart, run `:checkhealth` for more info.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now! :)
--]]

-- ============================================================
-- SECTION 1: OPTIONS
-- Core Neovim settings, leaders, options, basic keymaps, basic autocmds
-- ============================================================
do
  -- Enable faster startup by caching compiled Lua modules
  vim.loader.enable()

  -- Set <space> as the leader key
  -- See `:help mapleader`
  --  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '

  -- Set to true if you have a Nerd Font installed and selected in the terminal
  vim.g.have_nerd_font = true

  -- [[ Setting options ]]
  --  See `:help vim.o`
  -- NOTE: You can change these options as you wish!
  --  For more options, you can see `:help option-list`

  -- Make line numbers default
  vim.o.number = true
  -- You can also add relative line numbers, to help with jumping.
  --  Experiment for yourself to see if you like it!
  -- vim.o.relativenumber = true

  -- Enable mouse mode, can be useful for resizing splits for example!
  vim.o.mouse = 'a'

  -- Don't show the mode, since it's already in the status line
  vim.o.showmode = false

  -- Sync clipboard between OS and Neovim.
  --  Schedule the setting after `UiEnter` because it can increase startup-time.
  --  Remove this option if you want your OS clipboard to remain independent.
  --  See `:help 'clipboard'`
  vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

  -- Enable break indent
  vim.o.breakindent = true

  -- Enable undo/redo changes even after closing and reopening a file
  vim.o.undofile = true

  -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
  vim.o.ignorecase = true
  vim.o.smartcase = true

  -- Keep signcolumn on by default
  vim.o.signcolumn = 'yes'

  -- Decrease update time
  vim.o.updatetime = 250

  -- Decrease mapped sequence wait time
  vim.o.timeoutlen = 300

  -- Configure how new splits should be opened
  vim.o.splitright = true
  vim.o.splitbelow = true

  -- Sets how neovim will display certain whitespace characters in the editor.
  --  See `:help 'list'`
  --  and `:help 'listchars'`
  --
  --  Notice listchars is set using `vim.opt` instead of `vim.o`.
  --  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
  --   See `:help lua-options`
  --   and `:help lua-guide-options`
  vim.o.list = true
  vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

  -- Preview substitutions live, as you type!
  vim.o.inccommand = 'split'

  -- Show which line your cursor is on
  vim.o.cursorline = true

  -- Minimal number of screen lines to keep above and below the cursor.
  vim.o.scrolloff = 10

  -- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
  -- instead raise a dialog asking if you wish to save the current file(s)
  -- See `:help 'confirm'`
  vim.o.confirm = true

  -- ============================================================
  -- Auto-Reload Buffers on Disk Changes (Autoread)
  -- ============================================================
  -- Enable the global autoread option
  vim.o.autoread = true

  local autoread_group = vim.api.nvim_create_augroup('AutoreadEnable', { clear = true })

  -- Trigger checktime to check for disk changes when:
  --  - FocusGained: You switch back to your terminal/GUI window
  --  - BufEnter: You switch to a different buffer inside Neovim
  --  - CursorHold/CursorHoldI: Your cursor stands still for a moment
  vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
    group = autoread_group,
    pattern = '*',
    callback = function()
      -- Only run checktime if we are in normal mode and not in a special buffer (like terminal)
      if vim.fn.mode() ~= 'c' and vim.bo.buftype == '' then vim.cmd 'checktime' end
    end,
  })

  local term_buf = nil
  local term_win = nil

  local function toggle_terminal()
    -- 1. If the terminal window is open and valid, hide it (keeps the shell alive in the background)
    if term_win and vim.api.nvim_win_is_valid(term_win) then
      vim.api.nvim_win_hide(term_win)
      term_win = nil
      return
    end

    -- 2. If the terminal buffer exists and is valid, re-open it in a split
    if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
      vim.cmd 'split | wincmd J | resize 15'
      vim.api.nvim_win_set_buf(0, term_buf)
      term_win = vim.api.nvim_get_current_win()
      vim.cmd 'startinsert'
    else
      -- 3. Otherwise, create a brand-new terminal session
      vim.cmd 'split | wincmd J | resize 15 | terminal'
      term_buf = vim.api.nvim_get_current_buf()
      term_win = vim.api.nvim_get_current_win()
      vim.cmd 'startinsert'
    end
  end

  -- Keymap to toggle from Normal Mode
  vim.keymap.set('n', '<leader>t', toggle_terminal, { desc = '[T]oggle Terminal' })

  -- Keymap to toggle directly from INSIDE the terminal without typing "Esc Esc" first
  -- (We use Ctrl+T here because mapping Space+T in terminal mode would break typing spaces)
  vim.keymap.set('t', '<C-t>', toggle_terminal, { desc = 'Toggle Terminal' })
end

-- ============================================================
-- SECTION 2: KEYMAPS
-- basic keymaps
-- ============================================================
do
  -- [[ Basic Keymaps ]]
  --  See `:help vim.keymap.set()`

  -- Clear highlights on search when pressing <Esc> in normal mode
  --  See `:help hlsearch`
  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

  -- Diagnostic Config & Keymaps
  --  See `:help vim.diagnostic.Opts`
  vim.diagnostic.config {
    update_in_insert = false,
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = { severity = { min = vim.diagnostic.severity.WARN } },

    -- Can switch between these as you prefer
    virtual_text = true, -- Text shows up at the end of the line
    virtual_lines = false, -- Text shows up underneath the line, with virtual lines

    -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
    jump = {
      on_jump = function(_, bufnr)
        vim.diagnostic.open_float {
          bufnr = bufnr,
          scope = 'cursor',
          focus = false,
        }
      end,
    },
  }

  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
  vim.keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = 'Show line diagnostics' })

  -- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
  -- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
  -- is not what someone will guess without a bit more experience.
  --
  -- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
  -- or just use <C-\><C-n> to exit terminal mode
  vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

  -- TIP: Disable arrow keys in normal mode
  -- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
  -- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
  -- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
  -- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

  -- Keybinds to make split navigation easier.
  --  Use CTRL+<hjkl> to switch between windows
  --
  --  See `:help wincmd` for a list of all window commands
  vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
  vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
  vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
  vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

  -- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
  -- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
  -- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
  -- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
  -- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

  -- [[ Basic Autocommands ]]
  --  See `:help lua-guide-autocommands`

  -- Highlight when yanking (copying) text
  --  Try it with `yap` in normal mode
  --  See `:help vim.hl.on_yank()`
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function() vim.hl.on_yank() end,
  })

  vim.keymap.set({ 'n', 'v', 'o' }, 'H', '^', { desc = 'Go to beginning of line' })
  vim.keymap.set({ 'n', 'v', 'o' }, 'L', '$', { desc = 'Go to end of line' })

  -- Buffer navigation
  vim.keymap.set('n', '<M-l>', '<cmd>bnext<CR>', { desc = 'Next buffer' })
  vim.keymap.set('n', '<M-h>', '<cmd>bprev<CR>', { desc = 'Previous buffer' })
  vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = '[B]uffer [D]elete' })
  vim.keymap.set('n', '<leader>gg', '<cmd>Neogit<cr>', { desc = 'Show Neogit UI' })
end

-- ============================================================
-- SECTION 3: PLUGIN MANAGER INTRO
-- vim.pack intro, build hooks
-- ============================================================
do
  -- [[ Intro to `vim.pack` ]]
  -- `vim.pack` is a new plugin manager built into Neovim,
  --  which provides a Lua interface for installing and managing plugins.
  --
  --  See `:help vim.pack`, `:help vim.pack-examples` or the
  --  excellent blog post from the creator of vim.pack and mini.nvim:
  --  https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack
  --
  --  To inspect plugin state and pending updates, run
  --    :lua vim.pack.update(nil, { offline = true })
  --
  --  To update plugins, run
  --    :lua vim.pack.update()
  --
  --
  --  Throughout the rest of the config there will be examples
  --  of how to install and configure plugins using `vim.pack`.
  --
  --  In this section we set up some autocommands to run build
  --  steps for certain plugins after they are installed or updated.

  local function run_build(name, cmd, cwd)
    local result = vim.system(cmd, { cwd = cwd }):wait()
    if result.code ~= 0 then
      local stderr = result.stderr or ''
      local stdout = result.stdout or ''
      local output = stderr ~= '' and stderr or stdout
      if output == '' then output = 'No output from build command.' end
      vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
    end
  end

  -- This autocommand runs after a plugin is installed or updated and
  --  runs the appropriate build command for that plugin if necessary.
  --
  -- See `:help vim.pack-events`
  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
      local name = ev.data.spec.name
      local kind = ev.data.kind
      if kind ~= 'install' and kind ~= 'update' then return end

      if name == 'telescope-fzf-native.nvim' and vim.fn.executable 'make' == 1 then
        run_build(name, { 'make' }, ev.data.path)
        return
      end

      if name == 'LuaSnip' then
        if vim.fn.has 'win32' ~= 1 and vim.fn.executable 'make' == 1 then run_build(name, { 'make', 'install_jsregexp' }, ev.data.path) end
        return
      end

      if name == 'nvim-treesitter' then
        if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
        vim.cmd 'TSUpdate'
        return
      end
    end,
  })
end

---Because most plugins are hosted on GitHub, you can use the helper
---function to have less repetition in the following sections.
---@param repo string
---@return string
local function gh(repo) return 'https://github.com/' .. repo end

-- ============================================================
-- SECTION 4: UI / CORE UX PLUGINS
-- guess-indent, gitsigns, which-key, colorscheme, todo-comments, mini modules
-- ============================================================
do
  -- [[ Installing and Configuring Plugins ]]
  --
  -- To install a plugin simply call `vim.pack.add` with its git url.
  -- This will download the default branch of the plugin, which will usually be `main` or `master`
  -- You can also have more advanced specs, which we will talk about later.
  --
  -- For most plugins its not enough to install them, you also need to call their `.setup()` to start them.
  --
  -- For example, lets say we want to install `guess-indent.nvim` - a plugin for
  -- automatically detecting and setting the indentation.
  --
  -- We first install it from https://github.com/NMAC427/guess-indent.nvim
  -- and then call its `setup()` function to start it with default settings.
  vim.pack.add { gh 'NMAC427/guess-indent.nvim' }
  require('guess-indent').setup {}

  -- Here is a more advanced configuration example that passes options to `gitsigns.nvim`
  --
  -- See `:help gitsigns` to understand what each configuration key does.
  -- Adds git related signs to the gutter, as well as utilities for managing changes
  vim.pack.add { gh 'lewis6991/gitsigns.nvim' }
  require('gitsigns').setup {
    signs = {
      add = { text = '+' }, ---@diagnostic disable-line: missing-fields
      change = { text = '~' }, ---@diagnostic disable-line: missing-fields
      delete = { text = '_' }, ---@diagnostic disable-line: missing-fields
      topdelete = { text = '‾' }, ---@diagnostic disable-line: missing-fields
      changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
    },
  }
  vim.pack.add { 'https://github.com/folke/lazydev.nvim' }
  require('lazydev').setup {}

  vim.pack.add { gh 'wakatime/vim-wakatime' }

  vim.pack.add { gh 'pocco81/auto-save.nvim' }
  require('auto-save').setup {}

  -- Useful plugin to show you pending keybinds.
  vim.pack.add { gh 'folke/which-key.nvim' }
  require('which-key').setup {
    -- Delay between pressing a key and opening which-key (milliseconds)
    delay = 0,
    icons = { mappings = vim.g.have_nerd_font },
    -- Document existing key chains
    spec = {
      { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } }, -- Enable gitsigns recommended keymaps first
      { 'gr', group = 'LSP Actions', mode = { 'n' } },
    },
  }

  -- [[ Colorscheme ]]
  -- You can easily change to a different colorscheme.
  -- Change the name of the colorscheme plugin below, and then
  -- change the command under that to load whatever the name of that colorscheme is.
  --
  -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
  vim.pack.add { gh 'folke/tokyonight.nvim' }

  vim.pack.add { 'https://github.com/neanias/everforest-nvim' }
  ---@diagnostic disable-next-line: missing-fields
  require('tokyonight').setup {
    styles = {
      comments = { italic = false }, -- Disable italics in comments
    },
  }

  vim.pack.add {
    gh 'NeogitOrg/neogit',
    gh 'sindrets/diffview.nvim', -- dependency
    gh 'nvim-telescope/telescope.nvim', -- dependency
  }

  -- 2. Configure Neogit
  require('neogit').setup {
    -- your custom configuration options go here
  }

  -- 3. Define your keymap

  -- Load the colorscheme here.
  -- Like many other themes, this one has different styles, and you could load
  -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
  vim.g.everforest_background = 'medium'

  vim.cmd.colorscheme 'tokyonight'
  -- Highlight todo, notes, etc in comments
  vim.pack.add { gh 'folke/todo-comments.nvim' }
  require('todo-comments').setup { signs = false }

  -- [[ mini.nvim ]]
  --  A collection of various small independent plugins/modules
  vim.pack.add { gh 'nvim-mini/mini.nvim' }

  -- If a nerd font is available, load the icons module for pretty icons in various plugins.
  if vim.g.have_nerd_font then
    require('mini.icons').setup()
    -- Used for backwards compatibility with plugins that require `nvim-web-devicons` (e.g. telescope.nvim)
    MiniIcons.mock_nvim_web_devicons()
  end

  -- Enable a slim, minimalist tabline for buffer tabs
  require('mini.tabline').setup {
    show_icons = false, -- Turn off file icons
    format = function(buf_id, label)
      -- 1. Check for unsaved changes in Neovim
      local is_modified = vim.bo[buf_id].modified

      -- 2. Check for changes since last Git commit (utilizing gitsigns status)
      local gs = vim.b[buf_id].gitsigns_status_dict
      local has_git_changes = gs and ((gs.added or 0) > 0 or (gs.changed or 0) > 0 or (gs.removed or 0) > 0)

      -- Define a slim indicator suffix
      local indicator = ''
      if is_modified then
        indicator = '•' -- Represents unsaved local changes
      elseif has_git_changes then
        indicator = '~' -- Represents uncommitted Git changes
      end

      -- Format the tab with clean, single-space padding
      if indicator ~= '' then
        return string.format(' %s %s ', label, indicator)
      else
        return string.format(' %s ', label)
      end
    end,
  }
  -- Better Around/Inside textobjects
  --
  -- Examples:
  --  - va)  - [V]isually select [A]round [)]paren
  --  - yiiq - [Y]ank [I]nside [I]+1 [Q]uote
  --  - ci'  - [C]hange [I]nside [']quote
  require('mini.ai').setup {
    -- NOTE: Avoid conflicts with the built-in incremental selection mappings on Neovim>=0.12 (see `:help treesitter-incremental-selection`)
    mappings = {
      around_next = 'aa',
      inside_next = 'ii',
    },
    n_lines = 500,
  }

  -- Add/delete/replace surroundings (brackets, quotes, etc.)
  --
  -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
  -- - sd'   - [S]urround [D]elete [']quotes
  -- - sr)'  - [S]urround [R]eplace [)] [']
  require('mini.surround').setup()

  -- Simple and easy statusline.
  --  You could remove this setup call if you don't like it,
  --  and try some other statusline plugin
  -- local statusline = require 'mini.statusline'
  -- Set `use_icons` to true if you have a Nerd Font
  -- statusline.setup { use_icons = vim.g.have_nerd_font }
  vim.pack.add {
    'https://github.com/nvim-lualine/lualine.nvim',
    'https://github.com/nvim-tree/nvim-web-devicons',
  }

  -- 2. Configure lualine
  require('lualine').setup {
    options = {
      theme = 'auto', -- This automatically matches the statusline to your active colorscheme
      icons_enabled = vim.g.have_nerd_font,
      global_statusline = true,
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
    },
  }
  -- You can configure sections in the statusline by overriding their
  -- default behavior. For example, here we set the section for
  -- cursor location to LINE:COLUMN
  ---@diagnostic disable-next-line: duplicate-set-field
  -- statusline.section_location = function() return '%2l:%-2v' end

  -- ============================================================
  -- SECTION 5: SEARCH & NAVIGATION
  -- Telescope setup, keymaps, LSP picker mappings
  -- ============================================================
  do -- [[ Snacks.nvim Finder & Explorer ]] --
    -- 1. Install snacks.nvim
    -- 1. Install snacks.nvim
    vim.pack.add { 'https://github.com/folke/snacks.nvim' }

    -- 2. Setup snacks.nvim (safely wrapped for hot-reloading)
    local ok, snacks = pcall(require, 'snacks')
    if ok then
      if not snacks.did_setup then
        snacks.setup {
          picker = {
            enabled = true,
            sources = {
              projects = {
                dev = '~/projects',
              },
            },
          },
          explorer = {
            enabled = true,
            replace_netrw = true,
          },
        }
      end
    end
    -- 3. Set the Keymaps (LazyVim equivalents)
    -- Global Pickers & Explorer
    vim.keymap.set('n', '<leader>e', function() Snacks.explorer() end, { desc = 'File Explorer' })
    vim.keymap.set('n', '<leader>,', function() Snacks.picker.buffers() end, { desc = 'Switch Buffer' })
    vim.keymap.set('n', '<leader>/', function() Snacks.picker.grep() end, { desc = 'Grep (Project Root)' })
    vim.keymap.set('n', '<leader>:', function() Snacks.picker.command_history() end, { desc = 'Command History' })
    vim.keymap.set('n', '<leader><space>', function() Snacks.picker.files() end, { desc = 'Find Files (Project Root)' })

    -- [f]ind Submenu
    vim.keymap.set('n', '<leader>ff', function() Snacks.picker.files() end, { desc = 'Find Files' })
    vim.keymap.set('n', '<leader>fr', function() Snacks.picker.recent() end, { desc = 'Recent Files' })
    vim.keymap.set('n', '<leader>fp', function() Snacks.picker.projects() end, { desc = 'Find Projects' })

    -- [s]earch Submenu
    vim.keymap.set('n', '<leader>sg', function() Snacks.picker.grep() end, { desc = 'Grep (Root Dir)' })
    vim.keymap.set('n', '<leader>sw', function() Snacks.picker.grep_word() end, { desc = 'Search Word Under Cursor' })
    vim.keymap.set('n', '<leader>sb', function() Snacks.picker.lines() end, { desc = 'Search Current Buffer Lines' })
    vim.keymap.set('n', '<leader>sk', function() Snacks.picker.keymaps() end, { desc = 'Key Maps' })
    vim.keymap.set('n', '<leader>sh', function() Snacks.picker.help() end, { desc = 'Help Pages' })
    vim.keymap.set('n', '<leader>sR', function() Snacks.picker.resume() end, { desc = 'Resume Last Search' })

    -- Diagnostics & LSP Symbols
    vim.keymap.set('n', '<leader>sd', function() Snacks.picker.diagnostics { filter = { bufnr = 0 } } end, { desc = 'Document Diagnostics' })
    vim.keymap.set('n', '<leader>sD', function() Snacks.picker.diagnostics() end, { desc = 'Workspace Diagnostics' })
    vim.keymap.set('n', '<leader>ss', function() Snacks.picker.lsp_symbols() end, { desc = 'Goto Document Symbol' })
    vim.keymap.set('n', '<leader>sS', function() Snacks.picker.lsp_workspace_symbols() end, { desc = 'Goto Workspace Symbol' })

    -- Git Pickers
    vim.keymap.set('n', '<leader>gs', function() Snacks.picker.git_status() end, { desc = 'Git Status' })
    vim.keymap.set('n', '<leader>gc', function() Snacks.picker.git_log() end, { desc = 'Git Log' })
  end
  -- do
  --   -- [[ Fuzzy Finder (files, lsp, etc) ]]
  --   --
  --   -- Telescope is a fuzzy finder that comes with a lot of different things that
  --   -- it can fuzzy find! It's more than just a "file finder", it can search
  --   -- many different aspects of Neovim, your workspace, LSP, and more!
  --   --
  --   -- There are lots of other alternative pickers (like snacks.picker, or fzf-lua)
  --   -- so feel free to experiment and see what you like!
  --   --
  --   -- The easiest way to use Telescope, is to start by doing something like:
  --   --  :Telescope help_tags
  --   --
  --   -- After running this command, a window will open up and you're able to
  --   -- type in the prompt window. You'll see a list of `help_tags` options and
  --   -- a corresponding preview of the help.
  --   --
  --   -- Two important keymaps to use while in Telescope are:
  --   --  - Insert mode: <c-/>
  --   --  - Normal mode: ?
  --   --
  --   -- This opens a window that shows you all of the keymaps for the current
  --   -- Telescope picker. This is really useful to discover what Telescope can
  --   -- do as well as how to actually do it!
  --
  --   ---@type (string|vim.pack.Spec)[]
  --   local telescope_plugins = {
  --     gh 'nvim-lua/plenary.nvim',
  --     gh 'nvim-telescope/telescope.nvim',
  --     gh 'nvim-telescope/telescope-ui-select.nvim',
  --   }
  --   if vim.fn.executable 'make' == 1 then table.insert(telescope_plugins, gh 'nvim-telescope/telescope-fzf-native.nvim') end
  --
  --   -- NOTE: You can install multiple plugins at once
  --   vim.pack.add(telescope_plugins)
  --
  --   -- See `:help telescope` and `:help telescope.setup()`
  --   require('telescope').setup {
  --     -- You can put your default mappings / updates / etc. in here
  --     --  All the info you're looking for is in `:help telescope.setup()`
  --     --
  --     -- defaults = {
  --     --   mappings = {
  --     --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
  --     --   },
  --     -- },
  --     -- pickers = {}
  --     extensions = {
  --       ['ui-select'] = { require('telescope.themes').get_dropdown() },
  --     },
  --   }
  --
  --   -- Enable Telescope extensions if they are installed
  --   pcall(require('telescope').load_extension, 'fzf')
  --   pcall(require('telescope').load_extension, 'ui-select')
  --
  --   -- See `:help telescope.builtin`
  --   -- ====================================================================
  --   -- LazyVim-Style Telescope Keymaps
  --   -- ====================================================================
  --   local builtin = require 'telescope.builtin'
  --
  --   -- Global Pickers
  --   vim.keymap.set('n', '<leader>,', function() builtin.buffers { sort_mru = true, sort_lastused = true } end, { desc = 'Switch Buffer' })
  --
  --   vim.keymap.set('n', '<leader>/', builtin.live_grep, { desc = 'Grep (Project Root)' })
  --   vim.keymap.set('n', '<leader>:', builtin.command_history, { desc = 'Command History' })
  --   vim.keymap.set('n', '<leader><space>', builtin.find_files, { desc = 'Find Files (Project Root)' })
  --
  --   -- [f]ind Submenu
  --   vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find Files' })
  --   vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = 'Recent Files' })
  --   vim.keymap.set(
  --     'n',
  --     '<leader>fb',
  --     function() builtin.buffers { sort_mru = true, sort_lastused = true, ignore_current_buffer = true } end,
  --     { desc = 'Buffers' }
  --   )
  --
  --   -- [s]earch Submenu
  --   vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'Grep (Root Dir)' })
  --   vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = 'Search Word Under Cursor' })
  --   vim.keymap.set('n', '<leader>sb', builtin.current_buffer_fuzzy_find, { desc = 'Search Current Buffer' })
  --   vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = 'Key Maps' })
  --   vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'Help Pages' })
  --   vim.keymap.set('n', '<leader>sR', builtin.resume, { desc = 'Resume Last Search' })
  --
  --   -- Diagnostics & Symbols
  --   vim.keymap.set('n', '<leader>sd', function() builtin.diagnostics { bufnr = 0 } end, { desc = 'Document Diagnostics' })
  --   vim.keymap.set('n', '<leader>sD', builtin.diagnostics, { desc = 'Workspace Diagnostics' })
  --   vim.keymap.set('n', '<leader>ss', builtin.lsp_document_symbols, { desc = 'Goto Document Symbol' })
  --   vim.keymap.set('n', '<leader>sS', builtin.lsp_dynamic_workspace_symbols, { desc = 'Goto Workspace Symbol' })
  --
  --   -- Git Pickers
  --   vim.keymap.set('n', '<leader>gs', builtin.git_status, { desc = 'Git Status' })
  --   vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = 'Git Commits' })
  --
  --   -- Add Telescope-based LSP pickers when an LSP attaches to a buffer.
  --   -- If you later switch picker plugins, this is where to update these mappings.
  --   vim.api.nvim_create_autocmd('LspAttach', {
  --     group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
  --     callback = function(event)
  --       local buf = event.buf
  --
  --       -- Find references for the word under your cursor.
  --       vim.keymap.set('n', 'grr', builtin.lsp_references, { buffer = buf, desc = '[G]oto [R]eferences' })
  --
  --       -- Jump to the implementation of the word under your cursor.
  --       -- Useful when your language has ways of declaring types without an actual implementation.
  --       vim.keymap.set('n', 'gri', builtin.lsp_implementations, { buffer = buf, desc = '[G]oto [I]mplementation' })
  --
  --       -- Jump to the definition of the word under your cursor.
  --       -- This is where a variable was first declared, or where a function is defined, etc.
  --       -- To jump back, press <C-t>.
  --       vim.keymap.set('n', 'grd', builtin.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })
  --
  --       -- Fuzzy find all the symbols in your current document.
  --       -- Symbols are things like variables, functions, types, etc.
  --       vim.keymap.set('n', 'gO', builtin.lsp_document_symbols, { buffer = buf, desc = 'Open Document Symbols' })
  --
  --       -- Fuzzy find all the symbols in your current workspace.
  --       -- Similar to document symbols, except searches over your entire project.
  --       vim.keymap.set('n', 'gW', builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'Open Workspace Symbols' })
  --
  --       -- Jump to the type of the word under your cursor.
  --       -- Useful when you're not sure what type a variable is and you want to see
  --       -- the definition of its *type*, not where it was *defined*.
  --       vim.keymap.set('n', 'grt', builtin.lsp_type_definitions, { buffer = buf, desc = '[G]oto [T]ype Definition' })
  --     end,
  --   })
  --
  --   -- Override default behavior and theme when searching
  --   vim.keymap.set('n', '<leader>/', function()
  --     -- You can pass additional configuration to Telescope to change the theme, layout, etc.
  --     builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
  --       winblend = 10,
  --       previewer = false,
  --     })
  --   end, { desc = '[/] Fuzzily search in current buffer' })
  --
  --   -- It's also possible to pass additional configuration options.
  --   --  See `:help telescope.builtin.live_grep()` for information about particular keys
  --   vim.keymap.set(
  --     'n',
  --     '<leader>s/',
  --     function()
  --       builtin.live_grep {
  --         grep_open_files = true,
  --         prompt_title = 'Live Grep in Open Files',
  --       }
  --     end,
  --     { desc = '[S]earch [/] in Open Files' }
  --   )
  --
  --   -- Shortcut for searching your Neovim configuration files
  --   vim.keymap.set('n', '<leader>sn', function() builtin.find_files { cwd = vim.fn.stdpath 'config', follow = true } end, { desc = '[S]earch [N]eovim files' })
  -- end

  -- ============================================================
  -- SECTION 6: LSP
  -- LSP keymaps, server configuration, Mason tools installations
  -- ============================================================
  do
    -- [[ LSP Configuration ]]
    -- Brief aside: **What is LSP?**
    --
    -- LSP is an initialism you've probably heard, but might not understand what it is.
    --
    -- LSP stands for Language Server Protocol. It's a protocol that helps editors
    -- and language tooling communicate in a standardized fashion.
    --
    -- In general, you have a "server" which is some tool built to understand a particular
    -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
    -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
    -- processes that communicate with some "client" - in this case, Neovim!
    --
    -- LSP provides Neovim with features like:
    --  - Go to definition
    --  - Find references
    --  - Autocompletion
    --  - Symbol Search
    --  - and more!
    --
    -- Thus, Language Servers are external tools that must be installed separately from
    -- Neovim. This is where `mason` and related plugins come into play.
    --
    -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
    -- and elegantly composed help section, `:help lsp-vs-treesitter`

    -- Useful status updates for LSP.
    vim.pack.add { gh 'j-hui/fidget.nvim' }
    require('fidget').setup {}

    --  This function gets run when an LSP attaches to a particular buffer.
    --    That is to say, every time a new file is opened that is associated with
    --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
    --    function will be executed to configure the current buffer
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        -- NOTE: Remember that Lua is a real programming language, and as such it is possible
        -- to define small helper and utility functions so you don't have to repeat yourself.
        --
        -- In this case, we create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Map "gd" to jump directly to the definition under your cursor
        map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')

        -- Rename the variable under your cursor.
        --  Most Language Servers support renaming across files, etc.
        map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

        -- WARN: This is not Goto Definition, this is Goto Declaration.
        --  For example, in C this would take you to the header.
        map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method('textDocument/documentHighlight', event.buf) then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        -- The following code creates a keymap to toggle inlay hints in your
        -- code, if the language server you are using supports them
        --
        -- This may be unwanted, since they displace some of your code
        if client and client:supports_method('textDocument/inlayHint', event.buf) then
          map('<leader>ih', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, 'Toggle [I]nlay [H]ints')
        end
      end,
    })

    local orig_hover = vim.lsp.buf.hover
    vim.lsp.buf.hover = function(opts)
      opts = opts or {}
      opts.border = opts.border or 'rounded'
      return orig_hover(opts)
    end

    local orig_signature_help = vim.lsp.buf.signature_help
    vim.lsp.buf.signature_help = function(opts)
      opts = opts or {}
      opts.border = opts.border or 'rounded'
      return orig_signature_help(opts)
    end

    -- Enable the following language servers
    --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
    --  See `:help lsp-config` for information about keys and how to configure
    ---@type table<string, vim.lsp.Config>
    local servers = {
      -- clangd = {},
      -- gopls = {},
      -- pyright = {},
      zls = {},
      rust_analyzer = {},
      --
      -- Some languages (like typescript) have entire language plugins that can be useful:
      --    https://github.com/pmizio/typescript-tools.nvim
      --
      -- But for many setups, the LSP (`ts_ls`) will work just fine
      -- ts_ls = {},

      stylua = {}, -- Used to format Lua code

      -- Special Lua Config, as recommended by neovim help docs
      lua_ls = {},
    }

    vim.pack.add {
      gh 'neovim/nvim-lspconfig',
      gh 'mason-org/mason.nvim',
      gh 'mason-org/mason-lspconfig.nvim',
      gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
    }

    -- Automatically install LSPs and related tools to stdpath for Neovim
    require('mason').setup {}

    -- Ensure the servers and tools above are installed
    --
    -- To check the current status of installed tools and/or manually install
    -- other tools, you can run
    --    :Mason
    --
    -- You can press `g?` for help in this menu.
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      -- You can add other tools here that you want Mason to install
    })

    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    for name, server in pairs(servers) do
      vim.lsp.config(name, server)
      vim.lsp.enable(name)
    end
  end

  -- ============================================================
  -- SECTION 7: FORMATTING
  -- conform.nvim setup and keymap
  -- ============================================================
  do
    -- [[ Formatting ]]
    vim.pack.add { gh 'stevearc/conform.nvim' }
    require('conform').setup {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- You can specify filetypes to autoformat on save here:
        local enabled_filetypes = {
          -- lua = true,
          -- python = true,
        }
        if enabled_filetypes[vim.bo[bufnr].filetype] then
          return { timeout_ms = 500 }
        else
          return nil
        end
      end,
      default_format_opts = {
        lsp_format = 'fallback', -- Use external formatters if configured below, otherwise use LSP formatting. Set to `false` to disable LSP formatting entirely.
      },
      -- You can also specify external formatters in here.
      formatters_by_ft = {
        -- rust = { 'rustfmt' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
      },
    }

    vim.keymap.set({ 'n', 'v' }, '<leader>f', function() require('conform').format { async = true } end, { desc = '[F]ormat buffer' })
  end

  -- ============================================================
  -- SECTION 8: AUTOCOMPLETE & SNIPPETS
  -- blink.cmp and luasnip setup
  -- ============================================================
  do
    -- [[ Snippet Engine ]]

    -- NOTE: You can also specify plugin using a version range for its git tag.
    --  See `:help vim.version.range()` for more info
    vim.pack.add { { src = gh 'L3MON4D3/LuaSnip', version = vim.version.range '2.*' } }
    require('luasnip').setup {}

    -- `friendly-snippets` contains a variety of premade snippets.
    --    See the README about individual language/framework/plugin snippets:
    --    https://github.com/rafamadriz/friendly-snippets
    --
    -- vim.pack.add { gh 'rafamadriz/friendly-snippets' }
    -- require('luasnip.loaders.from_vscode').lazy_load()

    -- [[ Autocomplete Engine ]]
    vim.pack.add { { src = gh 'saghen/blink.cmp', version = vim.version.range '1.*' } }
    require('blink.cmp').setup {
      keymap = {
        preset = 'enter',
        -- You can define explicit keys to scroll the documentation here if needed,
        -- though `<C-b>` and `<C-f>` are mapped by default in the 'enter' preset.
      },

      appearance = {
        nerd_font_variant = 'mono',
      },

      completion = {
        -- 1. Add rounded border to the autocomplete suggestions menu
        menu = {
          border = 'rounded',
        },

        -- 2. Configure documentation popup
        documentation = {
          auto_show = true, -- Automatically show documentation next to suggestions
          auto_show_delay_ms = 200, -- Fast 200ms delay for a snappy feel
          window = {
            border = 'rounded', -- Add rounded border to documentation
          },
        },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets' },
      },

      snippets = { preset = 'luasnip' },

      fuzzy = { implementation = 'lua' },

      -- 3. Enable rounded borders for function argument signature help
      signature = {
        enabled = true,
        window = {
          border = 'rounded',
        },
      },
    }
  end

  -- ============================================================
  -- SECTION 9: TREESITTER
  -- Parser installation, syntax highlighting, folds, indentation
  -- ============================================================
  do
    -- [[ Configure Treesitter ]]
    --  Used to highlight, edit, and navigate code
    --
    --  See `:help nvim-treesitter-intro`

    -- NOTE: You can also specify a branch or a specific commit
    vim.pack.add { { src = gh 'nvim-treesitter/nvim-treesitter', version = 'main' } }

    -- Ensure basic parsers are installed
    local parsers = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }
    require('nvim-treesitter').install(parsers)

    ---@param buf integer
    ---@param language string
    local function treesitter_try_attach(buf, language)
      -- Check if a parser exists and load it
      if not vim.treesitter.language.add(language) then return end
      -- Enable syntax highlighting and other treesitter features
      vim.treesitter.start(buf, language)

      -- Enable treesitter based folds
      -- For more info on folds see `:help folds`
      -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      -- vim.wo.foldmethod = 'expr'

      -- Check if treesitter indentation is available for this language, and if so enable it
      -- in case there is no indent query, the indentexpr will fallback to the vim's built in one
      local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil

      -- Enable treesitter based indentation
      if has_indent_query then vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
    end

    local available_parsers = require('nvim-treesitter').get_available()
    vim.api.nvim_create_autocmd('FileType', {
      callback = function(args)
        local buf, filetype = args.buf, args.match

        local language = vim.treesitter.language.get_lang(filetype)
        if not language then return end

        local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

        if vim.tbl_contains(installed_parsers, language) then
          -- Enable the parser if it is already installed
          treesitter_try_attach(buf, language)
        elseif vim.tbl_contains(available_parsers, language) then
          -- If a parser is available in `nvim-treesitter`, auto-install it and enable it after the installation is done
          require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
        else
          -- Try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
          treesitter_try_attach(buf, language)
        end
      end,
    })
  end

  -- ============================================================
  -- SECTION 10: OPTIONAL EXAMPLES / NEXT STEPS
  -- kickstart.plugins.* examples
  -- ============================================================
  do
    -- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
    -- init.lua. If you want these files, they are in the repository, so you can just download them and
    -- place them in the correct locations.

    -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
    --
    --  Here are some example plugins that I've included in the Kickstart repository.
    --  Uncomment any of the lines below to enable them (you will need to restart nvim).
    --
    -- require 'kickstart.plugins.debug'
    require 'kickstart.plugins.indent_line'
    require 'kickstart.plugins.lint'
    require 'kickstart.plugins.autopairs'
    -- require 'kickstart.plugins.neo-tree'
    require 'kickstart.plugins.gitsigns' -- adds gitsigns recommended keymaps

    -- NOTE: You can add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
    --
    --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
    -- require 'custom.plugins'
  end

  -- The line beneath this is called `modeline`. See `:help modeline`
  -- vim: ts=2 sts=2 sw=2 et
end

if vim.fn.argc() > 0 then
  local first_arg = vim.fn.argv(0)
  if first_arg ~= '' and vim.fn.isdirectory(first_arg) == 1 then vim.cmd.cd(first_arg) end
end

-- Automatically change directory (cd) to the project root
-- This ensures Neovim's active working directory, your Toggle Terminal,
-- and shell commands are always running in the correct project folder.
vim.api.nvim_create_autocmd({ 'BufEnter', 'VimEnter' }, {
  callback = function()
    -- Skip special non-directory buffers (like terminal buffers, help, etc.)
    if vim.bo.buftype ~= '' then return end

    -- Search upward for standard root project markers (now including Zig!)
    local root = vim.fs.root(0, {
      '.git',
      'build.zig',
      'build.zig.zon',
      'Cargo.toml',
      'package.json',
      'Makefile',
    })

    if root then vim.cmd.cd(root) end
  end,
})


-- Overriding vim.ui.open to make 'gx' open local file:// links directly inside Neovim
local orig_open = vim.ui.open

---@diagnostic disable-next-line: duplicate-set-field
vim.ui.open = function(path, opt)
  if path:match('^file://') then
    -- Clean up the file path prefix
    local clean_path = path:gsub('^file://', '')
    
    -- Extract the file path and line number if present (e.g. #L488)
    local file, line = clean_path:match('([^#]+)#L(%d+)')
    if not file then
      file = clean_path:match('[^#]+')
    end

    if file then
      -- If we are currently focused inside a floating window, close it first
      local win = vim.api.nvim_get_current_win()
      if vim.api.nvim_win_get_config(win).relative ~= '' then
        vim.cmd 'close'
      end

      -- Open the file directly in Neovim
      vim.cmd('edit ' .. file)
      if line then
        vim.cmd(line) -- Jump to the exact line number
      end

      -- Return a dummy system object to satisfy Neovim's defaults.lua wait() checks
      return {
        wait = function() return { code = 0 } end,
        kill = function() end,
      }
    end
  end

  -- Fall back to default behavior for web links (http://, https://, etc.)
  return orig_open(path, opt)
end
