return {
  "mfussenegger/nvim-dap",
  lazy = true,
  keys = {
    { "<F5>", ":DapContinue<CR>", desc = "Debug: Start/Continue" },
    { "<F10>", ":DapStepOver<CR>", desc = "Debug: Step Over" },
    { "<F11>", ":DapStepInto<CR>", desc = "Debug: Step Into" },
    { "<F12>", ":DapStepOut<CR>", desc = "Debug: Step Out" },
    { "<leader>b", ":DapToggleBreakpoint<CR>", desc = "Debug: Toggle Breakpoint" },
  },
  config = function()
    local dap = require("dap")
    
    -- UI improvements
    vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "Error", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "Error", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "→", texthl = "Success", linehl = "DiffAdd", numhl = "" })
    
    -- Configure adapters here as needed
  end
}