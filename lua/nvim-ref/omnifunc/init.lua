local function make_omni_item(citation)
	return {
		word = citation.key,
		info = require("nvim-ref.utils.lsp").get_markdown_documentation(citation),
		kind = "v",
	}
end

local function omnifunc(findstart, base)
	if findstart == 1 then
		local start = require("nvim-ref.filetypes").find_start()
		return start
	end
	local matches = require("nvim-ref.bibliography").query(base)
	local words = {}

	for _,citation in pairs(matches) do
		table.insert(words, make_omni_item(citation))
	end

	return {
		words = words,
		refresh = "always",
	}
end

return omnifunc
