local vim = vim
local utils = require "core.utils"
local map = utils.map
local command = utils.command

-- 新しい配列を作成する関数
local function extract_values(tbl, key)
  local result = {}
  for _, subtable in ipairs(tbl) do
    result[subtable[key]] = subtable
  end
  return result
end

local M = {}

local Prefix = {
  show = "<leader>",
  jump = "g",
  action = ",",
  finder = ";",
}

local Function = {
  DIAGNOSTIC = {
    GO_TO_NEXT = "GO TO NEXT DIAGNOSTIC",
    GO_TO_PREV = "GO TO PREV DIAGNOSTIC",
    SHOW = "SHOW DIAGNOSTIC UNDER THE CURSOR",
    SHOW_ALL = "SHOW DIAGNOSTICS",
    SHOW_BUFFER = "SHOW DIAGNOSTIC IN BUFFER",
  },
  LSP = {
    GG_TO_DEFINITION_OR_REFERENCES = "GO TO DEFINITION OR REFERENCES",
    HOVER = "HOVER UNDER THE CURSOR",
    SHOW_TYPE_DEFINITION = "SHOW TYPE DEFINITION",
    RENAME_VALIABLE_NAME = "RENAME VALIABLE NAME UNDER THE CURSOR",
    CODE_ACTION = "CODE ACTION",
    CALL_HIERARCHY = "SHOW CALL HIERARCHY",
    OUTLINE = "SHOW OUTLINE",
  },
  FILER = {
    OPEN = "OPEN FILER",
  },
  FINDER = {
    FIND_FILES = "TELESCOPE FIND FILES",
    FIND_ALL_FILES = "TELESCOPE FIND ALL FILES",
    GREP = "TELESCOPE LIVE GREP",
    FIND_HELP = "TELESCOPE FIND HELP",
    FIND_COLOR_SHCEME = "TELESCOPE FIND COLOR SCHEME",
    JUMP_MOTION = "JUMP MOTION",
    COMMANDS = "FIND AND EXEC COMMANDS",
    KEYMAPS = "FIND AND EXEC KEYMAPS",
  },
  GIT = {
    SHOW_COMMITS = "TELESCOPE GIT COMMITS",
    SHOW_STATUS = "TELESCOPE GIT STATUS",
  },
  BUFFER = {
    SHOW_LIST = "SHOW BUFFERS",
    GO_TO_NEXT = "GO TO NEXT BUFFER",
    GO_TO_PREV = "GO TO PREV BUFFER",
  },
  CODING = {
    GENERATE_DOC_COMMENT = "GENERATE_DOC_COMMENT",
    FORMAT = "FORMAT",
    REFACTOR = "REFACTOR",
  },
  AI = {
    OPEN_CHAT = "OPEN COPILOT CHAT",
  },
  OVERRIDE = {
    YANK = "YANK",
    PASTE_AFTER = "PASTE AFTER CURSOR",
    PASTE_BEFORE = "PASTE BEFORE CURSOR",
    PASTE_PREV_YANK = "PASTE_PREV_YANK",
    PASTE_NEXT_YANK = "PASTE_NEXT_YANK",
    PASTE_INDENT_AFTER = "PASTE WITH INDENT AFTER CURSOR",
    PASTE_INDENT_BEFORE = "PASTE WITH INDNET BEFORE CURSOR",
    OPEN_YANK_HISTORY = "OPEN YANK HISTORY",
  }
}

local Mapping = {
  { Prefix.jump .. ']',        '<cmd>lua vim.diagnostic.goto_next()<cr>',                                     desc = Function.DIAGNOSTIC.GO_TO_NEXT,              silent = true },
  { Prefix.jump .. '[',        '<cmd>lua vim.diagnostic.goto_prev()<cr>',                                     desc = Function.DIAGNOSTIC.GO_TO_PREV,              silent = true },
  { Prefix.jump .. "h",        ":Lspsaga finder<cr>",                                                         desc = Function.LSP.GG_TO_DEFINITION_OR_REFERENCES, silent = true },
  { Prefix.jump .. 's',        '<cmd>HopChar2<cr>',                                                           desc = Function.FINDER.JUMP_MOTION,                 silent = true },

  { Prefix.finder .. "f",      ":Telescope find_files <cr>",                                                  desc = Function.FINDER.FIND_FILES,                  silent = true },
  { Prefix.finder .. "a",      ":Telescope find_files follow=true no_ignore=true hidden=true <cr>",           desc = Function.FINDER.FIND_ALL_FILES,              silent = true },
  { Prefix.finder .. "gc",     ":Telescope git_commits <cr>",                                                 desc = Function.GIT.SHOW_COMMITS,                   silent = true },
  { Prefix.finder .. "gs",     ":Telescope git_status <cr>",                                                  desc = Function.GIT.SHOW_STATUS,                    silent = true },
  { Prefix.finder .. "h",      ":Telescope help_tags <cr>",                                                   desc = Function.FINDER.FIND_HELP,                   silent = true },
  { Prefix.finder .. "w",      ":Telescope live_grep <cr>",                                                   desc = Function.FINDER.GREP,                        silent = true },
  { Prefix.finder .. "c",      ":Telescope commands <cr>",                                                    desc = Function.FINDER.COMMANDS,                    silent = true },
  { Prefix.finder .. "k",      ":Telescope keymaps <cr>",                                                     desc = Function.FINDER.KEYMAPS,                     silent = true },

  { Prefix.show .. 'h',        '<cmd>lua vim.lsp.buf.hover()<cr>',                                            desc = Function.LSP.HOVER,                          silent = true },
  { Prefix.show .. "t",        ":Lspsaga peek_type_definition<cr>",                                           desc = Function.LSP.SHOW_TYPE_DEFINITION,           silent = true },
  { Prefix.show .. 'e',        '<cmd>lua vim.diagnostic.open_float()<cr>',                                    desc = Function.DIAGNOSTIC.SHOW,                    silent = true },
  { Prefix.show .. "xx",       "<cmd>Trouble diagnostics toggle<cr>",                                         desc = Function.DIAGNOSTIC.SHOW_ALL,                silent = true },
  { Prefix.show .. "xX",       "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",                            desc = Function.DIAGNOSTIC.SHOW_BUFFER,             silent = true },
  { Prefix.show .. "i",        ":Lspsaga incoming_calls<cr>",                                                 desc = Function.LSP.CALL_HIERARCHY,                 silent = true },
  { Prefix.show .. "o",        ":Lspsaga outline<cr>",                                                        desc = Function.LSP.OUTLINE,                        silent = true },
  { Prefix.show .. "<leader>", "<cmd>Oil  --float<cr>",                                                       desc = Function.FILER.OPEN,                         silent = true },
  { Prefix.show .. "f",        ":lua require(\"vuffers\").toggle()<cr>",                                      desc = Function.BUFFER.SHOW_LIST,                   silent = true },
  { "<C-j>",                   ":lua require(\"vuffers\").go_to_buffer_by_count({direction = \"next\"})<cr>", desc = Function.BUFFER.GO_TO_NEXT,                  silent = true },
  { "<C-k>",                   ":lua require(\"vuffers\").go_to_buffer_by_count({direction = \"prev\"})<cr>", desc = Function.BUFFER.GO_TO_PREV,                  silent = true },

  { Prefix.action .. 'n',      '<cmd>lua vim.lsp.buf.rename()<cr>',                                           desc = Function.LSP.RENAME_VALIABLE_NAME,           silent = true },
  { Prefix.action .. "c",      ":Lspsaga code_action<cr>",                                                    desc = Function.LSP.CODE_ACTION,                    silent = true },
  { Prefix.action .. "cd",     function() require("neogen").generate({}) end,                                 desc = Function.CODING.GENERATE_DOC_COMMENT,        silent = true },
  { Prefix.action .. "cc",     "<cmd>CopilotChat<cr>",                                                        desc = Function.AI.OPEN_CHAT,                       silent = true },
  { Prefix.action .. 'f',      '<cmd>lua vim.lsp.buf.format()<cr>',                                           desc = Function.CODING.FORMAT,                      silent = true },
  { Prefix.action .. "r",      function() require("refactoring").select_refactor() end,                       desc = Function.CODING.REFACTOR,                    silent = true,                      mode = "v", noremap = true, expr = false },
  { Prefix.action .. "p",      function() require("telescope").extensions.yank_history.yank_history({}) end,  desc = Function.OVERRIDE.OPEN_YANK_HISTORY,         silent = true },
  { "y",                       "<Plug>(YankyYank)",                                                           desc = Function.OVERRIDE.YANK,                      mode = { "n", "x", silent = true }, },
  { "p",                       "<Plug>(YankyPutAfter)",                                                       desc = Function.OVERRIDE.PASTE_AFTER,               silent = true },
  { "P",                       "<Plug>(YankyPutBefor)",                                                       desc = Function.OVERRIDE.PASTE_AFTER,               silent = true },
  { "]p",                      "<Plug>(YankyPutIndentAfterLinewise)",                                         desc = Function.OVERRIDE.PASTE_INDENT_AFTER,        silent = true },
  { "[p",                      "<Plug>(YankyPutIndentBeforeLinewise)",                                        desc = Function.OVERRIDE.PASTE_INDENT_BEFORE,       silent = true },
  { "<c-p>",                   "<Plug>(YankyPreviousEntry)",                                                  desc = Function.OVERRIDE.PASTE_PREV_YANK,           silent = true },
  { "<c-n>",                   "<Plug>(YankyNextEntry)",                                                      desc = Function.OVERRIDE.PASTE_NEXT_YANK,           silent = true },
}

local FunctionKeyMapping = extract_values(Mapping, "desc")

M.telescope = {
  FunctionKeyMapping[Function.FINDER.GREP],
  FunctionKeyMapping[Function.FINDER.FIND_HELP],
  FunctionKeyMapping[Function.FINDER.FIND_FILES],
  FunctionKeyMapping[Function.FINDER.FIND_ALL_FILES],
  FunctionKeyMapping[Function.FINDER.FIND_COLOR_SHCEME],
}

-- below are all plugin related mappings

M.lsp = {
  FunctionKeyMapping[Function.LSP.HOVER],
  FunctionKeyMapping[Function.LSP.RENAME_VALIABLE_NAME],
}

M.lspsaga = {
  FunctionKeyMapping[Function.LSP.GG_TO_DEFINITION_OR_REFERENCES],
  FunctionKeyMapping[Function.LSP.SHOW_TYPE_DEFINITION],
  FunctionKeyMapping[Function.LSP.CALL_HIERARCHY],
  FunctionKeyMapping[Function.LSP.CODE_ACTION],
  FunctionKeyMapping[Function.LSP.OUTLINE],
}

M.none_ls = {
  FunctionKeyMapping[Function.CODING.FORMAT],
}

M.neogen = {
  FunctionKeyMapping[Function.CODING.GENERATE_DOC_COMMENT],
}

M.refactoring = {
  FunctionKeyMapping[Function.CODING.REFACTOR],
}

M.oil = {
  FunctionKeyMapping[Function.FILER.OPEN],
}

M.vuffers = {
  FunctionKeyMapping[Function.BUFFER.SHOW_LIST],
  FunctionKeyMapping[Function.BUFFER.GO_TO_NEXT],
  FunctionKeyMapping[Function.BUFFER.GO_TO_PREV],
}

M.yanky = {
  FunctionKeyMapping[Function.OVERRIDE.YANK],
  FunctionKeyMapping[Function.OVERRIDE.PASTE_AFTER],
  FunctionKeyMapping[Function.OVERRIDE.PASTE_BEFORE],
  FunctionKeyMapping[Function.OVERRIDE.PASTE_NEXT_YANK],
  FunctionKeyMapping[Function.OVERRIDE.PASTE_PREV_YANK],
  FunctionKeyMapping[Function.OVERRIDE.OPEN_YANK_HISTORY],
}

M.trouble = {
  FunctionKeyMapping[Function.DIAGNOSTIC.SHOW_ALL],
  FunctionKeyMapping[Function.DIAGNOSTIC.SHOW_BUFFER],
}

M.copilot_chat = {
  FunctionKeyMapping[Function.AI.OPEN_CHAT],
}

M.hop = {
  FunctionKeyMapping[Function.FINDER.JUMP_MOTION],
}

-- M.searchbox = {
--   { "/",  ":SearchBoxMatchAll <cr>",                 mode = "n", desc = "Search" },
--   { ":s", ":SearchBoxReplace <cr>",                  mode = "n", desc = "Replace for files" },
--   { ":s", ":SearchBoxReplace visual_mode=true <cr>", mode = "v", desc = "Replace for range" },
-- }


-- M.neotree = {
--   { "<leader><leader>", ":Neotree reveal toggle<cr>",           desc = "Open FileSystem" },
--   { "<leader>f", ":Neotree buffers toggle<cr>",          desc = "Open Virtical Buffer" },
--   { "<leader>g", ":Neotree git_status toggle<cr>",       desc = "Open Git Status" },
--   { "<leader>d", ":Neotree document_symbols toggle<cr>", desc = "Open Document Symbols" },
-- }

-- these mappings will only be called during initialization
-- vim.api.nvim_del_keymap('n', '<C-j>')
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

  map('n', 'j', 'gj', { noremap = true })
  map('n', 'k', 'gk', { noremap = true })

  map('i', 'jj', '<Esc>', { noremap = true })
  map('n', '9', '$', { noremap = true })
  map('n', '}', '%', { noremap = true })
  map('n', '{', '%', { noremap = true })
  map('n', '<Esc><Esc>', ':nohlsearch<CR><Esc>', { noremap = false })
  map('i', '<C-b>', '<Left>', { noremap = true })
  map('i', '<C-f>', '<Right>', { noremap = true })
  map('i', '<C-a>', '<Home>', { noremap = true })
  map('i', '<C-e>', '<End>', { noremap = true })

  -- map('n', '<C-j>', ':bp<CR>', { noremap = false })
  -- map('n', '<C-k>', ':bn<CR>', { noremap = false })

  map('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })

  -- terminal mappings --
  -- get out of terminal mode
  map("t", { "jj" }, "<C-\\><C-n>")
  -- terminal mappings end --

  command('MyCommand', function() print("Hello, World!") end, {})
end

return M
