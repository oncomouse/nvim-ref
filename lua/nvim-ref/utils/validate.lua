local M = {}

-- Adapted from mini.nvim
M.error = function(msg) error('[nvim-ref] ' .. msg, 0) end

M.check_type = function(name, val, ref, allow_nil)
  if type(val) == ref or (ref == 'callable' and vim.is_callable(val)) or (allow_nil and val == nil) then return end
  M.error(string.format('`%s` should be %s, not %s', name, ref, type(val)))
end
-- end adapted code

return M
