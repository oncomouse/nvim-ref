local M = {}

function M.setmetatable(table)
	return setmetatable(table, {
    __index = {
      find_start = function()
					return require("nvim-ref.filetypes").find_start(t.start_pattern or [[\k\+]])
				end
    },
	})
end
return M
