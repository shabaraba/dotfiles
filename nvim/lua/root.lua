local core_modules = {
   "options",
   "mappings",
}

for _, module in ipairs(core_modules) do
   local ok, err = pcall(require, module)
   if not ok then
      error("Error loading " .. module .. "\n\n" .. err)
   end
end

vim.g.python3_host_prog = vim.fn.expand('~/.config/nvim/env/bin/python')

require("core")
require("plugins")
-- non plugin mappings
require("mappings").misc()
