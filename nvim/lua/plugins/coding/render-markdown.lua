return {
  'MeanderingProgrammer/render-markdown.nvim',
  ft = { 'markdown', 'vibing' },
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  config = function(_, opts)
    vim.api.nvim_set_hl(0, 'RenderMarkdownCodeInline', { link = 'Keyword' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownH2Bg', { bg = '#325967' })
    require('render-markdown').setup(opts)
  end,
  opts = {
    file_types = { 'markdown', 'vibing' },
    render_modes = { 'n', 'c' },
    anti_conceal = {
      enabled = false,
    },
    heading = {
      enabled = true,
      sign = false,
      icons = { '# ', '## ', '### ', '#### ', '##### ', '###### ' },
      backgrounds = { '', 'RenderMarkdownH2Bg', '', '', '', '' },
      width = 'block',
      above = '',
      below = '',
    },
    code = {
      enabled = true,
      sign = false,
      style = 'full',
      border = 'none',
      width = 'block',
      above = '',
      below = '',
      language_pad = 1,
      language_icon = true,
      language_name = true,
    },
    bullet = {
      enabled = true,
      icons = { '●', '○', '◆', '◇' },
    },
    checkbox = {
      enabled = true,
      unchecked = { icon = '☐ ' },
      checked = { icon = '✓ ' },
    },
    link = {
      enabled = true,
      hyperlink = '󰌹 ',
      wiki = { icon = '󱗖 ' },
    },
  },
}
