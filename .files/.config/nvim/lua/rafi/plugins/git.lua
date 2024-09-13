-- Plugins: Git
-- https://github.com/rafi/vim-config

return {

	-----------------------------------------------------------------------------
	-- Git signs written in pure lua
	{
		'lewis6991/gitsigns.nvim',
		event = 'LazyFile',
		-- See: https://github.com/lewis6991/gitsigns.nvim#usage
		-- stylua: ignore
		opts = {
			signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
			numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
			linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
			word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
			current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
			attach_to_untracked = true,
			watch_gitdir = {
				interval = 1000,
				follow_files = true,
			},
			preview_config = {
				border = 'rounded',
			},
			signs = {
				add = { text = '▎' },
				change = { text = '▎' },
				delete = { text = '' },
				topdelete = { text = '' },
				changedelete = { text = '▎' },
				untracked = { text = '▎' },
			},
			signs_staged = {
				add = { text = '▎' },
				change = { text = '▎' },
				delete = { text = '' },
				topdelete = { text = '' },
				changedelete = { text = '▎' },
			},
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				---@return string
				map('n', ']g', function()
					if vim.wo.diff then return ']c' end
					vim.schedule(function() gs.nav_hunk('next') end)
					return '<Ignore>'
				end, { expr = true, desc = 'Next git hunk'  })

				map('n', '[g', function()
					if vim.wo.diff then return '[c' end
					vim.schedule(function() gs.nav_hunk('prev') end)
					return '<Ignore>'
				end, { expr = true, desc = 'Previous git hunk' })

				-- Actions
				--
				map('n', ']h', function()
					if vim.wo.diff then
						vim.cmd.normal({ ']c', bang = true })
					else
						gs.nav_hunk('next')
					end
				end, { desc = 'Next Hunk' })
				map('n', '[h', function()
					if vim.wo.diff then
						vim.cmd.normal({ '[c', bang = true })
					else
						gs.nav_hunk('prev')
					end
				end, { desc = 'Prev Hunk' })
				map('n', ']H', function() gs.nav_hunk('last') end, { desc = 'Last Hunk' })
				map('n', '[H', function() gs.nav_hunk('first') end, { desc = 'First Hunk' })
				map('n', '<leader>hs', gs.stage_hunk, { silent = true, desc = 'Stage hunk' })
				map('n', '<leader>hr', gs.reset_hunk, { silent = true, desc = 'Reset hunk' })
				map('x', '<leader>hs', function() gs.stage_hunk({vim.fn.line('.'), vim.fn.line('v')}) end, { desc = 'Stage hunk' })
				map('x', '<leader>hr', function() gs.reset_hunk({vim.fn.line('.'), vim.fn.line('v')}) end, { desc = 'Reset hunk' })
				map('n', '<leader>hS', gs.stage_buffer, { silent = true, desc = 'Stage buffer' })
				map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'Undo staged hunk' })
				map('n', '<leader>hR', gs.reset_buffer, { desc = 'Reset buffer' })
				map('n', 'gs', gs.preview_hunk, { desc = 'Preview hunk' })
				map('n', '<leader>hp', gs.preview_hunk_inline, { desc = 'Preview hunk inline' })
				map('n', '<leader>hb', function() gs.blame_line({ full=true }) end, { desc = 'Show blame commit' })
				map('n', '<leader>hd', gs.diffthis, { desc = 'Diff against the index' })
				map('n', '<leader>hD', function() gs.diffthis('~') end, { desc = 'Diff against the last commit' })
				map('n', '<leader>hl', function()
					if vim.bo.filetype ~= 'qf' then
						require('gitsigns').setqflist(0, { use_location_list = true })
					end
				end, { desc = 'Send to location list' })

				-- Toggles
				map('n', '<leader>htb', gs.toggle_current_line_blame, { desc = 'Toggle Git line blame' })
				map('n', '<leader>htB', function() gs.blame() end, { desc = 'Blame Buffer' })
				map('n', '<leader>htd', gs.toggle_deleted, { desc = 'Toggle Git deleted' })
				map('n', '<leader>htw', gs.toggle_word_diff, { desc = 'Toggle Git word diff' })
				map('n', '<leader>htl', gs.toggle_linehl, { desc = 'Toggle Git line highlight' })
				map('n', '<leader>htn', gs.toggle_numhl, { desc = 'Toggle Git number highlight' })
				map('n', '<leader>hts', gs.toggle_signs, { desc = 'Toggle Git signs' })

				-- Text object
				map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { silent = true, desc = 'Select hunk'})

			end,
		},
	},

}
