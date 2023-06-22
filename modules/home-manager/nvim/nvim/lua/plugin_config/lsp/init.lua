-- @module plugin_config.lsp
local lsp = {}

local cmp = require("cmp")
local lspkind = require("lspkind")
local luasnip = require("luasnip")
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local mason_null_ls = require("mason-null-ls")
local null_ls = require("null-ls")

local server_configs = require("plugin_config.lsp.server_configs")

local configure_autocomplete
local configure_null_ls

function lsp.configure()
	-- Set up mason FIRST
	--
	-- NOTE: if BOTH:
	--   - You use NixOS
	--   - You use mason to install stuff
	-- then, the below code will break.
	--
	-- To avoid this, use nix to install stuff.
	mason.setup()
	mason_lspconfig.setup({ automatic_installation = false }) -- NOTE: would love to set this to true someday! Not working as of 2022-11-13

	configure_autocomplete()
	configure_null_ls()
	server_configs.configure()
end

function configure_autocomplete()
	if cmp == nil then
		return
	else
		cmp.setup({
			sources = {
				{ name = "buffer" },
				{ name = "luasnip" },
				{ name = "nvim_lsp" },
				{ name = "nvim_lsp_signature_help" },
				{ name = "path" },
			},
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<CR>"] = cmp.mapping.confirm({ select = true }),
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
			formatting = {
				format = lspkind.cmp_format({
					mode = "symbol",
					maxwidth = 50,
					ellipsis_char = "...",
					menu = {
						buffer = "[Buffer]",
						nvim_lsp = "[LSP]",
						luasnip = "[LuaSnip]",
						nvim_lua = "[Lua]",
						latex_symbols = "[Latex]",
					},
				}),
			},
		})
	end
end

function configure_null_ls()
	local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
	null_ls.setup({
		sources = {
			-- Lua
			null_ls.builtins.formatting.stylua,

			-- Python
			null_ls.builtins.formatting.black,
			null_ls.builtins.formatting.ruff,

			-- JS, TS, HTML
			-- List eslint LAST, to ensure it takes precedence over prettier
			null_ls.builtins.formatting.prettierd.with({
				disabled_filetypes = { "markdown", "yaml" },
			}),
			null_ls.builtins.formatting.eslint_d.with({
				extra_args = { "--report-unused-disable-directives", "--fix" },
			}),
		},
		on_attach = function(client, bufnr)
			if client.supports_method("textDocument/formatting") then
				vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = augroup,
					buffer = bufnr,
					callback = function()
						vim.lsp.buf.format({
							bufnr = bufnr,
							filter = function(c)
								return c.name == "null-ls"
							end,
						})
					end,
				})
			end
		end,
	})

	mason_null_ls.setup({ automatic_installation = false }) -- NOTE: would love to set this to true someday! Not working as of 2022-11-13
end

return lsp
