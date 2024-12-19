-- Rafi's lazy.nvim initialization
-- https://github.com/rafi/vim-config (minimal version)

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
	print('Installing ' .. lazypath .. '…')
	vim.fn.system({
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable',
		lazypath
	})
end
vim.opt.rtp:prepend(lazypath)

local has_git = vim.fn.executable('git') == 1

-- Start lazy.nvim plugin manager.
require('lazy').setup({
	spec = {
		{
			'LazyVim/LazyVim',
			version = '*',
			priority = 10000,
			lazy = false,
			cond = true,
			import = 'lazyvim.plugins',
			opts = {
				defaults = { keymaps = false },
				news = { lazyvim = false },
			},
		},
		{ import = 'plugins' },
	},
	defaults = { lazy = true, version = false },
	install = { missing = has_git, colorscheme = {} },
	checker = { enabled = has_git, notify = false },
	change_detection = { notify = false },
	ui = {
		size = { width = 0.8, height = 0.85 },
		border = 'rounded',
		wrap = false,
	},
	diff = { cmd = 'terminal_git' },
	performance = {
		rtp = {
			disabled_plugins = {
				'gzip',
				'vimballPlugin',
				'matchit',
				'matchparen',
				'2html_plugin',
				'tarPlugin',
				'netrwPlugin',
				'tutor',
				'zipPlugin',
			},
		},
	},
})

-- Enjoy!
