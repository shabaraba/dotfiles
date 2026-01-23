return {
  "chrisgrieser/nvim-spider",
  lazy = true,
  opts = {
    skipInsignificantPunctuation = true,
    consistentOperatorPending = false,
    subwordMovement = true,
  },
  keys = require("mappings").spider,
}
