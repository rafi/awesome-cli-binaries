-- Plugins
-- https://github.com/rafi/vim-config (minimal version)

local tree_width = 30

local function toggle_tree_width()
	local max = tree_width * 2
	local cur_width = vim.fn.winwidth(0)
	local half = math.floor((tree_width + (max - tree_width) / 2) + 0.4)
	local new_width = tree_width
	if cur_width == tree_width then
		new_width = half
	elseif cur_width == half then
		new_width = max
	else
		new_width = tree_width
	end
	vim.cmd(new_width .. ' wincmd |')
end

local function get_tree_current_directory(state)
	local node = state.tree:get_node()
	if node.type ~= 'directory' or not node:is_expanded() then
		node = state.tree:get_node(node:get_parent_id())
	end
	return node.path
end

return {

	{ 'nvim-treesitter', enabled = false },
	{ 'nvim-treesitter-textobjects', enabled = false },
	{ 'nvim-ts-autotag', enabled = false },
	{ 'todo-comments.nvim', enabled = false },
	{ 'trouble.nvim', enabled = false },
	{ 'lazydev.nvim', enabled = false },

	-----------------------------------------------------------------------------
	-- Automatic indentation style detection
	{ 'nmac427/guess-indent.nvim', lazy = false, priority = 50, opts = {} },

	-----------------------------------------------------------------------------
	-- An alternative sudo for Vim and Neovim
	{ 'lambdalisue/suda.vim', event = 'BufRead' },

	-----------------------------------------------------------------------------
	-- Seamless navigation between tmux panes and vim splits
	{
		'christoomey/vim-tmux-navigator',
		lazy = false,
		cond = vim.uv.os_uname().sysname ~= 'Windows_NT',
		-- stylua: ignore
		keys = {
			{ '<C-h>', '<cmd>TmuxNavigateLeft<CR>', mode = { 'n', 't' }, silent = true, desc = 'Go to Left Window' },
			{ '<C-j>', '<cmd>TmuxNavigateDown<CR>', mode = { 'n', 't' }, silent = true, desc = 'Go to Lower Window' },
			{ '<C-k>', '<cmd>TmuxNavigateUp<CR>', mode = { 'n', 't' }, silent = true, desc = 'Go to Upper Window' },
			{ '<C-l>', '<cmd>TmuxNavigateRight<CR>', mode = { 'n', 't' }, silent = true, desc = 'Go to Right Window' },
		},
		init = function()
			vim.g.tmux_navigator_no_mappings = true
		end,
	},

	-----------------------------------------------------------------------------
	-- Ultimate undo history visualizer
	{
		'mbbill/undotree',
		cmd = 'UndotreeToggle',
		keys = {
			{ '<Leader>gu', '<cmd>UndotreeToggle<CR>', desc = 'Undo Tree' },
		},
	},

	-----------------------------------------------------------------------------
	-- Perform diffs on blocks of code
	{
		'AndrewRadev/linediff.vim',
		cmd = { 'Linediff', 'LinediffAdd' },
		keys = {
			{ '<Leader>mdf', ':Linediff<CR>', mode = 'x', desc = 'Line diff' },
			{ '<Leader>mda', ':LinediffAdd<CR>', mode = 'x', desc = 'Line diff add' },
			{ '<Leader>mds', '<cmd>LinediffShow<CR>', desc = 'Line diff show' },
			{ '<Leader>mdr', '<cmd>LinediffReset<CR>', desc = 'Line diff reset' },
		},
	},

	-----------------------------------------------------------------------------
	{
		'blink.cmp',
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
	-- Git signs written in pure lua
	{
		'gitsigns.nvim',
		opts = {
			preview_config = {
				border = 'rounded',
			},
		},
	},

	-----------------------------------------------------------------------------
	-- Search labels, enhanced character motions
	{
		'flash.nvim',
		---@type Flash.Config
		opts = {
			modes = {
				search = {
					enabled = false,
				},
			},
		},
		-- stylua: ignore
		keys = {
			{ 's', mode = { 'n', 'x', 'o' }, '<Nop>' },
			{ 'ss', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end, desc = 'Flash' },
		},
	},

	-----------------------------------------------------------------------------
	-- Snazzy tab/bufferline
	{
		'bufferline.nvim',
		opts = {
			options = {
				mode = 'tabs',
				separator_style = 'slant',
				show_close_icon = false,
				show_buffer_close_icons = false,
				diagnostics = 'nvim_lsp',
				always_show_bufferline = true,
				close_command = function(n) Snacks.bufdelete(n) end,
				right_mouse_command = function(n) Snacks.bufdelete(n) end,
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
				get_element_icon = function(opts)
					return LazyVim.config.icons.ft[opts.filetype]
				end,
			},
		},
	},

	-----------------------------------------------------------------------------
	-- Replaces the UI for messages, cmdline and the popupmenu
	{
		'noice.nvim',
		-- stylua: ignore
		keys = {
			{ '<S-Enter>', function() require('noice').redirect(tostring(vim.fn.getcmdline())) end, mode = 'c', desc = 'Redirect Cmdline' },
		},
		---@type NoiceConfig
		opts = {
			messages = { view_search = false },
			presets = { lsp_doc_border = true },
			routes = {
				-- See :h ui-messages
				{
					filter = {
						event = 'msg_show',
						any = {
							{ find = '%d+L, %d+B' },
							{ find = '^%d+ changes?; after #%d+' },
							{ find = '^%d+ changes?; before #%d+' },
							{ find = '^Hunk %d+ of %d+$' },
							{ find = '^%d+ fewer lines;?' },
							{ find = '^%d+ more lines?;?' },
							{ find = '^%d+ line less;?' },
							{ find = '^Already at newest change' },
							{ kind = 'wmsg' },
							{ kind = 'emsg', find = 'E486' },
							{ kind = 'quickfix' },
						},
					},
					view = 'mini',
				},
				{
					filter = {
						event = 'msg_show',
						any = {
							{ find = '^%d+ lines .ed %d+ times?$' },
							{ find = '^%d+ lines yanked$' },
							{ kind = 'emsg', find = 'E490' },
							{ kind = 'search_count' },
						},
					},
					opts = { skip = true },
				},
			},
		},
	},

	-----------------------------------------------------------------------------
	{
		'snacks.nvim',
		opts = {
			dashboard = { enabled = false },
			scroll = { enabled = false },
			zen = {
				toggles = { git_signs = true },
				zoom = {
					show = { tabline = false },
					win = { backdrop = true },
				},
			},
		},
		-- stylua: ignore
		keys = {
			{ '<leader>.',  function() Snacks.scratch() end, desc = 'Toggle Scratch Buffer' },
			{ '<leader>S',  function() Snacks.scratch.select() end, desc = 'Select Scratch Buffer' },
			{ '<leader>dps', function() Snacks.profiler.scratch() end, desc = 'Profiler Scratch Buffer' },
			{
				'<leader>N',
				desc = 'Neovim News',
				function()
					---@diagnostic disable-next-line: missing-fields
					Snacks.win({
						file = vim.api.nvim_get_runtime_file('doc/news.txt', false)[1],
						width = 0.6,
						height = 0.6,
						wo = {
							spell = false,
							wrap = false,
							signcolumn = 'yes',
							statuscolumn = ' ',
							conceallevel = 3,
						},
					})
				end,
			}
		},
	},

	-----------------------------------------------------------------------------
	-- Create key bindings that stick
	{
		'which-key.nvim',
		-- stylua: ignore
		opts = {
			spec = {
				{
					mode = { 'n', 'v' },
					{ 's', group = 'screen' },
					{ 'gs', group = nil },
					{ 'gz', group = 'surround' },
					{ ';', group = 'telescope' },
					{ '<leader>h', group = 'hunks' },
					{ '<leader>ht', group = 'toggle' },
					{ '<leader>m', group = 'tools' },
					{ '<leader>md', group = 'diff' },
					{ '<leader>sn', group = 'noice' },
				},
			},
		},
	},

	{
		-----------------------------------------------------------------------------
		-- File explorer written in Lua
		'neo-tree.nvim',
		branch = 'v3.x',
		-- stylua: ignore
		keys = {
			{ '<LocalLeader>e', '<leader>fe', desc = 'Explorer NeoTree (Root Dir)', remap = true },
			{ '<LocalLeader>E', '<leader>fE', desc = 'Explorer NeoTree (cwd)', remap = true },
			{
				'<LocalLeader>a',
				function()
					require('neo-tree.command').execute({
						reveal = true,
						dir = LazyVim.root()
					})
				end,
				desc = 'Explorer NeoTree Reveal',
			},
		},
		opts = {
			close_if_last_window = true,
			popup_border_style = 'rounded',
			sort_case_insensitive = true,

			event_handlers = {
				-- Close neo-tree when opening a file.
				{
					event = 'file_opened',
					handler = function()
						require('neo-tree').close_all()
					end,
				},
			},

			default_component_configs = {
				icon = {
					folder_empty = '',
					folder_empty_open = '',
					default = '',
				},
				modified = {
					symbol = '•',
				},
				name = {
					trailing_slash = true,
					highlight_opened_files = true,
					use_git_status_colors = false,
				},
				git_status = {
					symbols = {
						-- Change type
						added = 'A',
						deleted = 'D',
						modified = 'M',
						renamed = 'R',
						-- Status type
						untracked = 'U',
						ignored = 'I',
						unstaged = '',
						staged = 'S',
						conflict = 'C',
					},
				},
			},
			window = {
				width = tree_width,
				mappings = {
					['q'] = 'close_window',
					['?'] = 'noop',
					['g?'] = 'show_help',
					['<Space>'] = 'noop',

					-- Close preview or floating neo-tree window, and clear hlsearch.
					['<Esc>'] = function(_)
						require('neo-tree.sources.filesystem.lib.filter_external').cancel()
						require('neo-tree.sources.common.preview').hide()
						vim.cmd([[ nohlsearch ]])
					end,

					['<2-LeftMouse>'] = 'open',
					['<CR>'] = 'open_with_window_picker',
					['l'] = 'open',
					['h'] = 'close_node',
					['C'] = 'close_node',
					['z'] = 'close_all_nodes',
					['<C-r>'] = 'refresh',

					['s'] = 'noop',
					['sv'] = 'open_split',
					['sg'] = 'open_vsplit',
					['st'] = 'open_tabnew',

					['<S-Tab>'] = 'prev_source',
					['<Tab>'] = 'next_source',

					['dd'] = 'delete',
					['c'] = { 'copy', config = { show_path = 'relative' } },
					['m'] = { 'move', config = { show_path = 'relative' } },
					['a'] = { 'add', nowait = true, config = { show_path = 'relative' } },
					['N'] = { 'add_directory', config = { show_path = 'relative' } },

					['P'] = 'paste_from_clipboard',
					['p'] = {
						'toggle_preview',
						config = { use_float = true },
					},

					-- Custom commands
					['w'] = toggle_tree_width,
					['Y'] = {
						function(state)
							local node = state.tree:get_node()
							local path = node:get_id()
							vim.fn.setreg('+', path, 'c')
						end,
						desc = 'Copy Path to Clipboard',
					},
					['O'] = {
						function(state)
							require('lazy.util').open(
								state.tree:get_node().path,
								{ system = true }
							)
						end,
						desc = 'Open with System Application',
					},
				},
			},
			filesystem = {
				bind_to_cwd = false,
				follow_current_file = { enabled = true },
				group_empty_dirs = true,
				use_libuv_file_watcher = true,
				window = {
					mappings = {
						['d'] = 'noop',
						['/'] = 'noop',
						['f'] = 'filter_on_submit',
						['F'] = 'fuzzy_finder',
						['<C-c>'] = 'clear_filter',

						-- Custom commands
						['gf'] = function(state)
							require('telescope.builtin').find_files({
								cwd = get_tree_current_directory(state),
							})
						end,
						['gr'] = function(state)
							require('telescope.builtin').live_grep({
								cwd = get_tree_current_directory(state),
							})
						end,
					},
				},

				filtered_items = {
					hide_dotfiles = false,
					hide_gitignored = false,
					hide_by_name = {
						'.git',
						'.hg',
						'.svc',
						'.DS_Store',
						'thumbs.db',
						'.sass-cache',
						'node_modules',
						'.pytest_cache',
						'.mypy_cache',
						'__pycache__',
						'.stfolder',
						'.stversions',
					},
					never_show_by_pattern = {
						'vite.config.js.timestamp-*',
					},
				},
			},
			buffers = {
				window = {
					mappings = {
						['dd'] = 'buffer_delete',
					},
				},
			},
			git_status = {
				window = {
					mappings = {
						['d'] = 'noop',
						['dd'] = 'delete',
					},
				},
			},
			document_symbols = {
				follow_cursor = true,
				window = {
					mappings = {
						['/'] = 'noop',
						['F'] = 'filter',
					},
				},
			},
		},
	},
}
