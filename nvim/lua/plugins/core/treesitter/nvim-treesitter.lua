return {
  "nvim-treesitter/nvim-treesitter",
  event = "BufRead",
  config = function()
    local present, ts_config = pcall(require, "nvim-treesitter.configs")

    if not present then
        return
    end

    ts_config.setup {
        ensure_installed = 'all',
        auto_install = true,
        highlight = {
            enable = true,
        },
        indent = {
            enable = true,
        },
    }
  end
}

