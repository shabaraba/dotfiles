local vim = vim
local utils = require "core.utils"
local map = utils.map

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

M.dashboard = {
  { "<leader>bm", ":DashboardJumpMarks <cr>" },
  { "<leader>wl", ":SessionLoad <cr>" },
  { "<leader>ws", ":SessionSave <cr>" },
}

M.neotree = {
  { "<leader>b", ":Neotree toggle <cr>" },
  { "<leader>bf", ":Neotree reveal  <cr>" },
  { "<leader>t", ":Neotree buffers toggle <cr>" },
  { "<leader>bg", ":Neotree git_status toggle <cr>" },
  { "<leader>bs", ":Neotree document_symbols toggle <cr>" },
}

M.telescope = {
  { "<leader>fb", ":Telescope buffers <cr>" },
  { "<leader>ff", ":Telescope find_files <cr>" },
  { "<leader>fa", ":Telescope find_files follow=true no_ignore=true hidden=true <cr>" },
  { "<leader>cm", ":Telescope git_commits <cr>" },
  { "<leader>gt", ":Telescope git_status <cr>" },
  { "<leader>fh", ":Telescope help_tags <cr>" },
  { "<leader>fw", ":Telescope live_grep <cr>" },
  { "<leader>fo", ":Telescope oldfiles <cr>" },
  { "<leader>th", ":Telescope themes <cr>" },

  { "<C-]>", ":Telescope lsp_definitions<cr>" },
  { "<C-]><C-]>", ":Telescope lsp_references<cr>" },
}

M.lsp = {
  { 'gh', '<cmd>lua vim.lsp.buf.hover()<cr>' },
  { 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>' },
  { 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>' },
  { 'gt', '<cmd>lua vim.lsp.buf.type_definition()<cr>' },
  { 'gn', '<cmd>lua vim.lsp.buf.rename()<cr>' },
  { 'ga', '<cmd>lua vim.lsp.buf.code_action()<cr>' },
  { 'ge', '<cmd>lua vim.diagnostic.open_float()<cr>' },
  { 'g]', '<cmd>lua vim.diagnostic.goto_next()<cr>' },
  { 'g[', '<cmd>lua vim.diagnostic.goto_prev()<cr>' },
}

M.none_ls = {
  { 'gf', '<cmd>lua vim.lsp.buf.format()<cr>' },
}

M.neogen = {
    {
      "<leader>cc",
      function()
        require("neogen").generate({})
      end,
      desc = "Neogen Comment",
    },
}

M.refactoring = {
    {
      "<leader>r",
      function()
        require("refactoring").select_refactor()
      end,
      mode = "v",
      noremap = true,
      silent = true,
      expr = false,
    },
}

M.hop = {
  {'s', '<cmd>HopChar2<cr>'}
}

return M
