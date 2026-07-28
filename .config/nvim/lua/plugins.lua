-- ===================================================================
-- Plugin management via the built-in `vim.pack` (migrated from lazy.nvim)
--
-- References:
--   :h vim.pack        :h vim.pack-examples
--   "A Guide to vim.pack" (Evgeni Chasnovski)
--
-- Notes on the design used here:
--   * A single scheduled `vim.pack.add(specs, { load = false })` installs
--     every plugin (and records them in the lockfile) in one confirmation
--     step, mirroring how lazy.nvim installs everything up front.
--   * Each plugin then gets "lazy loaded" on its original trigger:
--       - "schedule"  -> right after startup (what lazy called VeryLazy)
--       - { ft = .. } -> on FileType
--       - { cmd = .. }-> on CmdUndefined
--       - { event = ..} -> on the given (User) event
--     The loader just `packadd`s the already-installed plugin and runs its
--     setup, so startup stays fast.
--   * Build steps (parsers, native extensions, node deps) run from a
--     `PackChanged` hook created BEFORE the first add, so they also fire
--     when bootstrapping from the lockfile on a new machine.
--
-- `when` / `schedule` / `cond` below are keys of OUR OWN small table, not
-- vim.pack keywords. They are interpreted by the loop at the bottom of
-- this file, which ultimately calls the real `vim.pack.add()`.
-- ===================================================================

local map = vim.keymap.set
local hl = vim.api.nvim_set_hl
local has = vim.fn.has
local vscode = vim.g.vscode
local not_vscode = not vscode

-- Source shorthands
local gh = function(x)
	return "https://github.com/" .. x
end
local gitee = function(x)
	return "https://gitee.com/" .. x
end

--------------------------------------------------------------------
-- Build / install hooks
--------------------------------------------------------------------
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if kind ~= "install" and kind ~= "update" then
			return
		end

		-- nvim-treesitter: refresh grammar parsers after an update
		if name == "nvim-treesitter" then
			if not ev.data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			vim.cmd("TSUpdate")
		end

		-- blink.cmp: build the Rust fuzzy matcher
		if name == "blink.cmp" then
			require("blink.cmp").build():pwait()
		end

		-- telescope-fzf-native.nvim: compile the C extension
		if name == "telescope-fzf-native.nvim" then
			vim.system({ "make" }, { cwd = ev.data.path }):wait()
		end

		-- LuaSnip: build jsregexp
		if name == "LuaSnip" then
			vim.system({ "make", "install_jsregexp" }, { cwd = ev.data.path }):wait()
		end

		-- markdown-preview.nvim: install node dependencies
		if name == "markdown-preview.nvim" then
			if not ev.data.active then
				vim.cmd.packadd("markdown-preview.nvim")
			end
			vim.fn["mkdp#util#install"]()
		end

		-- firenvim: (re)install the browser extension manifest
		if name == "firenvim" then
			if not ev.data.active then
				vim.cmd.packadd("firenvim")
			end
			vim.cmd("call firenvim#install(0)")
		end
	end,
})

--------------------------------------------------------------------
-- Plugin declarations
--   spec  : string | table   (vim.pack specification)
--   setup : function|nil     (run after the plugin is packadded)
--   when  : "schedule" | { ft = ".." } | { cmd = ".." } | { event = ".." }
--   cond  : bool|nil         (skip the plugin when false)
-- Dependencies are listed as their own entries ordered BEFORE the plugins
-- that use them (so they are packadded first within the same tick).
--------------------------------------------------------------------
local plugins = {
	------------------------------------------------------------------
	-- Treesitter
	------------------------------------------------------------------
	{
		spec = gh("nvim-treesitter/nvim-treesitter"),
		when = "schedule",
		setup = function()
			require("plugin_config.nvim_treesitter")
		end, },
	{
		spec = gh("mikavilpas/yazi.nvim"),
		when = "schedule",
		setup = function()
      map("n", "<C-t>", require("yazi").toggle)
			require("yazi").setup()
		end,
	},

	{
		spec = gh("nvim-treesitter/nvim-treesitter-textobjects"),
		when = "schedule",
		setup = function()
			require("plugin_config.nvim_treesitter_textobjects")
		end,
	},

	------------------------------------------------------------------
	-- Telescope (plenary + fzf-native are its dependencies)
	------------------------------------------------------------------
	{
		spec = gh("nvim-lua/plenary.nvim"),
		when = "schedule",
	},
	{
		spec = gh("nvim-telescope/telescope-fzf-native.nvim"),
		when = "schedule",
	},
	{
		spec = gh("nvim-telescope/telescope.nvim"),
		cond = not_vscode,
		when = "schedule",
		setup = function()
			require("plugin_config.telescope_nvim")
		end,
	},

	------------------------------------------------------------------
	-- Completion (LuaSnip + fittencode + dictionary feed blink.cmp)
	------------------------------------------------------------------
	{
		spec = { src = gh("L3MON4D3/LuaSnip") },
		when = "schedule",
		setup = function()
      require("plugin_config.luasnip")
		end,
	},
	{
		spec = gh("luozhiya/fittencode.nvim"),
		cond = not_vscode,
		when = "schedule",
		-- Original lazy config only did require("plugin_config.fittencode"),
		-- whose body was require("fittencode").setup({}) with all opts commented.
		setup = function()
			require("fittencode").setup({})
		end,
	},
	{
		spec = gh("Kaiser-Yang/blink-cmp-dictionary"),
		when = "schedule",
	},
	{
		-- blink.cmp v2 depends on this companion library (required at runtime).
		spec = gh("saghen/blink.lib"),
		when = "schedule",
	},
	{
		spec = { src = gh("saghen/blink.cmp") },
		when = "schedule",
		setup = function()
			local opts = {
				snippets = { preset = "luasnip" },
				fuzzy = { implementation = "rust" },
				keymap = {
					preset = "default",
					-- ["<C-y>"] = { "accept", "fallback" },
					["<C-1>"] = {
						function(cmp)
							return cmp.accept({ index = 1 })
						end,
					},
					["<C-2>"] = {
						function(cmp)
							return cmp.accept({ index = 2 })
						end,
					},
					["<C-3>"] = {
						function(cmp)
							return cmp.accept({ index = 3 })
						end,
					},
					["<C-4>"] = {
						function(cmp)
							return cmp.accept({ index = 4 })
						end,
					},
					["<C-5>"] = {
						function(cmp)
							return cmp.accept({ index = 5 })
						end,
					},
					["<C-6>"] = {
						function(cmp)
							return cmp.accept({ index = 6 })
						end,
					},
					["<C-7>"] = {
						function(cmp)
							return cmp.accept({ index = 7 })
						end,
					},
					["<C-8>"] = {
						function(cmp)
							return cmp.accept({ index = 8 })
						end,
					},
					["<C-9>"] = {
						function(cmp)
							return cmp.accept({ index = 9 })
						end,
					},
				},
				completion = {
					list = {
						selection = {
							preselect = true,
							auto_insert = true,
						},
					},
					menu = {
						draw = {
							columns = { { "number" }, { "label" }, { "kind" } },
							components = {
								number = {
									text = function(ctx)
										return ctx.idx == 0 and "" or tostring(ctx.idx)
									end,
									highlight = "Comment",
									width = { min = 2 },
								},
							},
						},
					},
				},
				sources = {
					default = { "buffer", "lsp", "snippets", "lazydev", "path", "dictionary" },
					providers = {
						lazydev = {
							name = "LazyDev",
							module = "lazydev.integrations.blink",
							score_offset = 100,
						},
						dictionary = {
							module = "blink-cmp-dictionary",
							name = "Dict",
							min_keyword_length = 3,
							max_items = 4,
							opts = {
								dictionary_files = { vim.api.nvim_get_option_value("dictionary", {}) },
							},
							score_offset = -50,
						},
					},
				},
			}
			require("blink.cmp").setup(opts)
		end,
	},

	------------------------------------------------------------------
	-- Editing helpers
	------------------------------------------------------------------
	{
		spec = gitee("tanloong/vim-surround.git"),
		when = "schedule",
		setup = function()
			vim.keymap.set("x", "s", "<Plug>VSurround")
		end,
	},
	{
		spec = gh("mzlogin/vim-markdown-toc"),
		when = { ft = "markdown" },
		setup = function()
			require("plugin_config.vim_markdown_toc")
		end,
	},
	{
		spec = "https://github.com/Vigemus/iron.nvim",
		cond = not_vscode,
		when = { ft = "python" },
		setup = function()
			local iron = require("iron.core")
			local common = require("iron.fts.common")

			iron.setup({
				config = {
					scratch_repl = true,
					repl_definition = {
						sh = { command = { "bash" } },
						python = {
							command = { "python" },
							format = common.bracketed_paste_python,
							block_dividers = { "# %%", "#%%" },
							env = { PYTHON_BASIC_REPL = "1" },
						},
						lua = { command = { "lua" } },
						php = { command = { "php", "-a" } },
						r = { command = { "R" } },
						rmd = { command = { "R" } },
					},
					repl_open_cmd = require("iron.view").split.horizontal.botright(0.35),
				},
				keymaps = {
					send_motion = "<space>sc",
					visual_send = "<space>sc",
					send_file = "<space>sf",
					send_line = "<space>sl",
					send_until_cursor = "<space>su",
					send_mark = "<space>sm",
					mark_motion = "<space>mc",
					mark_visual = "<space>mc",
					remove_mark = "<space>md",
					cr = "<space>s<cr>",
					interrupt = "<space>s<space>",
					exit = "<space>sq",
					clear = "<space>cl",
					send_code_block = "<space>sb",
					send_code_block_and_move = "<space>sn",
				},
				highlight = { italic = false },
				ignore_blank_lines = true,
			})
			vim.keymap.set("n", "<space>rs", "<cmd>IronRepl<cr>")
			vim.keymap.set("n", "<space>rr", "<cmd>IronRestart<cr>")
			vim.keymap.set("n", "<space>rf", "<cmd>IronFocus<cr>")
			vim.keymap.set("n", "<space>rh", "<cmd>IronHide<cr>")
		end,
	},
	{
		spec = gitee("mirrors/vimtex.git"),
		when = { ft = "tex" },
		setup = function()
			require("plugin_config.vimtex")
		end,
	},
	{
		spec = gh("smoka7/hop.nvim"),
		when = "schedule",
		setup = function()
			require("plugin_config.hop")
		end,
	},
	{
		spec = { src = gh("lukas-reineke/indent-blankline.nvim"), version = "v3.6.0" },
		cond = not_vscode,
		when = "schedule",
		setup = function()
			hl(0, "IblIndent", { ctermbg = "none", ctermfg = "darkgray", fg = "#3A3A3A" })
			require("ibl").setup({ scope = { enabled = false } })
		end,
	},
	{
		spec = gitee("tanloong/nvim-align.git"),
		when = "schedule",
	},
	{
		spec = { src = gh("tanloong/toggleterm.nvim"), version = "skip-toggle" },
		when = "schedule",
		setup = function()
			require("plugin_config.toggleterm")
		end,
	},
	{
		spec = gh("nat-418/boole.nvim"),
		when = "schedule",
		setup = function()
			require("plugin_config.boole_nvim")
		end,
	},
	{
		spec = { src = gh("tanloong/interlaced.nvim"), version = "dev" },
		when = { ft = "text" },
		setup = function()
			vim.g.interlaced = {
				keymaps = {
					{ "n", ",", "push_up" },
					{ "n", "<", "push_up_pair" },
					{ "n", "e", "push_up_left_part" },
					{ "n", ".", "pull_below" },
					{ "n", ">", "pull_below_pair" },
					{ "n", "d", "push_down_right_part" },
					{ "n", "D", "push_down" },
					{ "n", "s", "leave_alone" },
					{ "n", "[e", "swap_with_above" },
					{ "n", "]e", "swap_with_below" },
					{ "n", "U", "undo" },
					{ "n", "R", "redo" },
					{ "n", "J", "navigate_down" },
					{ "n", "K", "navigate_up" },
					{ "n", "md", "dump" },
					{ "n", "ml", "load" },
					{ "n", "gn", "next_unaligned" },
					{ "n", "gN", "prev_unaligned" },
					{ "n", "mt", "match_toggle" },
					{ "n", "m;", "list_matches" },
					{ "n", "ma", "match_add" },
					{ "v", "ma", "match_add_visual" },
				},
				setup_mappings_now = false,
				separators = { ["1"] = "", ["2"] = " " },
				lang_num = 2,
				enable_keybindings_hook = function()
					if vim.g.did_coc_loaded ~= nil then
						vim.cmd([[CocDisable]])
					end
					vim.opt_local.undofile = false
					vim.opt_local.signcolumn = "no"
					vim.opt_local.relativenumber = false
					vim.opt_local.number = false
					require("interlaced").action.load()
					require("interlaced").ShowChunkNr()
				end,
				sound_feedback = true,
			}
			require("interlaced")
		end,
	},
	{
		spec = gh("iamcco/markdown-preview.nvim"),
		when = { ft = "markdown" },
		setup = function()
			require("plugin_config.markdown_preview")
		end,
	},
	{
		spec = gh("robitx/gp.nvim"),
		cond = not_vscode,
		when = "schedule",
		setup = function()
			require("plugin_config.gp_nvim")
		end,
	},
	{
		spec = { src = gh("max397574/better-escape.nvim"), version = "1.0.0" },
		when = "schedule",
		setup = function()
			require("better_escape").setup({
				timeout = vim.o.timeoutlen,
				mappings = { i = { j = { k = '<Esc>/<<>><CR>:set nohlsearch<CR>"_c4<right>' } } },
			})
			map("n", "<SPACE><SPACE>", '/<<>><CR>:set nohlsearch<CR>"_c4<right>')
		end,
	},
  {spec = gh("justinmk/guh.nvim"), when = "schedule", },
	{
		spec = gh("folke/lazydev.nvim"),
		when = { ft = "lua" },
		setup = function()
			require("lazydev").setup({
				library = {
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			})
		end,
	},
	{
		spec = gh("stevearc/conform.nvim"),
		when = "schedule",
		setup = function()
			local cf = require("conform")
			cf.setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "ruff_fix", "ruff_format" },
					sql = { "sqruff" },
				},
			})

			vim.keymap.set({ "n", "v" }, "<leader>f", function()
				cf.format()
			end, { silent = true })
		end,
	},
	{
		spec = gh("tpope/vim-fugitive"),
		when = { event = "User InGitRepo" },
		setup = function()
			require("plugin_config.vim_fugitive")
		end,
	},
	-- {
	-- 	spec = gh("nvim-mini/mini.files"),
	-- 	cond = has("win32") == 1 and not_vscode,
	-- 	when = "schedule",
	-- 	setup = function()
	-- 		local MiniFiles = require("mini.files")
	-- 		MiniFiles.setup()
	-- 		map("n", "<C-t>", function()
	-- 			MiniFiles.open(vim.api.nvim_buf_get_name(0))
	-- 		end)
	--
	-- 		local set_cwd = function()
	-- 			local path = (MiniFiles.get_fs_entry() or {}).path
	-- 			if path == nil then
	-- 				return vim.notify("Cursor is not on valid entry")
	-- 			end
	-- 			vim.fn.chdir(vim.fs.dirname(path))
	-- 		end
	--
	-- 		local yank_path = function()
	-- 			local path = (MiniFiles.get_fs_entry() or {}).path
	-- 			if path == nil then
	-- 				return vim.notify("Cursor is not on valid entry")
	-- 			end
	-- 			vim.fn.setreg(vim.v.register, path)
	-- 		end
	--
	-- 		local yank_dir = function()
	-- 			local path = (MiniFiles.get_fs_entry() or {}).path
	-- 			if path == nil then
	-- 				return vim.notify("Cursor is not on valid entry")
	-- 			end
	-- 			vim.fn.setreg(vim.v.register, vim.fs.dirname(path))
	-- 		end
	--
	-- 		local ui_open = function()
	-- 			vim.ui.open(MiniFiles.get_fs_entry().path)
	-- 		end
	--
	-- 		vim.api.nvim_create_autocmd("User", {
	-- 			pattern = "MiniFilesBufferCreate",
	-- 			callback = function(args)
	-- 				local b = args.data.buf_id
	-- 				vim.keymap.set("n", "~", set_cwd, { buffer = b, desc = "Set cwd" })
	-- 				vim.keymap.set("n", "gx", ui_open, { buffer = b, desc = "OS open" })
	-- 				vim.keymap.set("n", "yp", yank_path, { buffer = b, desc = "Yank path" })
	-- 				vim.keymap.set("n", "yd", yank_dir, { buffer = b, desc = "Yank dir" })
	-- 			end,
	-- 		})
	-- 	end,
	-- },
	{
		spec = gh("glacambre/firenvim"),
		when = "schedule",
		setup = function()
			require("plugin_config.firenvim")
		end,
	},
}

--------------------------------------------------------------------
-- Install everything once (scheduled, not yet loaded) so a fresh
-- machine gets all plugins from the lockfile in a single confirmation
-- step. Loaders are registered AFTER this `vim.pack.add` returns, which
-- only happens once the install (and confirmation) has finished -- so a
-- loader never runs against a plugin that isn't on disk yet. Each loader
-- then just `packadd`s the already-installed plugin and runs its setup,
-- keeping startup fast.
--------------------------------------------------------------------
vim.schedule(function()
	local specs = {}
	for _, p in ipairs(plugins) do
		if p.cond ~= false then
			table.insert(specs, p.spec)
		end
	end
	vim.pack.add(specs, { load = false }) -- installs + `:packadd!` (rtp only); the
	-- loaders below do the real `:packadd`

	------------------------------------------------------------------
	-- Lazy loaders (registered only after the install above completed)
	------------------------------------------------------------------
	local function plug_name(spec)
		if type(spec) == "string" then
			return (spec:match("([^/]+)%.git$") or spec:match("([^/]+)$"))
		end
		if spec.name then
			return spec.name
		end
		return plug_name(spec.src)
	end

	local function load_plugin(p)
		-- The bootstrap already recorded every plugin as "active" via
		-- `vim.pack.add(..., { load = false })`, which runs `:packadd!` -- that
		-- only adds the directory to 'runtimepath' but does NOT source the
		-- plugin's `plugin/` scripts. Calling `vim.pack.add` again is a no-op
		-- because vim.pack dedupes by active plugin, so we use the raw
		-- `:packadd` (without `!`) to actually source those scripts. The module
		-- is then available for the `setup()` call right after.
		vim.cmd.packadd({ plug_name(p.spec) })
		if p.setup then
			p.setup()
		end
	end

	for _, p in ipairs(plugins) do
		if p.cond ~= false then
			local when = p.when
			if when == "schedule" or when == nil then
				vim.schedule(function()
					load_plugin(p)
				end)
			elseif type(when) == "table" and when.ft then
				vim.api.nvim_create_autocmd("FileType", {
					pattern = when.ft,
					once = true,
					callback = function()
						load_plugin(p)
					end,
				})
			elseif type(when) == "table" and when.cmd then
				vim.api.nvim_create_autocmd("CmdUndefined", {
					pattern = when.cmd,
					once = true,
					callback = function()
						load_plugin(p)
					end,
				})
			elseif type(when) == "table" and when.event then
				local parts = vim.split(when.event, " ", { plain = true })
				if parts[1] == "User" then
					vim.api.nvim_create_autocmd("User", {
						pattern = parts[2],
						callback = function()
							load_plugin(p)
						end,
					})
				else
					vim.api.nvim_create_autocmd(parts[1], {
						pattern = parts[2],
						callback = function()
							load_plugin(p)
						end,
					})
				end
			end
		end
	end
end)
