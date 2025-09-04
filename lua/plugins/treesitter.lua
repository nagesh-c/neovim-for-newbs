return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  config = function()
    local config = require("nvim-treesitter.configs")
    config.setup({
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = { "c", "lua", "cpp", "yang" , "markdown", "bash", "vim", "markdown_inline", "json" },
    })
    vim.treesitter.language.register("bash", "zsh")
  end
}
