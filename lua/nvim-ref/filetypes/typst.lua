---@type FileTypeLibrary
local M = {}

function M.ref(citation)
	return "@" .. citation.key
end

function M.citation(citation)
	return {
		before = "#cite(<" .. citation.key,
		after = ">)"
	}
end

M.start_pattern = [[@\k*\%#]]

function M.find_bibliography(bufnum)
	bufnum = bufnum or 0
	local lines = require("nvim-ref.utils.file").get_buffer_lines(bufnum)
	local bibliographies = {}
	for _, line in pairs(lines) do
		if string.match(line, "^#bibliography") then
      local file = string.match(line, "bibliography%(%\"([^\"]+)")
			table.insert(bibliographies, vim.fn.fnamemodify(string.gsub(file, '"', ""), ":p"))
		end
	end
	return bibliographies
end

function M.setup()
	require("nvim-ref.hooks").trigger("add_filetype", {
    no_global = true,
		type = "typst",
	})
end

return require("nvim-ref.filetypes.utils").setmetatable(M)
