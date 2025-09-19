return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    ensure_install = {
      "clangd",
      "lua_ls",
    },
    opts = {
      auto_install = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      vim.lsp.config.lua_ls = {
        capabilities = capabilities,
      }

      vim.lsp.config.clangd = {
        capabilities = capabilities,
        cmd = {
          "clangd",
          "--background-index",
          "--suggest-missing-includes",
          "--cross-file-rename",
          "--completion-style=detailed",
          "--header-insertion=never",
        },
        root_markers = { "compile_commands.json", ".git" },
      }

      vim.lsp.enable('lua_ls')
      vim.lsp.enable('clangd')
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
    end,
  },

  vim.diagnostic.config({
    signs = false,
    underline = false,
  })
}
