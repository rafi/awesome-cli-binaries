-- Rafi's Neovim autocmds
-- https://github.com/rafi/vim-config (minimal version)
-- ===

vim.api.nvim_del_augroup_by_name('lazyvim_highlight_yank')
vim.api.nvim_del_augroup_by_name('lazyvim_wrap_spell')

local function augroup(name)
	return vim.api.nvim_create_augroup('rafi.' .. name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
	group = augroup('highlight_yank'),
	callback = function()
		(vim.hl or vim.highlight).on_yank({ timeout = 50 })
	end,
})

-- Show cursor line only in active window
vim.api.nvim_create_autocmd({ 'InsertLeave', 'WinEnter' }, {
	group = augroup('auto_cursorline_show'),
	callback = function(event)
		if vim.bo[event.buf].buftype == '' then
			vim.opt_local.cursorline = true
		end
	end,
})
vim.api.nvim_create_autocmd({ 'InsertEnter', 'WinLeave' }, {
	group = augroup('auto_cursorline_hide'),
	callback = function()
		vim.opt_local.cursorline = false
	end,
})

-- Wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd('FileType', {
	group = augroup('wrap_spell'),
	pattern = { 'text', 'plaintex', 'typst', 'gitcommit', 'markdown' },
	callback = function()
		vim.opt_local.spell = true
	end,
})

-- Disable swap/undo/backup files in temp directories or shm
vim.api.nvim_create_autocmd('BufWritePre', {
	group = augroup('undo_disable'),
	pattern = { '/tmp/*', '*.tmp', '*.bak', 'COMMIT_EDITMSG', 'MERGE_MSG' },
	callback = function(event)
		vim.opt_local.undofile = false
		if event.file == 'COMMIT_EDITMSG' or event.file == 'MERGE_MSG' then
			vim.opt_local.swapfile = false
		end
	end,
})

-- Disable swap/undo/backup files in temp directories or shm
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufReadPre' }, {
	group = augroup('secure'),
	pattern = {
		'/tmp/*',
		'$TMPDIR/*',
		'$TMP/*',
		'$TEMP/*',
		'*/shm/*',
		'/private/var/*',
	},
	callback = function()
		vim.opt_local.undofile = false
		vim.opt_local.swapfile = false
		vim.opt_global.backup = false
		vim.opt_global.writebackup = false
	end,
})
