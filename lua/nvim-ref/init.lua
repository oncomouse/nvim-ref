local config = require("nvim-ref.config")
local M = {}

-- Repeated code that loads commands, filetypes, etc.
-- TODO: Make loading defaults the responsibility of individual segments (filetype loads files, etc)
function load_defaults(obj, t)
	for _, cmd in pairs(obj) do
		local ok, command = pcall(require, "nvim-ref." .. t .. "." .. cmd)
		if not ok then
			ok, command = pcall(require, cmd)
			assert(ok, "Could not load default " .. t:gsub("s$", "") .. ", " .. cmd .. "!")
		else
			cmd = "nvim-ref." .. t .. "." .. cmd
		end
		assert(type(command.setup) == "function", "Could not call .setup() on " .. cmd .. " as it is not a function!")
		command.setup()
	end
end

function M.setup(opts)
	opts = opts or {}
	local first_file_opened = false
	M.has_lpeg_bibtex = pcall(require, "lpeg-bibtex")
	assert(M.has_lpeg_bibtex, [[You do not have lpeg-bibtex installed. Please run:

luarocks install --dev --lua-version=5.1 lpeg-bibtex --local

To get started using nvim-ref.]])

	if M.has_lpeg_bibtex then
		M.config = config(opts)
		M.hooks = require("nvim-ref.hooks")
		M.hooks.define("setup_done")
		M.filetypes = require("nvim-ref.filetypes").filetypes
		M.commands = {
			run = require("nvim-ref.commands").run,
		}
		-- Load all our commands when we first encounter a file:
		M.hooks.listen("filetype", function()
			if not first_file_opened then
				load_defaults(M.config.commands, "commands")
				-- If cmp is available, register the cmp source
				require("nvim-ref.cmp").register()
				first_file_opened = true
			end
		end)
		-- Boot up default filetypes:
		load_defaults(M.config.filetypes, "filetypes")
		M.hooks.trigger("setup_done")
	end
end

return M
