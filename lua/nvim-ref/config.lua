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
	if opts.bibfiles and type(opts.bibfiles) == "string" then
		opts.bibfiles = { opts.bibfiles }
	end
	return vim.tbl_deep_extend("keep", opts, default_config)
end

return config
