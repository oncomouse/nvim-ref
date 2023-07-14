local has_lspize, Lsp = pcall(require,"lspize")

if not has_lspize then
	return nil
end

local make_item = require("nvim-ref.utils.lsp").make_lsp_item

local handlers = {
	[Lsp.methods.COMPLETION] = function(params, callback)
		local start = require("nvim-ref.filetypes").find_start()
		vim.print(start)
		if start == nil then
			callback(nil)
			return
		end
		start = start + 1
		local line = vim.api.nvim_get_current_line()

		local results = require("nvim-ref.bibliography").query(line:sub(start, params.position.character))

		local items = {}
		for _, item in ipairs(results) do
			table.insert(items, make_item(item))
		end

		-- For some reason this throws an E565, but it works if we wrap it
		-- in a pcall. No idea, why:
		pcall(callback, nil, { isIncomplete = #items, items = items })
	end,
	[Lsp.methods.HOVER] = function(_, callback)
		local cword = vim.fn.expand("<cword>")

		-- Strip off pandoc @ from citekey, if present:
		if string.match(cword, "^@") then
			cword = string.sub(cword, 2)
		end

		local results = require("nvim-ref.bibliography").query(cword)
		if #results > 0 and results[1].key == cword then
			callback(nil, { contents = require("nvim-ref.utils.lsp").get_markdown_documentation(results[1]) })
		else
			callback()
		end
	end,
	[Lsp.methods.DEFINITION] = function(_, callback)
		callback()
	end,
}

return Lsp:new(handlers)
