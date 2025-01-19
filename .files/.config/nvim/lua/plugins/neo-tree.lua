-- Plugin: Neo-tree (minimal version)
-- https://github.com/rafi/vim-config

local has_git = vim.fn.executable('git') == 1

local function get_current_directory(state)
	local node = state.tree:get_node()
	if node.type ~= 'directory' or not node:is_expanded() then
		node = state.tree:get_node(node:get_parent_id())
	end
	return node.path
end

return {

	-----------------------------------------------------------------------------
	-- File explorer written in Lua
	{
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
		-- See: https://github.com/nvim-neo-tree/neo-tree.nvim
		opts = {
			sources = { 'filesystem', 'buffers' },
			enable_git_status = has_git,
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
				width = 30,
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
					['<CR>'] = 'open',
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

					['w'] = function(state)
						local normal = state.window.width
						local large = normal * 1.9
						local small = math.floor(normal / 1.6)
						local cur_width = state.win_width + 1
						local new_width = normal
						if cur_width > normal then
							new_width = small
						elseif cur_width == normal then
							new_width = large
						end
						vim.cmd(new_width .. ' wincmd |')
					end,
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
				use_libuv_file_watcher = has_git,
				window = {
					mappings = {
						['d'] = 'noop',
						['/'] = 'noop',
						['f'] = 'filter_on_submit',
						['F'] = 'fuzzy_finder',
						['<C-c>'] = 'clear_filter',

						-- Find file in path.
						['gf'] = function(state)
							LazyVim.pick('files', { cwd = get_current_directory(state) })()
						end,

						-- Live grep in path.
						['gr'] = function(state)
							LazyVim.pick('live_grep', { cwd = get_current_directory(state) })()
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
