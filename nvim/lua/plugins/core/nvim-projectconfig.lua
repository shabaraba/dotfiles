return {
  "windwp/nvim-projectconfig",
  lazy = false,
  config = function()
    require('nvim-projectconfig').setup()
  end
}