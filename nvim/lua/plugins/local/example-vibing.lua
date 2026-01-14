-- Example: Override vibing.nvim configuration for this machine
-- Copy this file to 'vibing.lua' (remove 'example-' prefix) and customize

return {
  "shabaraba/vibing.nvim",

  -- Example 1: Change RPC port
  -- opts = {
  --   mcp = {
  --     rpc_port = 9999,
  --   },
  -- },

  -- Example 2: Disable plugin on this machine
  -- enabled = false,

  -- Example 3: Override chat window position
  -- config = function()
  --   require("vibing").setup({
  --     chat = {
  --       window = {
  --         position = "left",  -- Change from "right" to "left"
  --       },
  --     },
  --   })
  -- end,

  -- Example 4: Add custom keymaps (merged with existing keys)
  -- keys = {
  --   {
  --     "<leader>vc",
  --     function() require("vibing").open_chat() end,
  --     desc = "Vibing: Custom Chat",
  --   },
  -- },
}
