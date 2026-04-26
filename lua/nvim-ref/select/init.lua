local M = {}
local check_type = require("nvim-ref.utils.validate").check_type

local function run_select(input, opts)
  check_type("opts", opts, "table", false)
  check_type("opts.cb", opts.cb, "callable", true)
  check_type("opts.prompt", opts.prompt, "string", true)
  check_type("opts.empty", opts.empty, "callable", true)
  check_type("opts.format", opts.format, "callable", true)

	local cb = opts.cb or function(_) end
	local empty = opts.empty or function(_) end
	local format = opts.format_item or function(x)
		return x
	end
	local prompt = opts.prompt or "Make a selection: "
	vim.ui.select(input, {
		prompt = prompt,
		format_item = format,
	}, function(choice)
		if not choice then
			empty(choice)
		else
			cb(choice)
		end
	end)
end

function M.citation(cb, query, opts)
	opts = opts or {
		prompt = "Select a citation: ",
	}
	local results = require("nvim-ref.bibliography").query(query or "")
	run_select(results, {
		prompt = opts.prompt,
		format_item = function(item)
			return string.format("@%s: %s - %s [%s]", item.key, item.author, item.title, item.kind)
		end,
		cb = cb,
	})
end

function M.bibliography(cb, opts)
	opts = opts or {
		prompt = "Select a bibilography: ",
	}
	local results = require("nvim-ref.bibliography").bibliographies
	run_select(results, {
		prompt = opts.prompt,
		format_item = function(item)
			local filename = vim.fn.fnamemodify(item, ":p")
			filename = vim.fn.pathshorten(filename)
			return filename
		end,
		cb = cb,
	})
end

return M
