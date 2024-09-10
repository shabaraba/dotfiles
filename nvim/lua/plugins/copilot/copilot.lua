local vim = vim;

return {
  "github/copilot.vim",
  event = "InsertEnter",
  config = function()
    vim.g.copilot_filetypes = { markdown = true, gitcommit = true, yaml = true }
  end,
  -- cmd = "Copilot",
  -- build = ":Copilot auth",
  -- opts = {
  --   suggestion = { enabled = false },
  --   panel = { enabled = false },
  --   filetypes = {
  --     markdown = true,
  --     help = true,
  --   },
  -- },
}
