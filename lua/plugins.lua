return {
	{
		-- Fixes a confirmed Neovim bug (neovim/neovim#27776): 'langmap' (see init.lua) only
		-- translates built-in commands, not custom vim.keymap.set mappings — so every <leader>
		-- hotkey silently did nothing while the OS layout was Russian. This wraps vim.keymap.set
		-- globally and registers a translated (Cyrillic) mapping alongside every original one,
		-- so hotkeys work under either layout without needing to switch anything.
		"Wansmer/langmapper.nvim",
		lazy = false,
		priority = 10000, -- must load before anything else registers keymaps
		config = function()
			require("langmapper").setup({
				layouts = {
					-- Plugin's own default `layout` string already matches standard ЙЦУКЕН
					-- (verified: positions line up with the physical QWERTY row order its
					-- default_layout uses) — only the macOS input-source id needs overriding,
					-- this Mac uses "Russian", not the plugin's default "RussianWin".
					ru = { id = "com.apple.keylayout.Russian" },
				},
			})
		end,
	},
	-- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
	"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
	"tpope/vim-fugitive",
	{ "nvim-lua/plenary.nvim", branch = "master" },
	{
		"folke/snacks.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			dashboard = {
				preset = {
					header = [[
      ___           ___                       ___
     /\__\         /\__\          ___        /\__\
    /::|  |       /:/  /         /\  \      /::|  |
   /:|:|  |      /:/  /          \:\  \    /:|:|  |
  /:/|:|  |__   /:/__/  ___      /::\__\  /:/|:|__|__
 /:/ |:| /\__\  |:|  | /\__\  __/:/\/__/ /:/ |::::\__\
 \/__|:|/:/  /  |:|  |/:/  / /\/:/  /    \/__/~~/:/  /
     |:/:/  /   |:|__/:/  /  \::/__/           /:/  /
     |::/  /     \::::/__/    \:\__\          /:/  /
     /:/  /       ~~~~         \/__/         /:/  /
     \/__/                                   \/__/    ]],
				},
			},
		},
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		opts = {
			anti_conceal = {
				enabled = false,
			},
			bullet = {
				right_pad = 1,
			},
		},
	},

	{
		"hat0uma/csvview.nvim",
		config = function()
			require("csvview").setup({
				view = {
					display_mode = "border",
				},
			})
		end,
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			-- Add any options here
		},
		dependencies = {
			"MunifTanjim/nui.nvim", -- Required for proper rendering
			"rcarriga/nvim-notify", -- Optional: for notification view
		},
	},
	{
		"voldikss/vim-floaterm",
		config = function()
			-- Optional: Customize key mappings
			vim.keymap.set("n", "<leader>1", ":FloatermToggle<CR>", { desc = "[T]oggle [T]erminal" })
			vim.keymap.set("n", "<leader>tf", ":FloatermNew fzf<CR>", { desc = "[T]erminal [F]zf" })
			vim.keymap.set("n", "<leader>td", ":FloatermNew lazydocker<CR>", { desc = "[T]erminal lazy[D]ocker" })
			vim.keymap.set("n", "<leader>ty", ":FloatermNew ytop<CR>", { desc = "[T]erminal [Y]top" })
			vim.keymap.set("n", "<leader>tl", ":FloatermNew lazygit<CR>", { desc = "[T]erminal [L]azygit" })
		end,
	},
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup({
				columns = { "icon" },
				"permissions",
				"size",
				"mtime",
				keymaps = {},
				default_file_explorer = true,
				delete_to_trash = true,
				float = {
					-- Padding around the floating window
					padding = 2,
					max_width = 50,
					max_height = 20,
					border = "rounded",
					win_options = {
						winblend = 0,
					},
				},

				view_options = {
					show_hidden = true,
				},
			})
			vim.keymap.set("n", "<leader>o", require("oil").toggle_float, { desc = "[O]il file explorer" })
		end,
	},
	{ -- Collection of various small independent plugins/modules
		"echasnovski/mini.nvim",
		config = function()
			-- require("mini.diff").setup({})
			-- Better Around/Inside textobjects
			--
			-- Examples:
			--  - va)  - [V]isually select [A]round [)]paren
			--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
			--  - ci'  - [C]hange [I]nside [']quote
			require("mini.ai").setup({ n_lines = 500 })

			-- Add/delete/replace surroundings (brackets, quotes, etc.)
			--
			-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
			-- - sd'   - [S]urround [D]elete [']quotes
			-- - sr)'  - [S]urround [R]eplace [)] [']
			require("mini.surround").setup()

			-- Simple and easy statusline.
			--  You could remove this setup call if you don't like it,
			--  and try some other statusline plugin
			local statusline = require("mini.statusline")
			-- set use_icons to true if you have a Nerd Font
			statusline.setup({ use_icons = vim.g.have_nerd_font })

			-- You can configure sections in the statusline by overriding their
			-- default behavior. For example, here we set the section for
			-- cursor location to LINE:COLUMN
			---@diagnostic disable-next-line: duplicate-set-field
			statusline.section_location = function()
				return "%2l:%-2v"
			end

			-- ... and there is more!
			--  Check out: https://github.com/echasnovski/mini.nvim
		end,
	},

	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map("n", "]c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gitsigns.nav_hunk("next")
					end
				end, { desc = "Jump to next git [c]hange" })

				map("n", "[c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gitsigns.nav_hunk("prev")
					end
				end, { desc = "Jump to previous git [c]hange" })

				-- Actions
				map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "git [s]tage hunk" })
				map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "git [r]eset hunk" })
				map("v", "<leader>hs", function()
					gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "git [s]tage hunk" })
				map("v", "<leader>hr", function()
					gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "git [r]eset hunk" })
				map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "git [S]tage buffer" })
				map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "git [R]eset buffer" })
				map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "git [p]review hunk" })
				map("n", "<leader>hb", gitsigns.blame_line, { desc = "git [b]lame line" })
				map("n", "<leader>hd", gitsigns.diffthis, { desc = "git [d]iff against index" })
				map("n", "<leader>hD", function()
					gitsigns.diffthis("@")
				end, { desc = "git [D]iff against last commit" })

				-- Toggles
				-- <leader>td is taken by floaterm (lazydocker) — tD (capital) avoids the clash
				map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "[T]oggle git show [b]lame line" })
				map("n", "<leader>tD", gitsigns.toggle_deleted, { desc = "[T]oggle git show [D]eleted" })
			end,
		},
	},
	{ -- Useful plugin to show you pending keybinds.
		"folke/which-key.nvim",
		event = "VimEnter", -- Sets the loading event to 'VimEnter'
		opts = {
			-- langmapper.nvim registers a second (Cyrillic-translated) copy of every mapping
			-- so hotkeys work under the Russian OS layout — hide those from the popup, only
			-- the original Latin-keyed one needs to be visible here.
			filter = function(mapping)
				return not mapping.lhs:match("[\128-\255]")
			end,
			icons = {
				-- set icon mappings to true if you have a Nerd Font
				mappings = vim.g.have_nerd_font,
				-- If you are using a Nerd Font: set icons.keys to an empty table which will use the
				-- default whick-key.nvim defined Nerd Font icons, otherwise define a string table
				keys = vim.g.have_nerd_font and {} or {
					Up = "<Up> ",
					Down = "<Down> ",
					Left = "<Left> ",
					Right = "<Right> ",
					C = "<C-…> ",
					M = "<M-…> ",
					D = "<D-…> ",
					S = "<S-…> ",
					CR = "<CR> ",
					Esc = "<Esc> ",
					ScrollWheelDown = "<ScrollWheelDown> ",
					ScrollWheelUp = "<ScrollWheelUp> ",
					NL = "<NL> ",
					BS = "<BS> ",
					Space = "<Space> ",
					Tab = "<Tab> ",
					F1 = "<F1>",
					F2 = "<F2>",
					F3 = "<F3>",
					F4 = "<F4>",
					F5 = "<F5>",
					F6 = "<F6>",
					F7 = "<F7>",
					F8 = "<F8>",
					F9 = "<F9>",
					F10 = "<F10>",
					F11 = "<F11>",
					F12 = "<F12>",
				},
			},
			-- Document existing key chains
			spec = {
				{ "<leader>c", group = "[C]ode", mode = { "n", "x" } },
				{ "<leader>d", group = "[D]ocument" },
				{ "<leader>r", group = "[R]ename" },
				{ "<leader>s", group = "[S]earch" },
				{ "<leader>w", group = "[W]orkspace" },
				{ "<leader>t", group = "[T]oggle" },
				{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
			},
		},
		config = function(_, opts)
			require("which-key").setup(opts)

			-- which-key reads its own follow-up keystrokes with getcharstr(), which does
			-- NOT apply 'langmap' — so once a popup is open (any group: ]d, <leader>x, gx...),
			-- a key typed on the Russian OS layout never resolves to the mapping it should.
			-- Run it through langmapper's own layout table first, same as 'langmap' would,
			-- so which-key's matching sees the translated Latin key.
			local state = require("which-key.state")
			local orig_getchar = state.getchar
			state.getchar = function()
				local ok, char = orig_getchar()
				if not ok then
					return ok, char
				end
				-- getcharstr() encodes special keys with K_SPECIAL (0x80),
				-- not UTF-8. Translating those bytes corrupts e.g. <Down> into "kd".
				if char:find(string.char(0x80), 1, true) then
					return ok, char
				end
				local translate_ok, translated = pcall(require("langmapper.utils").translate_keycode, char, "default", "ru")
				if translate_ok and translated and translated ~= "" then
					return ok, translated
				end
				return ok, char
			end
		end,
	},
	{ -- Fuzzy Finder (files, lsp, etc)
		-- "0.1.x" branch is stale (last touched 2024-05, no proper releases) — pinning to
		-- the latest tag pulls in fix(treesitter): standalone implementation (#3566), which
		-- stopped relying on nvim-treesitter's old .parsers/.configs modules (removed by the
		-- "main"-branch rewrite) for preview highlighting — that removal is what crashed the
		-- buffer previewer with "attempt to call field 'ft_to_lang' (a nil value)".
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		version = "*",
		dependencies = {
			{
				"nvim-telescope/telescope-fzf-native.nvim",

				-- `build` is used to run some command when the plugin is installed/updated.
				-- This is only run then, not every time Neovim starts up.
				build = "make",

				-- `cond` is a condition used to determine whether this plugin should be
				-- installed and loaded.
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },

			-- Useful for getting pretty icons, but requires a Nerd Font.
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		},
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})

			-- Enable Telescope extensions if they are installed
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			require("telescope").setup({
				log_level = vim.log.levels.WARN,
			})

			-- See `:help telescope.builtin`
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
			vim.keymap.set("n", "<leader>sk", function()
				-- Same reasoning as which-key's filter in this file: hide langmapper.nvim's
				-- Cyrillic-translated duplicate of every mapping, keep only the original.
				builtin.keymaps({
					lhs_filter = function(lhs)
						return not lhs:match("[\128-\255]")
					end,
				})
			end, { desc = "[S]earch [K]eymaps" })
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
			vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
			vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
			vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
			vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
			vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

			-- Slightly advanced example of overriding default behavior and theme
			vim.keymap.set("n", "<leader>/", function()
				-- You can pass additional configuration to Telescope to change the theme, layout, etc.
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, { desc = "[/] Fuzzily search in current buffer" })

			-- It's also possible to pass additional configuration options.
			--  See `:help telescope.builtin.live_grep()` for information about particular keys
			vim.keymap.set("n", "<leader>s/", function()
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end, { desc = "[S]earch [/] in Open Files" })

			-- Shortcut for searching your Neovim configuration files
			vim.keymap.set("n", "<leader>sn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "[S]earch [N]eovim files" })
		end,
	},

	{
		"debugloop/telescope-undo.nvim",
		dependencies = { -- note how they're inverted to above example
			{
				"nvim-telescope/telescope.nvim",
				dependencies = { "nvim-lua/plenary.nvim" },
			},
		},
		keys = {
			{ -- lazy style key map
				"<leader>u",
				"<cmd>Telescope undo<cr>",
				desc = "undo history",
			},
		},
		opts = {
			-- don't use `defaults = { }` here, do this in the main telescope spec
			extensions = {
				undo = {
					-- telescope-undo.nvim config, see below
				},
				-- no other extensions here, they can have their own spec too
			},
		},
		config = function(_, opts)
			-- Calling telescope's setup from multiple specs does not hurt, it will happily merge the
			-- configs for us. We won't use data, as everything is in it's own namespace (telescope
			-- defaults, as well as each extension).
			require("telescope").setup(opts)
			require("telescope").load_extension("undo")
		end,
	},
}
