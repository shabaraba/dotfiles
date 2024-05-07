local vim = vim
local utils = require "core.utils"

local config = utils.load_config()
local map = utils.map

local cmd = vim.cmd

local M = {}

-- these mappings will only be called during initialization
M.misc = function()
  -- Don't copy the replaced text after pasting in visual mode
  map("v", "p", '"_dP')

  -- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
  -- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
  -- empty mode is same as using :map
  -- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
  map("", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
  map("", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
  map("", "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
  map("", "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })

  -- use ESC to turn off search highlighting
  map("n", "<Esc>", ":noh <CR>")

  -- center cursor when moving (goto_definition)

  -- yank from current cursor to end of line
  map("n", "Y", "yg$")

  map('n', 'j', 'gj', {noremap = true})
  map('n', 'k', 'gk', {noremap = true})

  map('i', 'jj', '<Esc>', {noremap = true})
  map('n', '9', '$', {noremap = true})
  map('n', '}', '%', {noremap = true})
  map('n', '{', '%', {noremap = true})
  map('n', '<Esc><Esc>', ':nohlsearch<CR><Esc>', {noremap = false})
  map('i', '<C-b>', '<Left>', {noremap = true})
  map('i', '<C-f>', '<Right>', {noremap = true})
  map('i', '<C-a>', '<Home>', {noremap = true})
  map('i', '<C-e>', '<End>', {noremap = true})

  map('n', '<C-j>', ':bp<CR>', {noremap = false})
  map('n', '<C-k>', ':bn<CR>', {noremap = false})

  map('t', '<Esc>', '<C-\\><C-n>', {noremap = true, silent = true})

  -- terminal mappings --
  -- get out of terminal mode
  map("t", { "jj" }, "<C-\\><C-n>")
  -- terminal mappings end --
end

-- below are all plugin related mappings

M.bufferline = function()
  map("n", "<C-k>", ":BufferLineCycleNext <CR>")
  map("n", "<C-j>", ":BufferLineCyclePrev <CR>")
end

M.comment = function()
  map("n", "<leader>/", ":lua require('Comment.api').toggle_current_linewise()<CR>")
  map("v", "<leader>/", ":lua require('Comment.api').toggle_linewise_op(vim.fn.visualmode())<CR>")
end

M.dashboard = function()
  map("n", "<leader>bm", ":DashboardJumpMarks <CR>")
  map("n", "<leader>wl", ":SessionLoad <CR>")
  map("n", "<leader>ws", ":SessionSave <CR>")
end

M.neotree = function()
  map("n", "<leader>b", ":Neotree toggle <CR>")
  map("n", "<leader>bg", ":Neotree git_status toggle <CR>")
  map("n", "<leader>t", ":Neotree buffers toggle <CR>")

  vim.cmd([[nnoremap \ :Neotree reveal<cr>]])
end

M.telescope = function()
  map("n", "<leader>fb", ":Telescope buffers <CR>")
  map("n", "<leader>ff", ":Telescope find_files <CR>")
  map("n", "<leader>fa", ":Telescope find_files follow=true no_ignore=true hidden=true <CR>")
  map("n", "<leader>cm", ":Telescope git_commits <CR>")
  map("n", "<leader>gt", ":Telescope git_status <CR>")
  map("n", "<leader>fh", ":Telescope help_tags <CR>")
  map("n", "<leader>fw", ":Telescope live_grep <CR>")
  map("n", "<leader>fo", ":Telescope oldfiles <CR>")
  map("n", "<leader>th", ":Telescope themes <CR>")

  map("n", "<C-]>", ":Telescope lsp_definitions<CR>")
  map("n", "<C-]><C-]>", ":Telescope lsp_references<CR>")
end

M.lsp = function()
  -- 2. build-in LSP function
  -- keyboard shortcut
  map('n', '<space>h',  '<cmd>lua vim.lsp.buf.hover()<CR>')
  map('n', 'gf', '<cmd>lua vim.lsp.buf.formatting()<CR>')
  map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
  map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  map('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
  map('n', 'gn', '<cmd>lua vim.lsp.buf.rename()<CR>')
  map('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>')
  map('n', 'ge', '<cmd>lua vim.diagnostic.open_float()<CR>')
  map('n', 'g]', '<cmd>lua vim.diagnostic.goto_next()<CR>')
  map('n', 'g[', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
  -- LSP handlers
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false }
  )
  -- Reference highlight
  vim.cmd [[
    set updatetime=500
    highlight LspReferenceText  cterm=underline ctermbg=8 gui=underline guibg=#104040
    highlight LspReferenceRead  cterm=underline ctermbg=8 gui=underline guibg=#104040
    highlight LspReferenceWrite cterm=underline ctermbg=8 gui=underline guibg=#104040

    augroup lsp_document_highlight
      autocmd!
      autocmd CursorHold,CursorHoldI * lua vim.lsp.buf.document_highlight()
      autocmd CursorMoved,CursorMovedI * lua vim.lsp.buf.clear_references()
    augroup END
  ]]
end

return M
