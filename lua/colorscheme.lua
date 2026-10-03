return {
	{
		"EdenEast/nightfox.nvim", -- provides "dayfox", the light theme
		name = "nightfox",
		lazy = true,
		config = function()
			require("nightfox").setup({})
		end,
	},
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		config = function() end,
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",
		config = function()
			require("rose-pine").setup({})
		end,
	},
	{
		"sainnhe/gruvbox-material", -- default dark theme
		lazy = false,
		priority = 1000,
		config = function()
			vim.g.gruvbox_material_background = "medium" -- Set background style
		end,
	},
	{
		"sainnhe/everforest",
		lazy = true,
		priority = 1000,
		config = function()
			vim.g.everforest_background = "medium"
		end,
	},

	{
		"f-person/auto-dark-mode.nvim", -- follow macOS light/dark mode, in sync with ghostty
		priority = 1000,
		config = function()
			require("auto-dark-mode").setup({
				update_interval = 3000,
				set_dark_mode = function()
					require("theme_toggle").set_dark()
				end,
				set_light_mode = function()
					require("theme_toggle").set_light()
				end,
			})
		end,
	},
}
