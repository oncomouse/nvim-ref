---@type FileTypeLibrary
local M = {}

function M.ref(citation)
	return "@" .. citation.key
end

function M.citation(citation)
	return {
		before = "#cite(<" .. citation.key
		after = ">)",
	}
end

M.start_pattern = [[@\k*\%#]]

function M.setup()
	require("nvim-ref.hooks").trigger("add_filetype", {
		type = "typst",
	})
end

return require("nvim-ref.filetypes.utils").setmetatable(M)
