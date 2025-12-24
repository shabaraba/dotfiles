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
  ai = "\\",
}

local FUNCTION = {
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
  TERMINAL = {
    TOGGLE_FLOAT = "TOGGLE TERMINAL FLOAT",
    TOGGLE_VERTICAL = "TOGGLE TERMINAL VERTICAL",
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
    TOGGLE_COMMENT = "TOGGLE COMMENT",
    SURROUND = "Add a surrounding pair around a motion (normal mode)",
    SURROUND_VISUAL = "Add a surrounding pair around a visual selection",
    SURROUND_CHANGE = "Change a surrounding pair",
    SURROUND_DELETE = "Delete a surrounding pair",
    FORMAT = "FORMAT",
    REFACTOR = "REFACTOR",
  },
  AI = {
    OPEN_CHAT = "OPEN COPILOT CHAT",
    -- vibing
    VIBING_CHAT = "VIBING CHAT",
    VIBING_CONTEXT = "VIBING CONTEXT",
    VIBING_INLINE = "VIBING INLINE",
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

local Commands = {
  { "Chat", function() vim.api.nvim_command("CopilotChat") end,                                { desc = FUNCTION.AI.OPEN_CHAT } },
  -- { "Fmt",  function() vim.lsp.buf.format() end,                {desc = FUNCTION.CODING.FORMAT} },
  { "Format", function(args)
    local range = nil
    if args.count ~= -1 then
      local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
      range = {
        start = { args.line1, 0 },
        ["end"] = { args.line2, end_line:len() },
      }
    end
    require("conform").format({ async = true, lsp_format = "fallback", range = range })
  end, { range = true, desc = FUNCTION.CODING.FORMAT } },
  { "T",    function() vim.api.nvim_command("ToggleTerm direction=float name=desktop") end,    { desc = FUNCTION.TERMINAL.TOGGLE_FLOAT } },
  { "VT",   function() vim.api.nvim_command("ToggleTerm direction=vertical name=desktop") end, { desc = FUNCTION.TERMINAL.TOGGLE_FLOAT } },
}

for _, commands in ipairs(Commands) do
  command(commands[1], commands[2], commands[3])
end

local Mapping = {
  { Prefix.jump .. ']',        '<cmd>lua vim.diagnostic.goto_next()<cr>',                                    desc = FUNCTION.DIAGNOSTIC.GO_TO_NEXT,              silent = true },
  { Prefix.jump .. '[',        '<cmd>lua vim.diagnostic.goto_prev()<cr>',                                    desc = FUNCTION.DIAGNOSTIC.GO_TO_PREV,              silent = true },
  { Prefix.jump .. "h",        ":Lspsaga finder<cr>",                                                        desc = FUNCTION.LSP.GG_TO_DEFINITION_OR_REFERENCES, silent = true },
  { Prefix.jump .. 's',        '<cmd>HopChar2<cr>',                                                          desc = FUNCTION.FINDER.JUMP_MOTION,                 silent = true },

  { Prefix.finder .. "f",      ":Telescope find_files <cr>",                                                 desc = FUNCTION.FINDER.FIND_FILES,                  silent = true },
  { Prefix.finder .. "a",      ":Telescope find_files follow=true no_ignore=true hidden=true <cr>",          desc = FUNCTION.FINDER.FIND_ALL_FILES,              silent = true },
  { Prefix.finder .. "gc",     ":Telescope git_commits <cr>",                                                desc = FUNCTION.GIT.SHOW_COMMITS,                   silent = true },
  { Prefix.finder .. "gs",     ":Telescope git_status <cr>",                                                 desc = FUNCTION.GIT.SHOW_STATUS,                    silent = true },
  { Prefix.finder .. "h",      ":Telescope help_tags <cr>",                                                  desc = FUNCTION.FINDER.FIND_HELP,                   silent = true },
  { Prefix.finder .. "w",      ":Telescope live_grep <cr>",                                                  desc = FUNCTION.FINDER.GREP,                        silent = true },
  { Prefix.finder .. "c",      ":Telescope commands <cr>",                                                   desc = FUNCTION.FINDER.COMMANDS,                    silent = true },
  { Prefix.finder .. "k",      ":Telescope keymaps <cr>",                                                    desc = FUNCTION.FINDER.KEYMAPS,                     silent = true },

  { Prefix.show .. 'h',        '<cmd>lua vim.lsp.buf.hover()<cr>',                                           desc = FUNCTION.LSP.HOVER,                          silent = true },
  { Prefix.show .. "t",        ":Lspsaga peek_type_definition<cr>",                                          desc = FUNCTION.LSP.SHOW_TYPE_DEFINITION,           silent = true },
  { Prefix.show .. 'e',        '<cmd>lua vim.diagnostic.open_float()<cr>',                                   desc = FUNCTION.DIAGNOSTIC.SHOW,                    silent = true },
  { Prefix.show .. "xx",       "<cmd>Trouble diagnostics toggle<cr>",                                        desc = FUNCTION.DIAGNOSTIC.SHOW_ALL,                silent = true },
  { Prefix.show .. "xX",       "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",                           desc = FUNCTION.DIAGNOSTIC.SHOW_BUFFER,             silent = true },
  { Prefix.show .. "i",        ":Lspsaga incoming_calls<cr>",                                                desc = FUNCTION.LSP.CALL_HIERARCHY,                 silent = true },
  { Prefix.show .. "o",        ":Lspsaga outline<cr>",                                                       desc = FUNCTION.LSP.OUTLINE,                        silent = true },
  { Prefix.show .. "<leader>", "<cmd>Oil  --float<cr>",                                                      desc = FUNCTION.FILER.OPEN,                         silent = true },
  -- { Prefix.show .. "f",        ":lua require(\"vuffers\").toggle()<cr>",                                      desc = FUNCTION.BUFFER.SHOW_LIST,                   silent = true },
  -- { "<C-j>",                   ":lua require(\"vuffers\").go_to_buffer_by_count({direction = \"next\"})<cr>", desc = FUNCTION.BUFFER.GO_TO_NEXT,                  silent = true },
  -- { "<C-k>",                   ":lua require(\"vuffers\").go_to_buffer_by_count({direction = \"prev\"})<cr>", desc = FUNCTION.BUFFER.GO_TO_PREV,                  silent = true },
  { Prefix.show .. "f",        '<cmd>PileToggle<CR>',                                                        desc = FUNCTION.BUFFER.SHOW_LIST,                   noremap = true,                     silent = true },
  { "<C-j>",                   '<cmd>PileGoToNextBuffer<CR>',                                                desc = FUNCTION.BUFFER.GO_TO_NEXT,                  noremap = true,                     silent = true },
  { "<C-k>",                   '<cmd>PileGoToPrevBuffer<CR>',                                                desc = FUNCTION.BUFFER.GO_TO_PREV,                  noremap = true,                     silent = true },

  { Prefix.action .. 's',      '<Plug>(nvim-surround-normal)',                                               desc = FUNCTION.CODING.SURROUND,                    silent = true },
  { Prefix.action .. 's',      '<Plug>(nvim-surround-visual)',                                               desc = FUNCTION.CODING.SURROUND_VISUAL,             mode = "v",                         silent = true },
  { Prefix.action .. 'cs',     '<Plug>(nvim-surround-change)',                                               desc = FUNCTION.CODING.SURROUND_CHANGE,             silent = true },
  { Prefix.action .. 'ds',     '<Plug>(nvim-surround-delete)',                                               desc = FUNCTION.CODING.SURROUND_DELETE,             silent = true },
  { Prefix.action .. 'n',      '<cmd>lua vim.lsp.buf.rename()<cr>',                                          desc = FUNCTION.LSP.RENAME_VALIABLE_NAME,           silent = true },
  { Prefix.action .. "c",      ":Lspsaga code_action<cr>",                                                   desc = FUNCTION.LSP.CODE_ACTION,                    silent = true },
  { Prefix.action .. "cc",     "<Plug>(comment_toggle_linewise_current)",                                    desc = FUNCTION.CODING.TOGGLE_COMMENT,              mode = { "n", "x", silent = true } },
  { Prefix.action .. "cd",     function() require("neogen").generate({}) end,                                desc = FUNCTION.CODING.GENERATE_DOC_COMMENT,        silent = true },
  { Prefix.action .. "r",      function() require("refactoring").select_refactor() end,                      desc = FUNCTION.CODING.REFACTOR,                    silent = true,                      mode = "v",                                          noremap = true, expr = false },
  { Prefix.action .. "p",      function() require("telescope").extensions.yank_history.yank_history({}) end, desc = FUNCTION.OVERRIDE.OPEN_YANK_HISTORY,         silent = true },
  { "y",                       "<Plug>(YankyYank)",                                                          desc = FUNCTION.OVERRIDE.YANK,                      mode = { "n", "x", silent = true }, },
  { "p",                       "<Plug>(YankyPutAfter)",                                                      desc = FUNCTION.OVERRIDE.PASTE_AFTER,               mode = { "n", "x", silent = true }, },
  { "P",                       "<Plug>(YankyPutBefore)",                                                     desc = FUNCTION.OVERRIDE.PASTE_BEFORE,              mode = { "n", "x", silent = true }, },
  { "]p",                      "<Plug>(YankyPutIndentAfterLinewise)",                                        desc = FUNCTION.OVERRIDE.PASTE_INDENT_AFTER,        silent = true },
  { "[p",                      "<Plug>(YankyPutIndentBeforeLinewise)",                                       desc = FUNCTION.OVERRIDE.PASTE_INDENT_BEFORE,       silent = true },
  { "<c-p>",                   "<Plug>(YankyPreviousEntry)",                                                 desc = FUNCTION.OVERRIDE.PASTE_PREV_YANK,           silent = true },
  { "<c-n>",                   "<Plug>(YankyNextEntry)",                                                     desc = FUNCTION.OVERRIDE.PASTE_NEXT_YANK,           silent = true },

  -- vibing
  { Prefix.ai .. 'c',          '<cmd>VibingChat<cr>',                                                        desc = FUNCTION.AI.VIBING_CHAT,                     silent = true },
  { Prefix.ai .. 's',          '<cmd>VibingContext<cr>',                                                     desc = FUNCTION.AI.VIBING_CONTEXT,                  silent = true },
  { Prefix.ai .. 'i',          '<cmd>VibingInline<cr>',                                                      desc = FUNCTION.AI.VIBING_INLINE,                   silent = true,                      mode = 'v' },
}

local FunctionKeyMapping = extract_values(Mapping, "desc")

M.telescope = {
  FunctionKeyMapping[FUNCTION.FINDER.GREP],
  FunctionKeyMapping[FUNCTION.FINDER.KEYMAPS],
  FunctionKeyMapping[FUNCTION.FINDER.COMMANDS],
  FunctionKeyMapping[FUNCTION.FINDER.FIND_HELP],
  FunctionKeyMapping[FUNCTION.FINDER.FIND_FILES],
  FunctionKeyMapping[FUNCTION.FINDER.FIND_ALL_FILES],
}

-- below are all plugin related mappings

M.lsp = {
  FunctionKeyMapping[FUNCTION.LSP.HOVER],
  FunctionKeyMapping[FUNCTION.LSP.RENAME_VALIABLE_NAME],
  FunctionKeyMapping[FUNCTION.DIAGNOSTIC.GO_TO_NEXT],
  FunctionKeyMapping[FUNCTION.DIAGNOSTIC.GO_TO_PREV],
}

M.lspsaga = {
  FunctionKeyMapping[FUNCTION.LSP.GG_TO_DEFINITION_OR_REFERENCES],
  FunctionKeyMapping[FUNCTION.LSP.SHOW_TYPE_DEFINITION],
  FunctionKeyMapping[FUNCTION.LSP.CALL_HIERARCHY],
  FunctionKeyMapping[FUNCTION.LSP.CODE_ACTION],
  FunctionKeyMapping[FUNCTION.LSP.OUTLINE],
}

M.none_ls = {}

M.neogen = {
  FunctionKeyMapping[FUNCTION.CODING.GENERATE_DOC_COMMENT],
}

M.comment = {
  FunctionKeyMapping[FUNCTION.CODING.TOGGLE_COMMENT],
}

M.refactoring = {
  FunctionKeyMapping[FUNCTION.CODING.REFACTOR],
}

M.oil = {
  FunctionKeyMapping[FUNCTION.FILER.OPEN],
}

M.surround = {
  FunctionKeyMapping[FUNCTION.CODING.SURROUND],
  FunctionKeyMapping[FUNCTION.CODING.SURROUND_VISUAL],
  FunctionKeyMapping[FUNCTION.CODING.SURROUND_CHANGE],
  FunctionKeyMapping[FUNCTION.CODING.SURROUND_DELETE],
}

M.yanky = {
  FunctionKeyMapping[FUNCTION.OVERRIDE.YANK],
  FunctionKeyMapping[FUNCTION.OVERRIDE.PASTE_AFTER],
  FunctionKeyMapping[FUNCTION.OVERRIDE.PASTE_BEFORE],
  FunctionKeyMapping[FUNCTION.OVERRIDE.PASTE_INDENT_AFTER],
  FunctionKeyMapping[FUNCTION.OVERRIDE.PASTE_INDENT_BEFORE],
  FunctionKeyMapping[FUNCTION.OVERRIDE.PASTE_NEXT_YANK],
  FunctionKeyMapping[FUNCTION.OVERRIDE.PASTE_PREV_YANK],
  FunctionKeyMapping[FUNCTION.OVERRIDE.OPEN_YANK_HISTORY],
}

M.trouble = {
  FunctionKeyMapping[FUNCTION.DIAGNOSTIC.SHOW_ALL],
  FunctionKeyMapping[FUNCTION.DIAGNOSTIC.SHOW_BUFFER],
}

M.copilot_chat = {
  FunctionKeyMapping[FUNCTION.AI.OPEN_CHAT],
}

M.hop = {
  FunctionKeyMapping[FUNCTION.FINDER.JUMP_MOTION],
}

M.pile = {
  FunctionKeyMapping[FUNCTION.BUFFER.SHOW_LIST],
  FunctionKeyMapping[FUNCTION.BUFFER.GO_TO_NEXT],
  FunctionKeyMapping[FUNCTION.BUFFER.GO_TO_PREV],
}

M.vibing = {
  FunctionKeyMapping[FUNCTION.AI.VIBING_CHAT],
  FunctionKeyMapping[FUNCTION.AI.VIBING_CONTEXT],
  FunctionKeyMapping[FUNCTION.AI.VIBING_INLINE],
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
end

return M
