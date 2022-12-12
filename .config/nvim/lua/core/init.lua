-- runtimepathを正す
vim.cmd[[
    if has("mac")
    else
        let $VIMRUNTIME="/usr/local/share/nvim/runtime"
        set runtimepath+=/usr/local/share/nvim/runtime
    endif
]]

local core_modules = {
   "core.options",
   "core.autocmds",
   "core.mappings",
}

for _, module in ipairs(core_modules) do
   local ok, err = pcall(require, module)
   if not ok then
      error("Error loading " .. module .. "\n\n" .. err)
   end
end

-- non plugin mappings
require("core.mappings").misc()

