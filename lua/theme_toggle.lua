local M = {}

M.dark_themes = {
	{ name = "gruvbox-material" }, -- default
	{ name = "kanagawa" },
	{ name = "rose-pine-moon" },
	{ name = "everforest" },
}

M.light_themes = {
	{ name = "dayfox" }, -- default
	-- { name = "rose-pine-dawn" },
}

local dark_idx, light_idx = 1, 1

local function apply(background, theme)
	vim.o.background = background
	vim.cmd.colorscheme(theme.name)
	print("Theme: " .. theme.name)
end

function M.toggle()
	if vim.o.background == "dark" then
		dark_idx = (dark_idx % #M.dark_themes) + 1
		apply("dark", M.dark_themes[dark_idx])
	else
		light_idx = (light_idx % #M.light_themes) + 1
		apply("light", M.light_themes[light_idx])
	end
end

function M.set_dark()
	dark_idx = 1
	apply("dark", M.dark_themes[dark_idx])
end

function M.set_light()
	light_idx = 1
	apply("light", M.light_themes[light_idx])
end

return M
