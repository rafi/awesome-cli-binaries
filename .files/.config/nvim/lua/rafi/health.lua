-- Health
-- https://github.com/rafi/vim-config

local M = {}

local nvim_min_ver = '0.9.5'
local nvim_max_ver = '0.10.2'

function M.check()
	vim.health.start('rafi')

	if vim.fn.has('nvim-' .. nvim_min_ver) == 1 then
		vim.health.info(('Neovim version: %s'):format(vim.version()))
		vim.health.ok(('Using Neovim >= %s'):format(nvim_min_ver))
		if vim.fn.has('nvim-' .. nvim_max_ver) ~= 1 then
			vim.health.warn('Upgrade your Neovim to latest version.')
		end
	else
		vim.health.error(
			('Neovim >= %s is required'):format(nvim_min_ver),
			{ 'Upgrade Neovim to latest version.' }
		)
	end

	-- stylua: ignore
	local optionals = {
		'git', 'rg', 'bat', { 'fd', 'fdfind' }, 'lazygit', 'zoxide',
	}

	for _, cmd in ipairs(optionals) do
		local name = type(cmd) == 'string' and cmd or vim.inspect(cmd)
		local commands = type(cmd) == 'string' and { cmd } or cmd
		---@cast commands string[]
		local found = false

		for _, c in ipairs(commands) do
			if vim.fn.executable(c) == 1 then
				name = c
				found = true
			end
		end

		if found then
			vim.health.ok(('`%s` is installed'):format(name))
		else
			vim.health.warn(('`%s` is not installed'):format(name))
		end
	end
end

return M
