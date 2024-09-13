-- Plugins: UI
-- https://github.com/rafi/vim-config

return {

	-----------------------------------------------------------------------------
	-- Icon provider
	{
		'echasnovski/mini.icons',
		lazy = true,
		opts = {
			file = {
				['.keep'] = { glyph = '󰊢', hl = 'MiniIconsGrey' },
				['devcontainer.json'] = { glyph = '', hl = 'MiniIconsAzure' },
			},
			filetype = {
				dotenv = { glyph = '', hl = 'MiniIconsYellow' },
			},
		},
		init = function()
			---@diagnostic disable-next-line: duplicate-set-field
			package.preload['nvim-web-devicons'] = function()
				require('mini.icons').mock_nvim_web_devicons()
				return package.loaded['nvim-web-devicons']
			end
		end,
	},

	-----------------------------------------------------------------------------
	-- Fancy notification manager
	{
		'rcarriga/nvim-notify',
		priority = 9000,
		keys = {
			{
				'<leader>un',
				function()
					require('notify').dismiss({ silent = true, pending = true })
				end,
				desc = 'Dismiss All Notifications',
			},
		},
		opts = {
			stages = 'static',
			timeout = 3000,
			max_height = function()
				return math.floor(vim.o.lines * 0.75)
			end,
			max_width = function()
				return math.floor(vim.o.columns * 0.75)
			end,
			on_open = function(win)
				vim.api.nvim_win_set_config(win, { zindex = 100 })
			end,
		},
		init = function()
			-- When noice is not enabled, install notify on VeryLazy
			if not LazyVim.has('noice.nvim') then
				LazyVim.on_very_lazy(function()
					vim.notify = require('notify')
				end)
			end
		end,
	},

	-----------------------------------------------------------------------------
	-- Snazzy tab/bufferline
	{
		'akinsho/bufferline.nvim',
		event = 'VeryLazy',
		enabled = not vim.g.started_by_firenvim,
		-- stylua: ignore
		keys = {
			{ '<leader>bp', '<Cmd>BufferLineTogglePin<CR>', desc = 'Toggle Pin' },
			{ '<leader>bP', '<Cmd>BufferLineGroupClose ungrouped<CR>', desc = 'Delete Non-Pinned Buffers' },
			{ '<leader>bo', '<Cmd>BufferLineCloseOthers<CR>', desc = 'Delete Other Buffers' },
			{ '<leader>br', '<Cmd>BufferLineCloseRight<CR>', desc = 'Delete Buffers to the Right' },
			{ '<leader>bl', '<Cmd>BufferLineCloseLeft<CR>', desc = 'Delete Buffers to the Left' },
			{ '<leader>tp', '<Cmd>BufferLinePick<CR>', desc = 'Tab Pick' },
			{ '[B', '<cmd>BufferLineMovePrev<cr>', desc = 'Move buffer prev' },
			{ ']B', '<cmd>BufferLineMoveNext<cr>', desc = 'Move buffer next' },
		},
		opts = {
			options = {
				mode = 'tabs',
				separator_style = 'slant',
				show_close_icon = false,
				show_buffer_close_icons = false,
				diagnostics = 'nvim_lsp',
				-- show_tab_indicators = true,
				-- enforce_regular_tabs = true,
				always_show_bufferline = true,
				-- indicator = {
				-- 	style = 'underline',
				-- },
				close_command = function(n)
					LazyVim.ui.bufremove(n)
				end,
				right_mouse_command = function(n)
					LazyVim.ui.bufremove(n)
				end,
				diagnostics_indicator = function(_, _, diag)
					local icons = LazyVim.config.icons.diagnostics
					local ret = (diag.error and icons.Error .. diag.error .. ' ' or '')
						.. (diag.warning and icons.Warn .. diag.warning or '')
					return vim.trim(ret)
				end,
				custom_areas = {
					right = function()
						local result = {}
						local root = LazyVim.root()
						table.insert(result, {
							text = '%#BufferLineTab# ' .. vim.fn.fnamemodify(root, ':t'),
						})

						-- Session indicator
						if vim.v.this_session ~= '' then
							table.insert(result, { text = '%#BufferLineTab#  ' })
						end
						return result
					end,
				},
				offsets = {
					{
						filetype = 'neo-tree',
						text = 'Neo-tree',
						highlight = 'Directory',
						text_align = 'center',
					},
				},
				---@param opts bufferline.IconFetcherOpts
				get_element_icon = function(opts)
					return LazyVim.config.icons.ft[opts.filetype]
				end,
			},
		},
		config = function(_, opts)
			require('bufferline').setup(opts)
			-- Fix bufferline when restoring a session
			vim.api.nvim_create_autocmd({ 'BufAdd', 'BufDelete' }, {
				callback = function()
					vim.schedule(function()
						---@diagnostic disable-next-line: undefined-global
						pcall(nvim_bufferline)
					end)
				end,
			})
		end,
	},

	-----------------------------------------------------------------------------
	-- Visually display indent levels
	{
		'lukas-reineke/indent-blankline.nvim',
		main = 'ibl',
		event = 'LazyFile',
		opts = function()
			LazyVim.toggle.map('<leader>ue', {
				name = 'Indention Guides',
				get = function()
					return require('ibl.config').get_config(0).enabled
				end,
				set = function(state)
					require('ibl').setup_buffer(0, { enabled = state })
				end,
			})

			return {
				indent = {
					-- See more characters at :h ibl.config.indent.char
					char = '│', -- ▏│
					tab_char = '│',
				},
				scope = { show_start = false, show_end = false },
				exclude = {
					filetypes = {
						'alpha',
						'checkhealth',
						'dashboard',
						'git',
						'gitcommit',
						'help',
						'lazy',
						'lazyterm',
						'lspinfo',
						'man',
						'mason',
						'neo-tree',
						'notify',
						'Outline',
						'TelescopePrompt',
						'TelescopeResults',
						'terminal',
						'toggleterm',
						'Trouble',
					},
				},
			}
		end,
	},

	-----------------------------------------------------------------------------
	-- Create key bindings that stick
	{
		'folke/which-key.nvim',
		event = 'VeryLazy',
		cmd = 'WhichKey',
		keys = {
			{
				'<leader>bk',
				function()
					require('which-key').show({ global = false })
				end,
				desc = 'Buffer Keymaps (which-key)',
			},
			{
				'<C-w><Space>',
				function()
					require('which-key').show({ keys = '<c-w>', loop = true })
				end,
				desc = 'Window Hydra Mode (which-key)',
			},
		},
		opts_extend = { 'spec' },
		-- stylua: ignore
		opts = {
			defaults = {},
			icons = {
				breadcrumb = '»',
				separator = '󰁔  ', -- ➜
			},
			delay = function(ctx)
				return ctx.plugin and 0 or 400
			end,
			spec = {
				{
					mode = { 'n', 'v' },
					{ '[', group = 'prev' },
					{ ']', group = 'next' },
					{ 'g', group = 'goto' },
					{ 'gz', group = 'surround' },
					{ 'z', group = 'fold' },
					{ ';', group = '+telescope' },
					{ ';d', group = '+lsp' },
					{
						'<leader>b',
						group = 'buffer',
						expand = function()
							return require('which-key.extras').expand.buf()
						end,
					},
					{ '<leader>c', group = 'code' },
					{ '<leader>ch', group = 'calls' },
					{ '<leader>f', group = 'file/find' },
					{ '<leader>fw', group = 'workspace' },
					{ '<leader>g', group = 'git' },
					{ '<leader>h', group = 'hunks', icon = { icon = ' ', color = 'red' } },
					{ '<leader>ht', group = 'toggle' },
					{ '<leader>m', group = 'tools' },
					{ '<leader>md', group = 'diff' },
					{ '<leader>q', group = 'quit/session' },
					{ '<leader>s', group = 'search' },
					{ '<leader>sn', group = 'noice' },
					{ '<leader>t', group = 'toggle/tools' },
					{ '<leader>u', group = 'ui', icon = { icon = '󰙵 ', color = 'cyan' } },
					{ '<leader>x', group = 'diagnostics/quickfix', icon = { icon = '󱖫 ', color = 'green' } },
					{ '<leader>z', group = 'notes' },

					-- Better descriptions
					{ 'gx', desc = 'Open with system app' },
				},
			},
		},
		config = function(_, opts)
			local wk = require('which-key')
			wk.setup(opts)
			if not vim.tbl_isempty(opts.defaults) then
				LazyVim.warn(
					'which-key: opts.defaults is deprecated. Please use opts.spec instead.'
				)
				wk.register(opts.defaults)
			end
		end,
	},

	-----------------------------------------------------------------------------
	-- Better quickfix window
	{
		'stevearc/quicker.nvim',
		ft = 'qf',
		event = 'QuickFixCmdPost',
		---@module "quicker"
		---@type quicker.SetupOptions
		opts = {
			edit = {
				enabled = false,
				autosave = false,
			},
			highlight = {
				lsp = false,
				load_buffers = false,
			},
			-- stylua: ignore
			keys = {
				{ '>', function() require('quicker').expand({ before = 2, after = 2, add_to_existing = true }) end, desc = 'Expand quickfix context' },
				{ '<', function() require('quicker').collapse() end, desc = 'Collapse quickfix context' },
			},
		},
	},
}
