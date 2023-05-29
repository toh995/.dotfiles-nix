-- always open help files in a vertical split on the far-right
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
	command = "wincmd L",
	pattern = { "<buffer>" },
})
