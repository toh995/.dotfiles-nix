-- @module plugin_config
local plugin_config = {}

local is_packer_installed
local get_packer_install_path
local bootstrap_packer
local init_packer

function plugin_config.configure()
	local should_bootstrap = is_packer_installed()
	if should_bootstrap then
		bootstrap_packer()
	end

	init_packer()

	if should_bootstrap then
		-- sync, then skip the rest of the setup
		local packer = require("packer")
		packer.sync()
		return
	end

	-- plugin-specific setup
	-- we need to configure the color schemes FIRST,
	-- so that the rest of the plugins have knowledge of it.
	-- the rest of the plugings are configured in
	-- alphabetical order
	require("plugin_config.color_schemes").configure()

	require("plugin_config.bufferline").configure()
	require("plugin_config.comment").configure()
	require("plugin_config.cutlass").configure()
	require("plugin_config.git_blame").configure()
	require("plugin_config.gitsigns").configure()
	require("plugin_config.lsp").configure()
	require("plugin_config.markdown_preview").configure()
	require("plugin_config.nvim_autopairs").configure()
	require("plugin_config.nvim_tree").configure()
	require("plugin_config.nvim_treesitter").configure()
	require("plugin_config.nvim_ts_autotag").configure()
	require("plugin_config.telescope").configure()
	require("plugin_config.vim_test").configure()
end

function is_packer_installed()
	local install_path = get_packer_install_path()
	install_path = vim.fn.glob(install_path)
	return vim.fn.empty(install_path) > 0
end

function get_packer_install_path()
	return vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
end

function bootstrap_packer()
	local install_path = get_packer_install_path()
	vim.fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
	vim.cmd([[packadd packer.nvim]])
end

function init_packer()
	local packer = require("packer")
	packer.startup(function(use)
		-- package manager
		use("wbthomason/packer.nvim")

		-- LSP
		use("williamboman/mason.nvim")
		use("williamboman/mason-lspconfig.nvim")
		use("jayp0521/mason-null-ls.nvim")
		use("neovim/nvim-lspconfig")
		use({
			"jose-elias-alvarez/null-ls.nvim",
			requires = { "nvim-lua/plenary.nvim" },
		})

		-- autocomplete
		use("hrsh7th/nvim-cmp")
		use("hrsh7th/cmp-buffer")
		use("hrsh7th/cmp-nvim-lsp")
		use("hrsh7th/cmp-nvim-lsp-signature-help")
		use("hrsh7th/cmp-path")
		-- icons for autocomplete
		use("onsails/lspkind.nvim")

		-- snippets
		use("L3MON4D3/LuaSnip")
		use("saadparwaiz1/cmp_luasnip")

		-- file explorer
		use({
			"kyazdani42/nvim-tree.lua",
			requires = { "kyazdani42/nvim-web-devicons" },
			tag = "nightly", -- optional, updated every week. (see issue #1193)
		})

		-- fuzzy finder
		use({
			"nvim-telescope/telescope.nvim",
			requires = {
				"nvim-lua/plenary.nvim",
			},
			branch = "0.1.x",
		})

		-- tabs
		use({
			"akinsho/bufferline.nvim",
			tag = "v3.*",
			requires = "kyazdani42/nvim-web-devicons",
		})

		-- syntax highlighting
		use({
			"nvim-treesitter/nvim-treesitter",
			run = function()
				require("nvim-treesitter.install").update({ with_sync = true })
			end,
		})
		use("nvim-treesitter/nvim-treesitter-context")

		-- test runner
		use({
			"vim-test/vim-test",
			requires = {
				"preservim/vimux",
			},
		})

		-- Markdown preview
		use({
			"iamcco/markdown-preview.nvim",
			run = function()
				vim.fn["mkdp#util#install"]()
			end,
		})

		-- comment
		use("numToStr/Comment.nvim")

		-- vim surround
		use("tpope/vim-surround")

		-- cutlass
		use("gbprod/cutlass.nvim")

		-- autopairs
		use("windwp/nvim-autopairs")

		-- auto-close HTML tags
		use("windwp/nvim-ts-autotag")

		-- vim-tmux
		use("christoomey/vim-tmux-navigator")

		-- show git blame inline
		use("f-person/git-blame.nvim")

		-- colorized git status in the signs column
		use("lewis6991/gitsigns.nvim")

		-- Color schemes
		-- use "lunarvim/Onedarker.nvim"
		use("Mofiqul/vscode.nvim")

		-- editor config
		use("editorconfig/editorconfig-vim")
	end)
end

return plugin_config
