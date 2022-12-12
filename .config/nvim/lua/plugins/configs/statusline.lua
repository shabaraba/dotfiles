local lsp = require "feline.providers.lsp"
local lsp_severity = vim.diagnostic.severity

local icon_styles = {
    default = {
        left = "",
        right = " ",
        main_icon = "  ",
        vi_mode_icon = " ",
        position_icon = " ",

        linux = ' ',
        macos = ' ',
        windows = ' ',

        errs = ' ',
        warns = ' ',
        infos = ' ',
        hints = ' ',

        lsp = ' ',
        git = ''
    },
    arrow = {
        left = "  ",
        right = " ",
        main_icon = "  ",
        vi_mode_icon = " ",
        position_icon = " ",

        linux = ' ',
        macos = ' ',
        windows = ' ',

        errs = ' ',
        warns = ' ',
        infos = ' ',
        hints = ' ',

        lsp = ' ',
        git = ''
    },

    block = {
        left = " ",
        right = " ",
        main_icon = "   ",
        vi_mode_icon = "  ",
        position_icon = "  ",

        linux = ' ',
        macos = ' ',
        windows = ' ',

        errs = ' ',
        warns = ' ',
        infos = ' ',
        hints = ' ',

        lsp = ' ',
        git = ''
    },

    round = {
        left = "",
        right = "",
        main_icon = "  ",
        vi_mode_icon = " ",
        position_icon = " ",

        linux = ' ',
        macos = ' ',
        windows = ' ',

        errs = ' ',
        warns = ' ',
        infos = ' ',
        hints = ' ',

        lsp = ' ',
        git = ''
    },

    slant = {
        left = " ",
        right = " ",
        main_icon = "  ",
        vi_mode_icon = " ",
        position_icon = " ",

        linux = ' ',
        macos = ' ',
        windows = ' ',

        errs = ' ',
        warns = ' ',
        infos = ' ',
        hints = ' ',

        lsp = ' ',
        git = ''
    },
}

local config = require("core.utils").load_config().plugins.options.statusline

-- statusline style
local user_statusline_style = config.style
local statusline_style = icon_styles[user_statusline_style]

-- show short statusline on small screens
local shortline = config.shortline == false and true

-- Initialize the components table
local components = {
    active = {},
}

local dir_name = {
    provider = { name = "file_info", opts = { type = "relative" } },
   -- provider = function()
   --    local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
   --    return "  " .. dir_name .. " "
   -- end,

   enabled = shortline or function(winid)
      return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 80
   end,
   right_sep = {
      str = statusline_style.right,
   },
}

local function_name = {
    provider = function()
        local success, function_name = pcall(vim.api.nvim_buf_get_var, 0, 'coc_current_function')
        if function_name == nil or success == false then
            function_name = ''
        end
        return "  "..function_name
    end,

   enabled = shortline or function(winid)
      return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 80
   end,

}

local function file_osinfo()
    local os = vim.bo.fileformat:upper()
    local icon
    if os == 'UNIX' then
        icon = statusline_style.linux
    elseif os == 'MAC' then
        icon = statusline_style.macos
    else
        icon = statusline_style.windows
    end
    return icon .. os
end

local file_os = {
    provider = file_osinfo,
    left_sep = ' ',
}

local function lsp_diagnostics_info()
    return {
        errs = lsp.get_diagnostics_count('Error'),
        warns = lsp.get_diagnostics_count('Warning'),
        infos = lsp.get_diagnostics_count('Information'),
        hints = lsp.get_diagnostics_count('Hint')
    }
end

local diff = {
    add = {
        provider = "git_diff_added",
        left_sep = ' ',
        icon = " ",
    },

    change = {
        provider = "git_diff_changed",
        left_sep = ' ',
        icon = "  ",
    },

    remove = {
        provider = "git_diff_removed",
        left_sep = ' ',
        icon = "  ",
    },
}

local git_branch = {
    provider = "git_branch",
    enabled = shortline or function(winid)
       return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 70
    end,
    left_sep = ' ',
    icon = "  ",
}

local diagnostic = {
    errors = {
        provider = "diagnostic_errors",
        enabled = function()
            return lsp.diagnostics_exist(lsp_severity.ERROR)
        end,

        left_sep = ' ',
        icon = "  ",
    },

    warning = {
        provider = "diagnostic_warnings",
        enabled = function()
            return lsp.diagnostics_exist(lsp_severity.WARN)
        end,
        left_sep = ' ',
        icon = "  ",
    },

    hint = {
        provider = "diagnostic_hints",
        enabled = function()
            return lsp.diagnostics_exist(lsp_severity.HINT)
        end,
        left_sep = ' ',
        icon = "  ",
    },

    info = {
        provider = "diagnostic_info",
        enabled = function()
            return lsp.diagnostics_exist(lsp_severity.INFO)
        end,
        left_sep = ' ',
        icon = "  ",
    },
}

local lsp_progress = {
   provider = function()
      local Lsp = vim.lsp.util.get_progress_messages()[1]

      if Lsp then
         local msg = Lsp.message or ""
         local percentage = Lsp.percentage or 0
         local title = Lsp.title or ""
         local spinners = {
            "",
            "",
            "",
         }

         local success_icon = {
            "",
            "",
            "",
         }

         local ms = vim.loop.hrtime() / 1000000
         local frame = math.floor(ms / 120) % #spinners

         if percentage >= 70 then
            return string.format(" %%<%s %s %s (%s%%%%) ", success_icon[frame + 1], title, msg, percentage)
         end

         return string.format(" %%<%s %s %s (%s%%%%) ", spinners[frame + 1], title, msg, percentage)
      end

      return ""
   end,
   enabled = shortline or function(winid)
      return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 80
   end,
}

local lsp_icon = {
   provider = function()
      if next(vim.lsp.buf_get_clients()) ~= nil then
         return "  LSP"
      else
         return ""
      end
   end,
   enabled = shortline or function(winid)
      return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 70
   end,
}

-- local mode_colors = {
--    ["n"] = { "NORMAL", colors.green },
--    ["no"] = { "N-PENDING", colors.green },
--    ["i"] = { "INSERT", colors.yellow },
--    ["ic"] = { "INSERT", colors.yellow },
--    ["t"] = { "TERMINAL", colors.green },
--    ["v"] = { "VISUAL", colors.cyan },
--    ["V"] = { "V-LINE", colors.cyan },
--    [""] = { "V-BLOCK", colors.cyan },
--    ["R"] = { "REPLACE", colors.red },
--    ["Rv"] = { "V-REPLACE", colors.red },
--    ["s"] = { "SELECT", colors.nord_blue },
--    ["S"] = { "S-LINE", colors.nord_blue },
--    [""] = { "S-BLOCK", colors.nord_blue },
--    ["c"] = { "COMMAND", colors.pink },
--    ["cv"] = { "COMMAND", colors.pink },
--    ["ce"] = { "COMMAND", colors.pink },
--    ["r"] = { "PROMPT", colors.teal },
--    ["rm"] = { "MORE", colors.teal },
--    ["r?"] = { "CONFIRM", colors.teal },
--    ["!"] = { "SHELL", colors.green },
-- }

-- local chad_mode_hl = function()
--    return {
--       fg = mode_colors[vim.fn.mode()][2],
--       bg = colors.one_bg,
--    }
-- end

-- this matches the vi mode color

local mode_icon = {
   provider = statusline_style.vi_mode_icon,
}

local current_line = {
   provider = function()
      local current_line = vim.fn.line "."
      local total_line = vim.fn.line "$"

      if current_line == 1 then
         return " Top "
      elseif current_line == vim.fn.line "$" then
         return " Bot "
      end
      local result, _ = math.modf((current_line / total_line) * 100)
      return " " .. result .. "%% "
   end,

   enabled = shortline or function(winid)
      return vim.api.nvim_win_get_width(tonumber(winid) or 0) > 90
   end,
}

local function add_table(a, b)
   table.insert(a, b)
end

-- components are divided in 3 sections
local left = {}
local middle = {}
local right = {}

-- left
-- add_table(left, main_icon)
add_table(left, mode_icon)
-- add_table(left, empty_space2)
add_table(left, dir_name)
add_table(left, function_name)
add_table(left, diagnostic.error)
add_table(left, diagnostic.warning)
add_table(left, diagnostic.hint)
add_table(left, diagnostic.info)

add_table(middle, lsp_progress)

-- right
add_table(right, lsp_icon)
add_table(right, git_branch)
add_table(right, diff.add)
add_table(right, diff.change)
add_table(right, diff.remove)
add_table(right, file_os)
add_table(right, current_line)

components.active[1] = left
components.active[2] = middle
components.active[3] = right

require("feline").setup {
   -- theme = {
   --    bg = colors.statusline_bg,
   --    fg = colors.fg,
   -- },
   components = components,
}
