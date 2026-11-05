return {
  '3rd/diagram.nvim',
  ft = { 'markdown', 'vibing' },
  dependencies = {
    {
      '3rd/image.nvim',
      opts = {
        backend = 'kitty',
        processor = 'magick_cli',
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
        require('diagram').show_diagram_hover()
      end,
      ft = { 'markdown', 'vibing' },
      desc = 'Show diagram in new tab',
    },
  },
  config = function()
    local markdown = require('diagram.integrations.markdown')
    require('diagram').setup({
      integrations = {
        vim.tbl_extend('force', markdown, { filetypes = { 'markdown', 'vibing' } }),
      },
      events = {
        render_buffer = {},
        clear_buffer = {},
      },
    })
  end,
}
