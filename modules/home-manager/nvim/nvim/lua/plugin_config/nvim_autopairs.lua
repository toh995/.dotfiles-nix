-- @module plugin_config.nvim_autopairs
local nvim_autopairs = {}

local na = require("nvim-autopairs")

function nvim_autopairs.configure()
	na.setup({})
end

return nvim_autopairs
