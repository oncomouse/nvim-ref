local bibtex = require("nvim-ref.utils.bibtex")
local M = {}

-- Collect the various sources of sources:
local function gather_bibliographies()
	local bibfiles = {}
  -- Languages such as typst don't use a global bibliography, so we disable it:
  local no_global = require("nvim-ref.filetypes").filetypes[vim.bo.filetype].no_global
	bibfiles = require("nvim-ref.utils.table").append(
		bibfiles,
		(NvimRef.config.bibfiles and not no_global) and NvimRef.config.bibfiles or {},
		vim.b.nvim_ref_bibliographies or {}
	)
	return vim.tbl_filter(function(x)
		return vim.fn.filereadable(vim.fn.fnamemodify(x, ":p")) == 1
	end, bibfiles)
end

-- Wrapper for the bibliography parser:
function M.query(target)
	local bibliographies = gather_bibliographies()
	return #bibliographies == 0 and {} or bibtex.parser.query_bibtex(bibliographies, target)
end

function M.update(citation)
	bibtex.writer.update(citation)
end

setmetatable(M, {
	__index = function(_, idx)
		if idx == "bibliographies" then
			return gather_bibliographies()
		end
		return nil
	end,
})
return M
