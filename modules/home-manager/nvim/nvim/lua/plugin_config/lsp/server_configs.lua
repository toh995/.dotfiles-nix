-- @module plugin_config.lsp.server_configs
local server_configs = {}

local builtin = require("telescope.builtin")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local lspconfig = require("lspconfig")

local capabilities = cmp_nvim_lsp.default_capabilities()

local function set_lsp_keybindings(_, bufnr)
	vim.keymap.set("", "<leader>gd", builtin.lsp_definitions, { noremap = true, buffer = bufnr })
	vim.keymap.set("", "<leader>gr", builtin.lsp_references, { noremap = true, buffer = bufnr })
	-- vim.keymap.set("", "<leader>gd", vim.lsp.buf.definition, { noremap = true, buffer = bufnr })
	-- vim.keymap.set("", "<leader>gr", vim.lsp.buf.references, { noremap = true, buffer = bufnr })
	vim.keymap.set("", "<leader>rn", vim.lsp.buf.rename, { noremap = true, buffer = bufnr })
	vim.keymap.set("", "<leader>k", vim.lsp.buf.hover, { noremap = true, buffer = bufnr })
	vim.keymap.set("", "<leader>d", vim.diagnostic.open_float, { noremap = true })
end

function server_configs.configure()
	---------
	-- CSS --
	---------
	lspconfig.cssls.setup({
		capabilities = capabilities,
		on_attach = set_lsp_keybindings,
	})

	-----------
	-- Ember --
	-----------
	lspconfig.ember.setup({
		capabilities = capabilities,
		on_attach = set_lsp_keybindings,
	})

	-------------
	-- ES Lint --
	-------------
	lspconfig.eslint.setup({
		capabilities = capabilities,
		on_attach = set_lsp_keybindings,
	})

	-----------
	-- GLint --
	-----------
	lspconfig.glint.setup({
		capabilities = capabilities,
		on_attach = set_lsp_keybindings,
	})

	-------------
	-- Haskell --
	-------------
	lspconfig.hls.setup({})

	----------
	-- HTML --
	----------
	lspconfig.html.setup({
		capabilities = capabilities,
		on_attach = set_lsp_keybindings,
		filetypes = { "html", "handlebars" },
	})

	---------
	-- Lua --
	---------
	lspconfig.lua_ls.setup({
		capabilities = capabilities,
		on_attach = set_lsp_keybindings,
		settings = {
			Lua = {
				runtime = {
					-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
					version = "LuaJIT",
				},
				diagnostics = {
					-- Get the language server to recognize the `vim` global
					globals = { "vim" },
				},
				workspace = {
					-- Make the server aware of Neovim runtime files
					library = vim.api.nvim_get_runtime_file("", true),
					checkThirdParty = false,
				},
				telemetry = {
					-- Do not send telemetry data containing a randomized but unique identifier
					enable = false,
				},
			},
		},
	})

	---------------------------
	-- TypeScript/JavaScript --
	---------------------------
	lspconfig.tsserver.setup({
		capabilities = capabilities,
		on_attach = set_lsp_keybindings,
	})
end

return server_configs
