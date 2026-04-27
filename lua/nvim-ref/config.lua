local check_type = require("nvim-ref.utils.validate").check_type
local default_config = {
  include_pagenumbers = false,
	bibfiles = {},
	commands = {
		"insert",
		"edit",
		"import",
	},
	filetypes = {
		"latex",
		"markdown",
		"org",
    "typst",
	},
	lsp = {},
}
local function config(opts)
  check_type("opts", opts, "table")
	if opts.bibfiles and type(opts.bibfiles) == "string" then
		opts.bibfiles = { opts.bibfiles }
	end
  check_type("opts.bibfiles", opts.bibfiles, "table")
  check_type("opts.include_pagenumbers", opts.include_pagenumbers, "boolean", true)
  check_type("opts.commands", opts.commands, "table", true)
  check_type("opts.filetypes", opts.filetypes, "table", true)
  check_type("opts.lsp", opts.lsp, "table", true)
	return vim.tbl_deep_extend("keep", opts, default_config)
end

return config
