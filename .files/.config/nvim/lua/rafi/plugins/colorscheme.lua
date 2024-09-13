-- Plugins: Colorschemes
-- https://github.com/rafi/vim-config

return {

	-- Use last-used colorscheme abstract, deep-space, deus, dogrun, gotham,
	-- hybrid, jellybeans, purify, sierra, sunbather, twilight256
	{
		'rafi/theme-loader.nvim',
		lazy = false,
		priority = 99,
		opts = { initial_colorscheme = 'habamax' },
	},

	-- Awesome colorschemes
	{ 'rafi/awesome-vim-colorschemes', priority = 97, lazy = false },
}
