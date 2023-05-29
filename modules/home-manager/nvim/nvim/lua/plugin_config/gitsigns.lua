-- @module plugin_config.gitsigns
local gitsigns = {}

local gs = require("gitsigns")

function gitsigns.configure()
	gs.setup()
end

return gitsigns
