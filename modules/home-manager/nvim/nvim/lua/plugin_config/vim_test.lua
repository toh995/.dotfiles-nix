-- @module plugin_config.vim_test
local vim_test = {}

function vim_test.configure()
	-- setup
	vim.g["test#strategy"] = "vimux"
	vim.g["test#javascript#mocha#executable"] = "mocha"

	-- keybindings
	vim.keymap.set("", "<leader>t", ":TestNearest<CR>", { noremap = true })
	vim.keymap.set("", "<leader>T", ":TestFile<CR>", { noremap = true })
end

return vim_test
