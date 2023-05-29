-- @module plugin_config.nvim_ts_autotag
local nvim_ts_autotag = {}

local autotag = require("nvim-ts-autotag")

function nvim_ts_autotag.configure()
	autotag.setup()
end

return nvim_ts_autotag
