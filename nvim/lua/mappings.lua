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

M.dashboard = {}

M.neotree = {
  { "<leader><leader>", ":Neotree reveal toggle<cr>", desc = "Open FileSystem" },
  { "<leader>f", ":Neotree buffers toggle<cr>", desc = "Open Virtical Buffer" },
  { "<leader>g", ":Neotree git_status toggle<cr>", desc = "Open Git Status" },
  { "<leader>d", ":Neotree document_symbols toggle<cr>", desc = "Open Document Symbols" },
}

M.telescope = {
  { ";b", ":Telescope buffers <cr>", desc = "Telescope Buffer" },
  { ";f", ":Telescope find_files <cr>", desc = "Telescope find files "  },
  { ";fa", ":Telescope find_files follow=true no_ignore=true hidden=true <cr>", desc = "Telescope find all files"  },
  { ";gc", ":Telescope git_commits <cr>", desc = "Telescope Git Commits"  },
  { ";gs", ":Telescope git_status <cr>", desc = "Telescope Git Status"  },
  { ";h", ":Telescope help_tags <cr>", desc = "Telescope Tags"  },
  { ";w", ":Telescope live_grep <cr>", desc = "Telescope Live Grep"  },
  { ";o", ":Telescope oldfiles <cr>", desc = "Telescope Old Files"  },
  { ";c", ":Telescope colorscheme <cr>", desc = "Telescope Color Scheme"  },

  { "<C-]>", ":Telescope lsp_definitions<cr>" },
  { "<C-]><C-]>", ":Telescope lsp_references<cr>" },
}

M.lsp = {
  { 'gh', '<cmd>lua vim.lsp.buf.hover()<cr>' },
  { 'gr', '<cmd>lua vim.lsp.buf.references()<cr>' },
  { 'gd', '<cmd>lua vim.lsp.buf.declaration()<cr>' },
  { 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>' },
  { 'gt', '<cmd>lua vim.lsp.buf.type_definition()<cr>' },
  { 'gn', '<cmd>lua vim.lsp.buf.rename()<cr>' },
  { 'ga', '<cmd>lua vim.lsp.buf.code_action()<cr>' },
  { 'ge', '<cmd>lua vim.diagnostic.open_float()<cr>' },
  { 'g]', '<cmd>lua vim.diagnostic.goto_next()<cr>' },
  { 'g[', '<cmd>lua vim.diagnostic.goto_prev()<cr>' },
  -- { 'gq', '<cmd>lua vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled())<cr>' },
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

M.yanky = {
  { "<leader>p", function() require("telescope").extensions.yank_history.yank_history({ }) end, desc = "Open Yank History" },
  { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank text" },
  { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after cursor" },
  { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before cursor" },
  { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after selection" },
  { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before selection" },
  { "<c-p>", "<Plug>(YankyPreviousEntry)", desc = "Select previous entry through yank history" },
  { "<c-n>", "<Plug>(YankyNextEntry)", desc = "Select next entry through yank history" },
  { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
  { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
  { "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
  { "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
  { ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put and indent right" },
  { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put and indent left" },
  { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put before and indent right" },
  { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Put before and indent left" },
  { "=p", "<Plug>(YankyPutAfterFilter)", desc = "Put after applying a filter" },
  { "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Put before applying a filter" },
}

M.trouble = {
  {
    "<leader>xx",
    "<cmd>Trouble diagnostics toggle<cr>",
    desc = "Diagnostics (Trouble)",
  },
  {
    "<leader>xX",
    "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
    desc = "Buffer Diagnostics (Trouble)",
  },
  {
    "<leader>cs",
    "<cmd>Trouble symbols toggle focus=false<cr>",
    desc = "Symbols (Trouble)",
  },
  {
    "<leader>cl",
    "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
    desc = "LSP Definitions / references / ... (Trouble)",
  },
  {
    "<leader>xL",
    "<cmd>Trouble loclist toggle<cr>",
    desc = "Location List (Trouble)",
  },
  {
    "<leader>xQ",
    "<cmd>Trouble qflist toggle<cr>",
    desc = "Quickfix List (Trouble)",
  },
}

M.searchbox = {
  { "/", ":SearchBoxMatchAll <cr>", mode = "n", desc = "Search" },
  { ":s", ":SearchBoxReplace <cr>", mode = "n", desc = "Replace for files"  },
  { ":s", ":SearchBoxReplace visual_mode=true <cr>", mode = "v", desc = "Replace for range" },
}

return M
