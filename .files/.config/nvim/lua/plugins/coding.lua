-- Plugins: Coding (minimal version)
-- https://github.com/rafi/vim-config

return {

	-----------------------------------------------------------------------------
	-- Code completion
	-- NOTE: This extends
	-- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/extras/coding/blink.lua
	{
		'blink.cmp',
		optional = true,
		opts = function(_, opts)
			-- Add more candidate navigation keymaps.
			opts.keymap['<C-j>'] = { 'select_next', 'fallback' }
			opts.keymap['<C-k>'] = { 'select_prev', 'fallback' }
			opts.keymap['<C-d>'] = { 'select_next', 'fallback' }
			opts.keymap['<C-u>'] = { 'select_prev', 'fallback' }

			opts.fuzzy = { implementation = 'lua' }

			-- Remove lazydev from blink's sources.
			opts.sources.per_filetype.lua = nil
			opts.sources.providers['lazydev'] = nil
		end,
	},

	-----------------------------------------------------------------------------
	-- Lightweight yet powerful formatter plugin
	-- NOTE: This extends
	-- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/formatting.lua
	{ 'conform.nvim', enabled = false },

	-----------------------------------------------------------------------------
	-- Asynchronous linter plugin
	-- NOTE: This extends
	-- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/linting.lua
	{ 'nvim-lint', enabled = false },

	-----------------------------------------------------------------------------
	-- Extend and create a/i textobjects
	{
		'mini.ai',
		opts = function(_, opts)
			return vim.tbl_extend('force', opts or {}, {
				use_nvim_treesitter = false,
				custom_textobjects = { o = nil, f = nil, c = nil },
			})
		end,
	},

	-----------------------------------------------------------------------------
	-- LuaLS support for auto-completion and type checking while editing your
	-- Neovim configuration.
	{ "folke/lazydev.nvim", enabled = false },

	-----------------------------------------------------------------------------
	-- Fast and feature-rich surround actions
	{
		'mini.surround',
		optional = true,
		opts = {
			mappings = {
				add = 'sa', -- Add surrounding in Normal and Visual modes
				delete = 'ds', -- Delete surrounding
				find = 'gzf', -- Find surrounding (to the right)
				find_left = 'gzF', -- Find surrounding (to the left)
				highlight = 'gzh', -- Highlight surrounding
				replace = 'cs', -- Replace surrounding
				update_n_lines = 'gzn', -- Update `n_lines`
			},
		},
	},
}
