-- @module plugin_config.comment
local comment = {}

local c = require("Comment")
local ft = require("Comment.ft")

function comment.configure()
	c.setup()

	-- override the default gitconfig comment string
	-- (the default is also correct, this is just personal preference)
	ft.gitconfig = { "# %s" }
end

return comment
