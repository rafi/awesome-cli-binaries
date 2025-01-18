-- Plugins: Editor (minimal version)
-- https://github.com/rafi/vim-config

local has_git = vim.fn.executable('git') == 1

return {

	{ 'mason-lspconfig.nvim', enabled = false },
	{ 'mason.nvim', enabled = false },
	{ 'nvim-lspconfig', enabled = false },
	{ 'nvim-treesitter', enabled = false },
	{ 'nvim-treesitter-textobjects', enabled = false },
	{ 'lazydev.nvim', enabled = false },

	-----------------------------------------------------------------------------
	-- Automatic indentation style detection
	{ 'nmac427/guess-indent.nvim', lazy = false, priority = 50, opts = {} },

	-- An alternative sudo for Vim and Neovim
	{ 'lambdalisue/suda.vim', event = 'BufRead' },

	-----------------------------------------------------------------------------
	-- FZF picker
	-- NOTE: This extends
	-- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/extras/editor/fzf.lua
	{
		'fzf-lua',
		optional = true,
		opts = {
			defaults = { git_icons = has_git },
		},
	},

	-----------------------------------------------------------------------------
	-- Simple lua plugin for automated session management
	-- NOTE: This extends
	-- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/util.lua
	{
		'persistence.nvim',
		-- stylua: ignore
		keys = {
			{ '<localleader>s', "<cmd>lua require'persistence'.select()<CR>", desc = 'Sessions' },
		},
	},

	-----------------------------------------------------------------------------
	-- Git signs written in pure lua
	-- See: https://github.com/lewis6991/gitsigns.nvim#usage
	-- NOTE: This extends
	-- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/editor.lua
	{ 'gitsigns.nvim', enabled = has_git },

	-----------------------------------------------------------------------------
	-- Search labels, enhanced character motions
	-- NOTE: This extends
	-- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/editor.lua
	{ 'flash.nvim', enabled = false },

	-----------------------------------------------------------------------------
	-- Create key bindings that stick
	-- NOTE: This extends
	-- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/editor.lua
	{
		'which-key.nvim',
		keys = {
			-- Replace <leader>? with <leader>bk
			{ '<leader>?', false },
			{
				'<leader>bk',
				function()
					require('which-key').show({ global = false })
				end,
				desc = 'Buffer Keymaps (which-key)',
			},
		},
		-- stylua: ignore
		opts = {
			icons = {
				breadcrumb = '»',
				separator = '󰁔  ', -- ➜
			},
			delay = function(ctx)
				return ctx.plugin and 0 or 400
			end,
			spec = {
				{
					{ 'gs', group = nil },
					{ 'gz', group = 'surround', icon = { icon = '󱞹 ', color = 'cyan' } },
					{ ';d', group = 'lsp' },
					{ ';',  group = 'picker' },
					{ '<leader>ci', group = 'info' },
					{ '<leader>ght', group = 'toggle' },
					{ '<leader>m',  group = 'tools', icon = { icon = '󱁤 ', color = 'blue' } },
					{ '<leader>md', group = 'diff', icon = { icon = ' ', color = 'green' } },
					{ '<leader>w', group = nil },
				},
			},
		},
	},

	-----------------------------------------------------------------------------
	-- Pretty lists to help you solve all code diagnostics
	-- NOTE: This extends
	-- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/editor.lua
	{ 'trouble.nvim', enabled = false },

	-----------------------------------------------------------------------------
	-- Highlight, list and search todo comments in your projects
	-- NOTE: This extends
	-- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/editor.lua
	{ 'todo-comments.nvim', enabled = false },

	-----------------------------------------------------------------------------
	-- Ultimate undo history visualizer
	{
		'mbbill/undotree',
		cmd = 'UndotreeToggle',
		keys = {
			{ '<leader>gu', '<cmd>UndotreeToggle<CR>', desc = 'Undo Tree' },
		},
	},
}
