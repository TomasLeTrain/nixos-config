local map = vim.keymap.set

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.winborder = "rounded"

-- set colorscheme
require("vague").setup(
	{
		transparent = true,
		-- default color looks too flashy while waiting for lualine to load
		on_highlights = function(hl, c)
			hl.StatusLine.bg = c.inactiveBg
		end,
	}
)

vim.cmd.colorscheme('vague')

require("oil").setup()
map({ "n", "x" }, "<leader>e", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- remapings
map("n", "<leader>q", ":q<CR>")
map("n", "<leader>w", ":w<CR>", { silent = true })

map('n', 'mk', ':update<CR> :make<CR>')
map('n', 'co', ':copen<CR>')

map('n', '<C-f>', ':Open .<CR>')
map('n', '<leader>s', ':e #<CR>')
map('n', '<leader>S', ':sf #<CR>')
map({ 'n', 'v' }, '<leader>c', '1z=') -- autocorrect

map({ "n", "v" }, "<leader>y", '"+y', { noremap = true, silent = true, desc = 'Yank to clipboard' })
map({ "n", "v" }, "<leader>Y", '"+yy', { noremap = true, silent = true, desc = 'Yank line to clipboard' })
map({ "n", "v" }, "<leader>d", '"+d')

map("x", "<leader>p", '"_dP',
	{ noremap = true, silent = true, desc = 'Paste over selection without erasing unnamed register' })

-- options

vim.cmd([[set mouse=]])
vim.cmd([[set noswapfile]])

vim.opt.mouse = "" -- no mouse
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.undofile = true
vim.opt.incsearch = true
vim.opt.hlsearch = false
vim.opt.scrolloff = 6
vim.opt.signcolumn = "yes"
vim.opt.foldopen = "mark,percent,quickfix,search,tag,undo"

-- lazy loaded
require('lze').load {
	{
		"blink.cmp",
		enabled = nixCats('general') or false,
		event = "DeferredUIEnter",
		on_require = "blink",
		after = function(plugin)
			require("blink.cmp").setup({
				-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
				-- See :h blink-cmp-config-keymap for configuring keymaps
				keymap = { preset = 'default' },
				appearance = {
					nerd_font_variant = 'mono'
				},
				signature = { enabled = true, },
				sources = {
					default = { 'lsp', 'path', 'snippets', 'buffer' },
				},
			})
		end,
	},


	{
		"nvim-treesitter",
		enabled = nixCats('general') or false,
		-- cmd = { "" },
		event = "DeferredUIEnter",
		-- ft = "",
		-- keys = "",
		-- colorscheme = "",
		after = function(plugin)
			---@param buf integer
			---@param language string
			local function treesitter_try_attach(buf, language)
				-- check if parser exists and load it
				if not vim.treesitter.language.add(language) then
					return false
				end
				-- enables syntax highlighting and other treesitter features
				vim.treesitter.start(buf, language)

				-- enables treesitter based folds
				vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
				vim.wo.foldmethod = "expr"
				-- ensure folds are open to begin with
				vim.o.foldlevel = 99

				-- enables treesitter based indentation
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

				return true
			end

			local installable_parsers = require("nvim-treesitter").get_available()
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					local buf, filetype = args.buf, args.match
					local language = vim.treesitter.language.get_lang(filetype)
					if not language then
						return
					end

					if not treesitter_try_attach(buf, language) then
						if vim.tbl_contains(installable_parsers, language) then
							-- not already installed, so try to install them via nvim-treesitter if possible
							require("nvim-treesitter").install(language):await(function()
								treesitter_try_attach(buf, language)
							end)
						end
					end
				end,
			})
		end,
	},
	{
		"mini.nvim",
		enabled = nixCats('general') or false,
		event = "DeferredUIEnter",
		after = function(plugin)
			require('mini.pairs').setup()
			require('mini.icons').setup()
			require('mini.ai').setup()

			require('mini.pick').setup(
				{
					mappings = {
						choose_marked = "<C-G>"
					}
				}
			)
			map('n', '<leader>f', ":Pick files<CR>")
			map('n', '<leader>r', ":Pick grep_live<CR>")
			map('n', '<leader>h', ":Pick help<CR>")
		end,
	},
	{
		"lualine.nvim",
		enabled = nixCats('general') or false,
		event = "DeferredUIEnter",
		after = function(plugin)
			require('lualine').setup()
		end,
	},
	{
		"neogen",
		enabled = nixCats('general') or false,
		event = "DeferredUIEnter",
		after = function(plugin)
			require('neogen').setup({ snippet_engine = "nvim" })
			map("n", "<Leader>nf", ":lua require('neogen').generate()<CR>", opts)
		end,
	},
	{
		"undotree",
		enabled = nixCats('general') or false,
		event = "DeferredUIEnter",
		after = function(plugin)
			map("n", "<leader>u", vim.cmd.UndotreeToggle)
		end,
	},
	{
		'cord.nvim',
		enabled = nixCats('general') or false,
		event = "DeferredUIEnter",
		after = function(plugin)
			require('cord').setup
			{
				enabled = true,
				log_level = vim.log.levels.OFF,
				editor = {
					client = 'neovim',
					tooltip = 'Overcomplicated Text Manipulator.',
					icon = nil,
				},
				display = {
					theme = 'catppuccin',
					flavor = 'dark',
					view = 'full',
					swap_fields = false,
					swap_icons = false,
				},
				timestamp = {
					enabled = true,
					reset_on_idle = false,
					reset_on_change = false,
				},
				idle = {
					enabled = false,
				},
				text = {
					default = '',
					viewing = 'Looking at codes',
					editing = 'Editing ${filename}',
					file_browser = 'Browsing files',
					dashboard = 'Vibing',
				},
				variables = true, -- Enable string templates
				advanced = {
					workspace = {
						root_markers = {
							'.git',
							'.hg',
							'.svn',
						},
						limit_to_cwd = false,
					},
					server = {
						update = 'none',
						auto_update = false,
					},
				},
				buttons = {
					{
						label = 'View Repository',
						url = function(opts) return opts.repo_url end,
					},
				},
			}
		end,
	}
}

-- allows setting kemaps and such for each lsp instance
local function lsp_on_attach(client, bufnr)
	local nmap = function(keys, func, desc)
		if desc then
			desc = 'LSP: ' .. desc
		end
		map('n', keys, func, { buffer = bufnr, desc = desc })
	end

	-- enable autocomplete
	-- vim.lsp.completion.enable(true, client.id, bufnr, {
	-- 	autotrigger = true
	-- })

	-- set mappings
	nmap("gd", vim.lsp.buf.definition, "Goto Definition")
	nmap("<leader>lws", vim.lsp.buf.workspace_symbol, "Workspace Symbols")
	nmap("<leader>ld", vim.diagnostic.open_float, "Language Diagnostic")

	nmap("[d", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Next Diagnostic")
	nmap("]d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Prev Diagnostic")

	nmap('<leader>lf', vim.lsp.buf.format)

	nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
	vim.keymap.set({ "n", "i" }, "<C-h>", vim.lsp.buf.signature_help,
		{ buffer = bufnr, desc = "Signature Documentation" })
end

require('lze').register_handlers(require('lzextras').lsp)

-- also replace the fallback filetype list retrieval function with a slightly faster one
require('lze').h.lsp.set_ft_fallback(function(name)
	return dofile(nixCats.pawsible({ "allPlugins", "opt", "nvim-lspconfig" }) .. "/lsp/" .. name .. ".lua").filetypes or
		{}
end)

require('lze').load {
	{
		"nvim-lspconfig",
		enabled = nixCats("general") or false,
		-- the on require handler will be needed here if you want to use the
		-- fallback method of getting filetypes if you don't provide any
		on_require = { "lspconfig" },
		-- define a function to run over all type(plugin.lsp) == table
		-- when their filetype trigger loads them
		lsp = function(plugin)
			vim.lsp.config(plugin.name, plugin.lsp or {})
			vim.lsp.enable(plugin.name)
		end,
		before = function(_)
			-- makes it so that nvim-lspconfig doesn't override this getting called
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if not client then
						return
					end
					lsp_on_attach(client, args.buf)
				end,
			})
			-- vim.lsp.config('*', {
			-- 	on_attach = lsp_on_attach,
			-- })
		end,
	},
	{ "lua_ls",   enabled = nixCats('lua') or false,   lsp = {} },
	{ "clangd", enabled = nixCats("cpp") or false, lsp = {
		cmd = { 'clangd', '--background-index', "--clang-tidy" }
	} },
	{ "rust_analyzer", enabled = nixCats("rust") or false, lsp = {
		settings = {
			["rust-analyzer"] = {
				check = {
					command = "clippy",
				},
				cargo = {
					buildScripts = {
						enable = true,
					},
				},
				procMacro = {
					enable = true,
				}
			}
		}
	} },
	{ "tinymist", enabled = nixCats("typst") or false, lsp = {} },
	{ "qmlls",    enabled = nixCats("qml") or false,   lsp = {} },
	{ "nixd",
		enabled = nixCats('nix') or false,
		lsp = {
			filetypes = { 'nix' },
			settings = {
				nixd = {
					nixpkgs = {
						expr = nixCats.extra("nixdExtras.nixpkgs") or [[import <nixpkgs> {}]],
					},
					options = {
						nixos = { expr = nixCats.extra("nixdExtras.nixos_options") },
						["home-manager"] = { expr = nixCats.extra("nixdExtras.home_manager_options") }
					},
					formatting = { command = { "alejandra" } },
					diagnostic = { suppress = { "sema-escaping-with" } }
				}
			},
		},
	},
}

-- options for autocompletion
-- vim.opt.completeopt = { "menuone", "noinsert", "popup" }
