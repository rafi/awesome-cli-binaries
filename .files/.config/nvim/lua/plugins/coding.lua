-- Plugins: Coding (minimal version)
-- https://github.com/rafi/vim-config (minimal version)

local has_git = vim.fn.executable('git') == 1

return {

	-----------------------------------------------------------------------------
	-- Code completion
	-- NOTE: This extends
	-- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/extras/coding/blink.lua
	{
		'blink.cmp',
		cond = has_git,
		opts = function(_, opts)
			-- Add more candidate navigation keymaps.
			opts.keymap['<C-j>'] = { 'select_next', 'fallback' }
			opts.keymap['<C-k>'] = { 'select_prev', 'fallback' }
			opts.keymap['<C-d>'] = { 'select_next', 'fallback' }
			opts.keymap['<C-u>'] = { 'select_prev', 'fallback' }

			-- Remove lazydev from sources.
			opts.sources.default = vim.tbl_filter(function(source)
				return source ~= 'lazydev'
			end, opts.sources.default)
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
	-- Fast and feature-rich surround actions
	{ import = 'lazyvim.plugins.extras.coding.mini-surround' },
	{
		'mini.surround',
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
