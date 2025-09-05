return {
  "dhananjaylatkar/cscope_maps.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim", -- optional, for nice picker
  },
  config = function()
    require("cscope_maps").setup({
      disable_maps = false, -- set true if you want to define your own mappings
      cscope = {
        db_file = "cscope.out", -- location of cscope database
        exec = "cscope",        -- or "gtags-cscope" if using GNU Global
        picker = "telescope",   -- "telescope", "quickfix", or "fzf-lua"
      },
    })
  end,
}
