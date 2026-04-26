local hooks = require("nvim-ref.hooks")

local M = {}

hooks.listen("filetype", function(_)
	for _, map in ipairs(NvimRef.config.mappings or {}) do
		local mode = type(map[1]) == "table" and map[1] or { map[1] }
		local command
		if type(map[3]) == "function" then
			command = map[3]
		else
			command = string.format("%s<Cmd>NvimRef %s<CR>", vim.tbl_contains(mode, "i") and "<ESC>" or "", map[3])
		end
		local opts = vim.tbl_deep_extend("keep", { buf = 0 }, map[4] or {})
		vim.keymap.set(mode, map[2], command, opts)
	end
end)

return M
