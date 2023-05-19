local h = require("null-ls.helpers")
local methods = require("null-ls.methods")

local HOVER = methods.internal.HOVER

if not NvimRef.has_lpeg_bibtex then
	return function()
		return nil
	end
end

return h.make_builtin({
	method = HOVER,
	filetypes = vim.tbl_keys(NvimRef.filetypes),
	name = "nvim-ref",
	generator = {
		fn = function(_, done)
			local cword = vim.fn.expand("<cword>")

			-- Strip off pandoc @ from citekey, if present:
			if string.match(cword, "^@") then
				cword = string.sub(cword, 2)
			end

			local results = require("nvim-ref.bibliography").query(cword)
			if #results > 0 and results[1].key == cword then
				done({ require("nvim-ref.utils.lsp").get_markdown_documentation(results[1]) })
			else
				done()
			end
		end,
		async = true,
	},
})
