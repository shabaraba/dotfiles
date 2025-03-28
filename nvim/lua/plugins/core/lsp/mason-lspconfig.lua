local vim = vim

vim.cmd [[
  augroup zshAsBash
    autocmd!
    autocmd BufWinEnter *.zsh set filetype=sh
  augroup END
]]

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ctx)
    local set = vim.keymap.set
    local keymaps = require("mappings").lsp
    for _, v in pairs(keymaps) do
      set("n", v[1], v[2], { buffer = true })
    end
  end
})

vim.filetype.add({ extension = { mq5 = 'cpp', mqh = 'cpp' } })

return {
  "williamboman/mason-lspconfig.nvim",
  lazy = true,
  ft = {
    'lua',
    'typescript',
    'javascript',
    'php',
    'markdown',
    'vue',
    "typescriptreact",
    "javascriptreact",
    "java",
    "bash",
    "c",
    "cpp",
    "mq5",
    "mqh",
    "go"
  }, -- 対象のファイルタイプを指定
  opts = {
    ensure_installed = {
      "lua_ls",
      "ts_ls",
      "intelephense",
      "markdown_oxide",
      "volar",
      "jdtls",
      "eslint",
      "bashls",
      "gopls",
    },
    automatic_installation = false,
    handlers = {
      function(server_name)
        local lspconfig = require("lspconfig")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")
        local capabilities = cmp_nvim_lsp.default_capabilities()

        local on_attach = function(client, bufnr)
          vim.api.nvim_buf_set_option(bufnr, "formatexpr",
            "v:lua.vim.lsp.formatexpr(#{timeout_ms:250})")
        end

        local opts = {
          on_attach = on_attach,
          capabilities = capabilities,
          filetypes = {},
        }
        if server_name == "lua_ls" then
          opts.filetypes = { "lua" }
        elseif server_name == "eslint" then
          opts.filetypes = { "javascript", "javascriptreact" }
        elseif server_name == "ts_ls" then
          opts.filetypes = { "typescript", "typescriptreact" }
        elseif server_name == "intelephense" then
          opts.filetypes = { "php" }
        elseif server_name == "markdown_oxide" then
          opts.filetypes = { "markdown" }
        elseif server_name == "jdtls" then
          opts.filetypes = { "java" }
        elseif server_name == "bashls" then
          opts.filetypes = { "sh", "zsh", "bash" }
        elseif server_name == "clangd" then
          opts.filetypes = { "c", "cpp", "mq5", "mqh" }
        elseif server_name == "gopls" then
          opts.filetypes = { "go" }
        elseif server_name == "volar" then
          -- Function to get the current nodenv TypeScript path
          local function get_nodenv_tsdk()
            local handle = io.popen('nodenv root') -- Get the nodenv root path
            local nodenv_root = handle:read("*a"):gsub("\n", "")
            handle:close()

            -- Get the current active Node version
            handle = io.popen('nodenv version-name')
            local node_version = handle:read("*a"):gsub("\n", "")
            handle:close()

            -- Construct the tsdk path
            return nodenv_root .. '/versions/' .. node_version .. '/lib/node_modules/typescript/lib'
          end

          opts.filetypes = { "vue" }
          opts.init_options = {
            typescript = {
              -- You can point this to the local or global TypeScript server
              tsdk = get_nodenv_tsdk(),
            }
          }
        end

        lspconfig[server_name].setup(opts)
      end,
    }
  },
  keys = require("mappings").lsp,
}

-- dependencies = {
--   "neovim/nvim-lspconfig",
--   "nvim-lua/plenary.nvim",
--   "ray-x/lsp_signature.nvim",
-- },
