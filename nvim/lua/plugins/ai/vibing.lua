return {
  "shabaraba/vibing.nvim",
  dev = true,
  build = "./build.sh",
  ft = "vibing",
  cmd = { "VibingChat", "VibingInline", "VibingToggleChat" },
  keys = {
    -- Add your vibing keymaps here, for example:
    -- { "<leader>vc", "<cmd>VibingChat<cr>", desc = "Vibing Chat" },
    -- { "<leader>vi", "<cmd>VibingInline<cr>", desc = "Vibing Inline" },
  },
  config = function()
    require("vibing").setup({
      mcp = {
        enabled = true,
        rpc_port = 9876,
        auto_setup = true,
        auto_configure_claude_json = true
      },
      chat = {
        window = {
          position = "right",
          width = 0.4,
          border = "rounded",
        },
        auto_context = true,
        save_location_type = "project",
      },
      agent = {
        default_mode = "code",
        default_model = "sonnet",
      },
      permissions = {
        mode = "acceptEdits",
        allow = { "Read", "Edit", "Write", "Glob", "Grep", "Bash" },
        deny = {},
      },
      preview = {
        enabled = true
      },
      language = {
        default = "ja",
        chat = "ja",
        inline = "ja",
      },
      keymaps = {
        send = "<CR>",
        cancel = "<C-c>",
        add_context = "<C-a>",
      },
    })
  end,
}
