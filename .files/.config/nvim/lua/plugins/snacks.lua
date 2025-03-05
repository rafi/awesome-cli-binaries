return {

	-- Snacks picker
	{
		'folke/snacks.nvim',
		keys = function(_, keys)
			if LazyVim.pick.picker.name ~= 'snacks' then
				return
			end
			-- stylua: ignore
			local mappings = {
				{ '<leader><localleader>', function() Snacks.picker() end, mode = { 'n', 'x' }, desc = 'Pickers' },
				{ '<localleader>u', function() Snacks.picker.spelling() end, mode = { 'n', 'x' }, desc = 'Spellcheck' },
				{ '<leader>gF', function() Snacks.picker.files({ pattern = vim.fn.expand('<cword>') }) end, desc = 'Find File' },
				{
					'<localleader>z',
					mode = { 'n', 'x' },
					desc = 'Zoxide',
					function()
						Snacks.picker.zoxide({
							confirm = function(picker)
								picker:close()
								local item = picker:current()
								if item and item.file then
									vim.cmd.tcd(item.file)
								end
							end,
						})
					end,
				},
			}
			return vim.list_extend(mappings, keys)
		end,
		opts = function(_, opts)
			if LazyVim.pick.picker.name ~= 'snacks' then
				return
			end
			return vim.tbl_deep_extend('force', opts or {}, {
				picker = {
					sources = {
						files = {
							hidden = true,
						},
						grep = {
							hidden = true,
						},
					},
					win = {
						input = {
							keys = {
								['jj'] = { '<esc>', expr = true, mode = 'i' },
								['s'] = false,
								['ss'] = 'flash',
								['sv'] = 'edit_split',
								['sg'] = 'edit_vsplit',
								['st'] = 'edit_tab',
								['.'] = 'toggle_hidden',
								[','] = 'toggle_ignored',
								['e'] = 'qflist',
								['E'] = 'loclist',
								['K'] = 'select_and_prev',
								['J'] = 'select_and_next',
								['*'] = 'select_all',
								['<c-l>'] = { 'preview_scroll_right', mode = { 'i', 'n' } },
								['<c-h>'] = { 'preview_scroll_left', mode = { 'i', 'n' } },
							},
						},
						list = {
							keys = {
								['<c-l>'] = 'preview_scroll_right',
								['<c-h>'] = 'preview_scroll_left',
							},
						},
						preview = {
							keys = {
								['<c-h>'] = 'focus_input',
								['<c-l>'] = 'cycle_win',
							},
						},
					},
				},
			})
		end,
	},

	-- Snacks explorer
	{
		'folke/snacks.nvim',
		keys = function(_, keys)
			if not LazyVim.has_extra('editor.snacks_explorer') then
				return
			end
			-- stylua: ignore
			local mappings = {
				{ '<localleader>e', '<leader>fe', desc = 'Explorer Tree (Root Dir)', remap = true },
				{ '<localleader>E', '<leader>fE', desc = 'Explorer Tree (cwd)', remap = true },
				{ '<localleader>a', function() Snacks.explorer.reveal({ cwd = LazyVim.root() }) end, desc = 'Reveal in Explorer' },
				{ '<localleader>A', function() Snacks.explorer.reveal() end, desc = 'Reveal in Explorer (cwd)' },
			}
			return vim.list_extend(mappings, keys)
		end,
		opts = function(_, opts)
			if not LazyVim.has_extra('editor.snacks_explorer') then
				return
			end
			return vim.tbl_deep_extend('force', opts or {}, {
				image = {},
				picker = {
					sources = {
						explorer = {
							hidden = true,
							jump = { close = true },
							win = {
								list = {
									keys = {
										['<esc>'] = false,
										['<c-h>'] = false,
										['<c-l>'] = false,
										['sv'] = 'edit_split',
										['sg'] = 'edit_vsplit',
										['st'] = 'edit_tab',
									},
								},
							},
						},
					},
				},
			})
		end,
	},
}
