return {
  "numToStr/Comment.nvim",
  keys = require("mappings").comment,
  opts = {
      pre_hook = function(ctx)
    local filetype = vim.bo.filetype
    if filetype == 'mq5' then
      return require('Comment.ft').set('mq5', {'// %s', '/* %s */'})
    end
  end
  },
  config = function ()
    local ft = require('Comment.ft')
   ft.set('mq5', {'//%s', '/*%s*/'})
   ft.set('mql', {'//%s', '/*%s*/'})
   .set('mqh', {'//%s', '/*%s*/'})
  end
}
