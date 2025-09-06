return {
  -- CodeCompanion (chat + inline AI)
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ravitemer/mcphub.nvim",
    },
    config = function()
      require("codecompanion").setup({
        strategies = {
          chat = {
            adapter = "copilot",
            model = "gpt-4.1",
          },
          inline = {
            adapter = "copilot",
            model = "gpt-4.1",
          },
        },
        extensions = {
          mcphub = {
            callback = "mcphub.extensions.codecompanion",
            opts = {
              make_vars = true,
              make_slash_commands = true,
              show_result_in_chat = true,
            },
          },
        },
      })

      -- Keymaps for CodeCompanion
      vim.keymap.set("n", "<leader>ac", "<cmd>CodeCompanionChat<cr>", { desc = "AI Chat (CodeCompanion)" })
      vim.keymap.set("v", "<leader>ac", "<cmd>CodeCompanionChat<cr>", { desc = "AI Chat (CodeCompanion)" })

      -- Close chat (only if it’s a CodeCompanion buffer)
      vim.keymap.set("n", "<leader>ax", function()
        local bufname = vim.api.nvim_buf_get_name(0)
        if bufname:match("CodeCompanion") then
          pcall(vim.cmd, "close")
        else
          vim.notify("Not in a CodeCompanion chat buffer", vim.log.levels.WARN)
        end
      end, { desc = "Close AI Chat (CodeCompanion)" })
    end,
  },

  -- Copilot core (vim plugin)
  {
    "github/copilot.vim",
    cmd = "Copilot",
  },

  -- Copilot completion source for cmp
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "github/copilot.vim" },
    config = function()
      require("copilot_cmp").setup()
    end,
  },

  -- nvim-cmp + sources
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
      "onsails/lspkind.nvim",
      "zbirenbaum/copilot-cmp",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        completion = {
          completeopt = "menu,menuone,preview,noselect",
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
          ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),

          -- Accept and refine with CodeCompanion inline
          ["<C-r>"] = cmp.mapping(function(fallback)
            local entry = cmp.get_selected_entry()
            if entry then
              cmp.confirm({ select = true })
              vim.defer_fn(function()
                vim.cmd("CodeCompanionInlineEvaluate")
              end, 100)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "copilot", group_index = 1 }, -- Copilot AI completions
          { name = "nvim_lsp", group_index = 1 }, -- LSP completions
          { name = "luasnip" }, -- Snippets
          { name = "buffer" },
          { name = "path" },
        }),
        formatting = {
          format = require("lspkind").cmp_format({
            maxwidth = 50,
            ellipsis_char = "...",
          }),
        },
      })
    end,
  },
}
