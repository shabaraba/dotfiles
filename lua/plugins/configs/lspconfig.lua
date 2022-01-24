local M = {}

M.setup = function()
    require("core.utils").packer_lazy_load "nvim-lspconfig"
    -- reload the current file so lsp actually starts for it
    vim.defer_fn(function()
        vim.cmd 'if &ft == "packer" | echo "" | else | silent! e %'
    end, 0)
end

require("plugins.configs.others").lsp_handlers()

local function on_attach(_, bufnr)
   local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    require("core.mappings").lspconfig()
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        "documentation",
        "detail",
        "additionalTextEdits",
    },
}

-- requires a file containing user's lspconfigs
local addlsp_confs = require("core.utils").load_config().plugins.options.lspconfig.setup_lspconf

if #addlsp_confs ~= 0 then
    require(addlsp_confs).setup_lsp(on_attach, capabilities)
end

-----------------
-- setting server
-----------------
local lsp_installer = require "nvim-lsp-installer"

-- Include the servers you want to have installed by default below
local servers = {
  "bashls",
  "intelephense",
}

for _, name in pairs(servers) do
  local server_is_found, server = lsp_installer.get_server(name)
  if server_is_found and not server:is_installed() then
    print("Installing " .. name)
    server:install()
  end
end

require('lspconfig').intelephense.setup({on_attach = on_attach})
