return {
  "rcarriga/nvim-dap-ui",
  lazy = true,
  dependencies = { "mfussenegger/nvim-dap" },
  keys = {
    { "<leader>du", ":lua require('dapui').toggle()<CR>", desc = "Debug: Toggle UI" },
  },
  config = function()
    require("dapui").setup()
    
    local dap = require("dap")
    local dapui = require("dapui")
    
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end
  end
}