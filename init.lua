vim.opt.termguicolors = true
vim.opt.conceallevel = 2

vim.filetype.add({ extension = { beancount = "beancount", bean = "beancount" } })

local theme_toggle = require("theme_toggle")

vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Sync clipboard between OS and Neovim.
-- On a machine with no native clipboard tool (headless Linux box reached over SSH) fall back
-- to OSC 52: the copy/paste is forwarded to the terminal emulator (ghostty/kitty/wezterm
-- understand it), so yanking inside nvim lands in the clipboard of the local machine.
local has_native_clipboard = false
for _, tool in ipairs({ "pbcopy", "wl-copy", "xclip", "xsel" }) do
	if vim.fn.executable(tool) == 1 then
		has_native_clipboard = true
	end
end
if not has_native_clipboard then
	local osc52 = require("vim.ui.clipboard.osc52")
	vim.g.clipboard = {
		name = "OSC 52",
		copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
		paste = { ["+"] = osc52.paste("+"), ["*"] = osc52.paste("*") },
	}
end
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

-- [[ Setting options ]]
vim.opt.number = true -- Make line numbers default
vim.opt.relativenumber = true -- You can also add relative line numbers, to help with jumping.
vim.opt.mouse = "a" -- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.showmode = false -- Don't show the mode, since it's already in the status line
vim.opt.breakindent = true -- Enable break indent
vim.opt.undofile = true -- Save undo history
vim.opt.ignorecase = true -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.smartcase = true -- Case-sensitive searching if you have capital letters in your search
vim.opt.signcolumn = "yes" -- Keep signcolumn on by default
vim.opt.updatetime = 250 -- Decrease update time
vim.opt.timeoutlen = 300 -- Time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.splitright = true -- Vertical splits will automatically be to the right
vim.opt.splitbelow = true -- Horizontal splits will automatically be below
vim.opt.list = true -- Show some invisible characters (tabs...)
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.inccommand = "split" -- Show live preview of substitute
vim.opt.cursorline = true -- Show which line your cursor is on
vim.opt.wrap = false -- Display long lines as just one line
vim.opt.scrolloff = 5 -- Keep 5 lines above and below the cursor when scrolling

-- Let Normal/Visual-mode commands work by physical key position even when the
-- OS keyboard layout is Russian (ЙЦУКЕН), so hotkeys never require switching
-- back to EN. Only affects command interpretation, not what Insert mode types.
vim.opt.langmap =
	[[йцукенгшщзхъфывапролджэячсмитьбю;qwertyuiop[]asdfghjkl\;'zxcvbnm\,.,ЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ;QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>]]

-- Force the macOS keyboard layout to EN when entering the ':' command-line, so typing a
-- command while the OS layout is still Russian doesn't insert Cyrillic (langmap above only
-- covers Normal/Visual mode, not typing full command names). Restores whatever layout was
-- active before on leaving. Needs `macism` (brew tap laishulu/homebrew && brew install macism).
if vim.fn.executable("macism") == 1 then
	local saved_input_source = nil
	local macism_group = vim.api.nvim_create_augroup("MacismCmdline", { clear = true })
	vim.api.nvim_create_autocmd("CmdlineEnter", {
		group = macism_group,
		pattern = ":",
		callback = function()
			saved_input_source = vim.trim(vim.fn.system("macism"))
			vim.fn.system("macism com.apple.keylayout.US")
		end,
	})
	vim.api.nvim_create_autocmd("CmdlineLeave", {
		group = macism_group,
		pattern = ":",
		callback = function()
			if saved_input_source and saved_input_source ~= "" then
				vim.fn.system("macism " .. saved_input_source)
			end
		end,
	})
end

vim.o.foldmethod = "indent"
vim.o.foldlevel = 100

-- [[ Keymaps ]]
vim.keymap.set("n", "|", theme_toggle.toggle, { desc = "Toggle through colorschemes" }) -- Toggle through themes
-- vim.keymap.set("n", "<S-j>", "<C-d>") -- Move down half a page
-- vim.keymap.set("n", "<S-k>", "<C-u>") -- Move up half a page
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>") -- Clear highlights on <Esc>
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" }) -- Open quickfix list
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show line diagnostics ([E]rror)" }) -- Show diagnostic float on demand
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" }) -- Exit terminal mode with <Esc><Esc>

-- Auto-show a floating diagnostic window when the cursor rests on an error line in
-- Normal mode (after `updatetime`, see :h CursorHold), so red underlines don't need
-- a mouse hover to explain themselves.
vim.api.nvim_create_autocmd("CursorHold", {
	desc = "Show diagnostics for the current line automatically",
	group = vim.api.nvim_create_augroup("diagnostic-float-on-hold", { clear = true }),
	callback = function()
		vim.diagnostic.open_float(nil, { focus = false })
	end,
})
vim.keymap.set("n", "<leader>tw", function()
	vim.opt.wrap = not vim.opt.wrap:get()
end, { desc = "[T]oggle [W]rap" })

vim.keymap.set("n", "<leader>=", ":vsplit<CR>") -- Split vertically
vim.keymap.set("n", "<leader>-", ":split<CR>") -- Split horizontally
vim.keymap.set("n", "<leader>0", ":only<CR>") -- Close all other windows

--  Use CTRL+<hjkl> to switch between windows
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal modea
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ import = "plugins" },
	{ import = "colorscheme" },
	{ import = "lsp" },
})

-- Catches any mapping not made via vim.keymap.set/nvim_set_keymap (e.g. plain vimscript
-- :map). Must run last, after every plugin has registered its keymaps.
require("langmapper").automapping({ global = true, buffer = true })
