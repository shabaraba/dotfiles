local M = {}

local chadrc_config = require("core.utils").load_config()

M.autopairs = function()
    local present1, autopairs = pcall(require, "nvim-autopairs")
    local present2, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")

    if present1 and present2 then
        autopairs.setup({fast_wrap = {}})
        if override_flag then
            default = require("core.utils").tbl_override_req("nvim_autopairs", default)
      end
      autopairs.setup(default)

      local cmp = require "cmp"
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
   end
end

M.better_escape = function()
   require("better_escape").setup {
      mapping = chadrc_config.mappings.plugins.better_escape.esc_insertmode,
      timeout = chadrc_config.plugins.options.esc_insertmode_timeout,
   }
end

M.blankline = function()
    vim.opt.list = true
    -- vim.opt.listchars:append("space:⋅")
    -- vim.opt.listchars:append("eol:↴")
    vim.opt.termguicolors = true
    vim.cmd [[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]]
    vim.cmd [[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]]
    vim.cmd [[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]]
    vim.cmd [[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]]
    vim.cmd [[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]]
    vim.cmd [[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]]

    require("indent_blankline").setup {
        indentLine_enabled = 1,
        char = "▏",
        space_char_blankline = " ",
        filetype_exclude = {
            "help",
            "terminal",
            "dashboard",
            "packer",
            "lspinfo",
            "TelescopePrompt",
            "TelescopeResults",
            "nvchad_cheatsheet",
            "",
        },

        char_highlight_list = {
            "IndentBlanklineIndent1",
            "IndentBlanklineIndent2",
            "IndentBlanklineIndent3",
            "IndentBlanklineIndent4",
            "IndentBlanklineIndent5",
            "IndentBlanklineIndent6",
        },
        buftype_exclude = { "terminal" },
        show_trailing_blankline_indent = true,
        show_first_indent_level = true,
        show_current_context = true,
        show_current_context_start = true,
    }
end

M.colorizer = function()
    local present, colorizer = pcall(require, "colorizer")
    if present then
        colorizer.setup({ "*" }, {
            RGB = true, -- #RGB hex codes
            RRGGBB = true, -- #RRGGBB hex codes
            names = false, -- "Name" codes like Blue
            RRGGBBAA = false, -- #RRGGBBAA hex codes
            rgb_fn = false, -- CSS rgb() and rgba() functions
            hsl_fn = false, -- CSS hsl() and hsla() functions
            css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
            css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn

            -- Available modes: foreground, background
            mode = "background", -- Set the display mode.
        })
      vim.cmd "ColorizerReloadAllBuffers"
    end
end

M.comment = function()
   local present, nvim_comment = pcall(require, "Comment")
   if present then
      nvim_comment.setup()
   end
end

M.luasnip = function()
   local present, luasnip = pcall(require, "luasnip")
   if present then
      luasnip.config.set_config {
         history = true,
         updateevents = "TextChanged,TextChangedI",
      }

      require("luasnip/loaders/from_vscode").load { paths = chadrc_config.plugins.options.luasnip.snippet_path }
      require("luasnip/loaders/from_vscode").load()
   end
end

M.signature = function()
   local present, lspsignature = pcall(require, "lsp_signature")
   if present then
      lspsignature.setup {
         bind = true,
         doc_lines = 0,
         floating_window = true,
         fix_pos = true,
         hint_enable = true,
         hint_prefix = " ",
         hint_scheme = "String",
         hi_parameter = "Search",
         max_height = 22,
         max_width = 120, -- max_width of signature floating_window, line will be wrapped if exceed max_width
         handler_opts = {
            border = "single", -- double, single, shadow, none
         },
         zindex = 200, -- by default it will be on top of all floating windows, set to 50 send it to bottom
         padding = "", -- character to pad on left and right of signature can be ' ', or '|'  etc
      }
   end
end

M.lsp_handlers = function()
   local function lspSymbol(name, icon)
      local hl = "DiagnosticSign" .. name
      vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
   end

   lspSymbol("Error", "")
   lspSymbol("Info", "")
   lspSymbol("Hint", "")
   lspSymbol("Warn", "")

   vim.diagnostic.config {
      virtual_text = {
         prefix = "",
      },
      signs = true,
      underline = true,
      update_in_insert = false,
   }

   vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      border = "single",
   })
   vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = "single",
   })

   -- suppress error messages from lang servers
   vim.notify = function(msg, log_level)
      if msg:match "exit code" then
         return
      end
      if log_level == vim.log.levels.ERROR then
         vim.api.nvim_err_writeln(msg)
      else
         vim.api.nvim_echo({ { msg } }, true, {})
      end
   end
end

M.gitsigns = function()
   local present, gitsigns = pcall(require, "gitsigns")
   if present then
      gitsigns.setup {
         signs = {
            add = { hl = "DiffAdd", text = "│", numhl = "GitSignsAddNr" },
            change = { hl = "DiffChange", text = "│", numhl = "GitSignsChangeNr" },
            delete = { hl = "DiffDelete", text = "", numhl = "GitSignsDeleteNr" },
            topdelete = { hl = "DiffDelete", text = "‾", numhl = "GitSignsDeleteNr" },
            changedelete = { hl = "DiffChangeDelete", text = "~", numhl = "GitSignsChangeNr" },
         },
      }
   end
end

return M
