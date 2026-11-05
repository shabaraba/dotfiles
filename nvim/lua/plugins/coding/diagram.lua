local filetypes = { 'markdown', 'vibing' }
local renderer_options = {
  mermaid = { scale = 3 },
}

local function markdown_integration()
  return vim.tbl_extend('force', require('diagram.integrations.markdown'), { filetypes = filetypes })
end

return {
  '3rd/diagram.nvim',
  ft = filetypes,
  dependencies = {
    {
      '3rd/image.nvim',
      opts = {
        backend = 'kitty',
        processor = 'magick_cli',
        max_height_window_percentage = 100,
        integrations = {
          markdown = { enabled = false },
          asciidoc = { enabled = false },
          typst = { enabled = false },
          neorg = { enabled = false },
          syslang = { enabled = false },
        },
      },
    },
  },
  keys = {
    {
      '<leader>d',
      function()
        require('utils.diagram_float').show(markdown_integration(), renderer_options)
      end,
      ft = filetypes,
      desc = 'Show diagram in float',
    },
  },
  config = function()
    require('diagram').setup({
      integrations = { markdown_integration() },
      renderer_options = renderer_options,
      events = {
        render_buffer = {},
        clear_buffer = {},
      },
    })
  end,
}
