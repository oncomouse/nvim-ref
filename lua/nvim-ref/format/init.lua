local M = {}

function M.get_ref(citation)
	return require("nvim-ref.filetypes").ref(citation)
end

function M.get_citation(citation, page_number)
	return require("nvim-ref.filetypes").citation(citation, page_number)
end

return M
