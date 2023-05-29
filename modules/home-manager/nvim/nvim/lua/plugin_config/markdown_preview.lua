-- @module plugin_config.markdown_preview
local markdown_preview = {}

function markdown_preview.configure()
	vim.api.nvim_create_user_command("MP", "MarkdownPreview", {})
	-- vim.keymap.set("", "<leader>mp", ":MarkdownPreview<CR>", { noremap = true })
end

return markdown_preview
