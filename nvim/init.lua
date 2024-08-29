vim.cmd[[
    if has("mac")
    else
        let $VIMRUNTIME="/usr/local/share/nvim/runtime"
        set runtimepath+=/usr/local/share/nvim/runtime
    endif
]]
require("root")

