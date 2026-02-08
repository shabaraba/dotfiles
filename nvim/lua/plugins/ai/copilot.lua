return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  config = function(_, opts)
    require("copilot").setup(opts)
    vim.keymap.set("i", "<C-l>", function()
      require("copilot.suggestion").accept()
    end, { desc = "[copilot] accept suggestion" })
  end,
  opts = {
    panel = {
      enabled = true,
      auto_refresh = true,
      keymap = {
        jump_prev = "[[",
        jump_next = "]]",
        accept = "<CR>",
        refresh = "gr",
        open = "<M-CR>"
      },
      layout = {
        position = "bottom",
        ratio = 0.4
      },
    },
    suggestion = {
      enabled = true,
      auto_trigger = true,
      hide_during_completion = true,
      debounce = 75,
      keymap = {
        accept = false,
        accept_word = false,
        accept_line = false,
        next = false,
        prev = false,
        dismiss = false,
      },
    },
    should_attach = function(bufnr, bufname)
      local filetype = vim.bo[bufnr].filetype
      if filetype == "vibing" then
        return true
      end
      -- if not vim.bo[bufnr].buflisted then
      --   return false
      -- end
      local buftype = vim.bo[bufnr].buftype
      if buftype ~= "" and buftype ~= "acwrite" then
        return false
      end
      return true
    end,
    filetypes = {
      yaml = true,
      markdown = true,
      help = false,
      gitcommit = true,
      gitrebase = true,
      hgcommit = false,
      svn = false,
      cvs = false,
      vibing = true,
      ["."] = true,
    },
    copilot_node_command = 'node',
    server_opts_overrides = {},

  }
}
