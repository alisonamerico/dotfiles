return {
  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    version = false,
    event = "BufReadPre",
    dependencies = {
      {
        "folke/neodev.nvim",
        config = function()
          require("neodev").setup({
            library = { plugins = { "neotest", "plenary.nvim" }, types = true, setup_jsonls = false },
          })
        end,
      },
      { "williamboman/mason.nvim",          config = true, cmd = "Mason" },
      "nvim-telescope/telescope.nvim",
      { "williamboman/mason-lspconfig.nvim" },
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- installing tools
      local tools = {
        "stylua",
        "blue",
        "prettier",
        "shfmt",
        "shellcheck",
        "yamllint",
      }
      for _, f in pairs(tools) do
        local pkg = require("mason-registry").get_package(f)
        if not pkg:is_installed(f) then
          pkg:install(f)
        end
      end

      -- diagnostics
      vim.diagnostic.config({
        virtual_text = { spacing = 4 },
        severity_sort = true,
      })

      -- lspconfig
      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local buffer = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          require("a.plugins.lsp.format").on_attach(client, buffer)
          require("a.plugins.lsp.keymaps").on_attach(client, buffer)
        end,
      })

      -- lsp config info
      vim.api.nvim_create_user_command("LspConfig", function()
        local clients = vim.lsp.get_active_clients({ bufnr = 0 })
        local config
        for _, client in ipairs(clients) do
          if client.name ~= "null-ls" then
            config = client.config
          end
        end
        P(config)
      end, { nargs = 0 })

      -- setup servers
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                callSnippet = "Replace",
              },
              format = { enable = false },
            },
          },
        },
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "off",
              },
            },
          },
        },
        bashls = {},
        yamlls = {},
        jsonls = {},
        dockerls = {},
        ruff_lsp = {
          init_options = {
            settings = {
              -- Any extra CLI arguments for `ruff` go here.
              args = {
                '--line-length=79',
              },
            }
          }
        },
      }

      require("mason-lspconfig").setup({ ensure_installed = vim.tbl_keys(servers) })
      require("mason-lspconfig").setup_handlers({
        function(server)
          local server_opts = servers[server]
          server_opts.capabilities = capabilities
          require("lspconfig")[server].setup(server_opts)
        end,
      })
    end,
  },

  -- formatters
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufReadPre",
    opts = function()
      local nls = require("null-ls")
      local formatting = nls.builtins.formatting
      local diagnostics = nls.builtins.diagnostics
      local actions = nls.builtins.code_actions
      return {
        sources = {
          -- formatting
          formatting.prettier.with({
            filetypes = { "json", "markdown", "toml", },
          }),
          formatting.shfmt,
          formatting.stylua.with({
            extra_args = function(_)
              -- using default .stylua.toml file or project's one
              local base_cfg = vim.fn.stdpath("config") .. "/.stylua.toml"
              local cfg = vim.fs.find({ ".stylua.toml", "stylua.toml" }, { upward = true })
              if #cfg == 0 then
                ---@diagnostic disable-next-line: cast-local-type
                cfg = base_cfg
              else
                cfg = cfg[1]
              end
              return { "--config-path", cfg }
            end,
          }),
          formatting.blue,

          -- diagnostics
          -- diagnostics.flake8,
          -- diagnostics.ruff,
          diagnostics.djlint,
          diagnostics.shellcheck,
          diagnostics.yamllint.with({
            extra_args = { "-d", "{extends: relaxed, rules: {line-length: {max: 200}}}" },
          }),

          -- actions
          actions.shellcheck,
        },
      }
    end,
  },
}