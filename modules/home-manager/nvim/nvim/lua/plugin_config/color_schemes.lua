-- @module plugin_config.color_scheme
local color_schemes = {}

local vscode = require("vscode")

function color_schemes.configure()
	vscode.setup({})
	vscode.load()
end

return color_schemes
