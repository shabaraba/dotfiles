local core_modules = {
   "core.fix-deprecated",
   "core.autocmds",
}

for _, module in ipairs(core_modules) do
   local ok, err = pcall(require, module)
   if not ok then
      error("Error loading " .. module .. "\n\n" .. err)
   elseif module == "core.fix-deprecated" then
      -- fix-deprecated のsetup関数を呼び出し
      require(module).setup()
   end
end


