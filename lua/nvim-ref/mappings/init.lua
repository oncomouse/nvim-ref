local hooks = require("nvim-ref.hooks")

local M = {}

hooks.listen("filetype", function(_)
	for _, map in ipairs(NvimRef.config.mappings or {}) do
		local mode = type(map.mode) == "table" and map.mode or { map.mode }
		local command
		if type(map.command) == "function" then
			command = map.command
		else
			command = string.format("%s<Cmd>NvimRef %s<CR>", vim.tbl_contains(mode, "i") and "<ESC>" or "", map.command)
		end
		local opts = vim.tbl_deep_extend("keep", { buf = 0 }, map.opts or {})
		vim.keymap.set(mode, map.lhs, command, opts)
	end
end)

return M
