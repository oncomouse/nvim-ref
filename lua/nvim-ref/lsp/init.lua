local lspMethods = require("nvim-ref.lsp.methods")
local make_item = require("nvim-ref.utils.lsp").make_lsp_item

local handlers = {
	[lspMethods.lsp.INITIALIZE] = function(_, callback)
		callback(nil, {
			capabilities = {
				completionProvider = {
					resolveProvider = false,
					completionItem = {
						labelDetailsSupport = true,
					},
				},
				hoverProvider = true,
				definitionProvider = true,
			},
		})
	end,
	[lspMethods.lsp.COMPLETION] = function(params, callback)
		local start = require("nvim-ref.filetypes").find_start()
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
		callback(nil, items)
	end,
	[lspMethods.lsp.HOVER] = function(_, callback)
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
	[lspMethods.lsp.DEFINITION] = function(_, callback)
		callback()
	end,
}
setmetatable(handlers, {
	__index = function()
		return function(_, callback)
			callback(nil, {})
		end
	end,
})

local server = function(dispatchers)
	local closing = false
	return {
		request = function(method, params, callback)
			handlers[method](params, callback)
		end,
		notify = function(...) end,
		is_closing = function()
			return closing
		end,
		terminate = function()
			if not closing then
				closing = true
				dispatchers.on_exit(0, 0)
			end
		end,
	}
end

vim.lsp.start({ name = "nvim-ref", cmd = server, on_attach = NvimRef.config.lsp.on_attach })
