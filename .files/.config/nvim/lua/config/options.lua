-- Rafi's Neovim options
-- https://github.com/rafi/vim-config (minimal version)

-- Keyboard leaders
vim.g.mapleader = ' '
vim.g.maplocalleader = ';'

-- Enable elite-mode (hjkl mode. arrow-keys resize window)
vim.g.elite_mode = false

-- LazyVim
vim.g.autoformat = false
vim.g.snacks_animate = false
vim.g.ai_cmp = false
vim.g.trouble_lualine = false

-- General
-- ===
-- stylua: ignore start

local opt = vim.opt

-- Only set clipboard if not in SSH, to make sure the OSC 52
-- integration works automatically. Requires Neovim >= 0.10.0
opt.title = false
opt.ruler = true
opt.mouse = ''
opt.spelloptions:append('camel')
if not vim.g.vscode then
	opt.timeoutlen = 500  -- Time out on mappings
	opt.ttimeoutlen = 10  -- Time out on key codes
end

if vim.fn.has('nvim-0.11') == 1 then
	opt.tabclose:append({'uselast'})
end

opt.diffopt:append({ 'indent-heuristic', 'algorithm:patience' })

opt.textwidth = 80             -- Text width maximum chars before wrapping

opt.writebackup = false

-- If sudo, disable vim swap/backup/undo/shada writing
local USER = vim.env.USER or ''
local SUDO_USER = vim.env.SUDO_USER or ''
if
	SUDO_USER ~= '' and USER ~= SUDO_USER
	and vim.env.HOME ~= vim.fn.expand('~' .. USER, true)
	and vim.env.HOME == vim.fn.expand('~' .. SUDO_USER, true)
then
	vim.opt_global.modeline = false
	vim.opt_global.undofile = false
	vim.opt_global.swapfile = false
	vim.opt_global.backup = false
	vim.opt_global.writebackup = false
	vim.opt_global.shadafile = 'NONE'
end

if vim.env.SSH_TTY then
	vim.g.clipboard = {
		name = 'OSC 52',
		copy = {
			['+'] = require('vim.ui.clipboard.osc52').copy('+'),
			['*'] = require('vim.ui.clipboard.osc52').copy('*'),
		},
		paste = {
			['+'] = require('vim.ui.clipboard.osc52').paste('+'),
			['*'] = require('vim.ui.clipboard.osc52').paste('*'),
		},
	}
end

-- Formatting
-- ===

opt.breakindent = true

opt.formatoptions = opt.formatoptions
	- 'a' -- Auto formatting is BAD.
	- 't' -- Don't auto format my code. I got linters for that.
	+ 'c' -- In general, I like it when comments respect textwidth
	+ 'q' -- Allow formatting comments w/ gq
	- 'o' -- O and o, don't continue comments
	+ 'r' -- But do continue when pressing enter.
	+ 'n' -- Indent past the formatlistpat, not underneath it.
	+ 'j' -- Auto-remove comments if possible.
	- '2' -- I'm not in gradeschool anymore

-- Editor UI
-- ===

opt.shortmess:append({ W = true, I = true, c = true })  --  (default "ltToOCF")
opt.showcmd = false         -- Don't show command in status line
opt.number = false          -- Disable line numbers
opt.relativenumber = false
opt.numberwidth = 2         -- Minimum number of columns to use for the line number
opt.cmdheight = 0
opt.colorcolumn = '+0'      -- Align text at 'textwidth'
opt.showtabline = 2         -- Always show the tabs line

-- opt.helpheight = 0        -- Disable help window resizing
-- opt.winwidth = 30         -- Minimum width for active window
-- opt.winminwidth = 1       -- Minimum width for inactive windows
-- opt.winheight = 1         -- Minimum height for active window
-- opt.winminheight = 1      -- Minimum height for inactive window

opt.showbreak = '⤷  ' -- ↪	⤷
opt.listchars = {
	tab = '  ',
	extends = '⟫',
	precedes = '⟪',
	conceal = '',
	nbsp = '␣',
	trail = '·'
}
opt.fillchars = {
	foldopen = '', -- 󰅀 
	foldclose = '', -- 󰅂 
	fold = ' ', -- ⸱
	foldsep = ' ',
	diff = '╱',
	eob = ' ',
	horiz = '━',
	horizup = '┻',
	horizdown = '┳',
	vert = '┃',
	vertleft = '┫',
	vertright = '┣',
	verthoriz = '╋',
}

-- Misc
-- ===

-- Disable python/perl/ruby/node providers
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

-- Fix markdown indentation settings
vim.g.yaml_indent_multiline_scalar = 1

vim.g.no_gitrebase_maps = 1 -- See share/nvim/runtime/ftplugin/gitrebase.vim
vim.g.no_man_maps = 1       -- See share/nvim/runtime/ftplugin/man.vim

-- Filetype detection
-- ===

vim.filetype.add({
	filename = {
		Brewfile = 'ruby',
		justfile = 'just',
		Justfile = 'just',
		['.buckconfig'] = 'toml',
		['.flowconfig'] = 'ini',
		['.jsbeautifyrc'] = 'json',
		['.jscsrc'] = 'json',
		['.watchmanconfig'] = 'json',
		['helmfile.yaml'] = 'yaml',
		['todo.txt'] = 'todotxt',
		['yarn.lock'] = 'yaml',
	},
	pattern = {
		['%.config/git/users/.*'] = 'gitconfig',
		['%.kube/config'] = 'yaml',
		['.*%.js%.map'] = 'json',
		['.*%.postman_collection'] = 'json',
		['Jenkinsfile.*'] = 'groovy',
	},
})

-- vim: set ts=2 sw=0 tw=80 noet :
