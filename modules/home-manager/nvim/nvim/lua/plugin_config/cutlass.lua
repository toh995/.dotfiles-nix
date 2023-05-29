-- @module plugin_config.cutlass
local cutlass = {}

local c = require("cutlass")

function cutlass.configure()
	c.setup({})

	-- set up the "m" cut key
	-- use vimscript for now...
	-- it's faster than `vim.keymap.set()`
	vim.cmd([[nnoremap m d]])
	vim.cmd([[xnoremap m d]])
	vim.cmd([[nnoremap mm dd]])
	vim.cmd([[nnoremap M D]])

	-- extra keymap for pasting, while in visual mode...
	vim.cmd([[xnoremap <silent> p p:let @+=@0<CR>:let @"=@0<CR>]])
end

return cutlass
