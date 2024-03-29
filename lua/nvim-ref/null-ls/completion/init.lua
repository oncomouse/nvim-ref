-- BibTeX citation completion. This needs iskeyword to match "@", so you have to set
--   vim.opt_local.iskeyword = vim.opt_local.iskeyword + "@-@"
-- or
--   setlocal iskeyword += @-@
-- Somewhere in an ftplugin/markdown.vim file (or with an autocmd)
local h = require("null-ls.helpers")
local methods = require("null-ls.methods")

local COMPLETION = methods.internal.COMPLETION

local make_item = require("nvim-ref.utils.lsp").make_lsp_item

if not NvimRef.has_lpeg_bibtex then
	return function()
		return nil
	end
end

return h.make_builtin({
	method = COMPLETION,
	filetypes = vim.tbl_keys(NvimRef.filetypes),
	name = "nvim-ref",
	generator = {
		fn = function(params, done)
			if require("nvim-ref.filetypes").find_start() == nil then
				done({ { items = {}, isIncomplete = false } })
				return
			end

			local results = require("nvim-ref.bibliography").query(params.word_to_complete)

			local items = {}
			for _, item in ipairs(results) do
				table.insert(items, make_item(item))
			end
			done({ { items = items, isIncomplete = #items } })
		end,
		async = true,
	},
})
