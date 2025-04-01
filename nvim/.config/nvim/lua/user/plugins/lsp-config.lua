return {
  -- Main LSP Configuration
  "neovim/nvim-lspconfig",
  dependencies = {
    { "williamboman/mason.nvim", opts = {} },
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    { "j-hui/fidget.nvim", opts = {} },
  },
  config = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or "n"
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        map("gd", require("fzf-lua").lsp_definitions, "[G]oto [D]efinition")
        map("gr", require("fzf-lua").lsp_references, "[G]oto [R]eferences")
        map("gI", require("fzf-lua").lsp_implementations, "[G]oto [I]mplementation")
        map("<leader>D", require("fzf-lua").lsp_typedefs, "Type [D]efinition")
        map("<leader>ds", require("fzf-lua").lsp_document_symbols, "[D]ocument [S]ymbols")
        map("<leader>ws", require("fzf-lua").lsp_live_workspace_symbols, "[W]orkspace [S]ymbols")
        map("<leader>cr", vim.lsp.buf.rename, "[R]e[n]ame")
        map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
        map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

        -- Highlight references
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method("textDocument/documentHighlight") then
          local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end,
    })

    -- Diagnostic Config
    vim.diagnostic.config({
      severity_sort = true,
      float = { border = "rounded", source = "if_many" },
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "󰅚 ", -- Error icon
          [vim.diagnostic.severity.WARN] = "󰀪 ", -- Warning icon
          [vim.diagnostic.severity.INFO] = "󰋽 ", -- Info icon
          [vim.diagnostic.severity.HINT] = "󰌶 ", -- Hint icon
        },
      },
      virtual_text = {
        source = "if_many",
        spacing = 2,
        format = function(diagnostic)
          return diagnostic.message
        end,
      },
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()

    -- Enable the following language servers
    local servers = {
      bashls = {},
      marksman = {},
      lua_ls = {},
      pyright = {},
      ruff = {
        init_options = {
          settings = {
            args = { "--line-length=79" }, -- like Python doc
            lint = {
              enable = true,
              run = "onType",
            },
            organizeImports = true,
            fixAll = true,
          },
        },
      },
    }

    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      "stylua",
    })

    require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

    require("mason-lspconfig").setup({
      ensure_installed = {},
      automatic_installation = false,
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
          require("lspconfig")[server_name].setup(server)
        end,
      },
    })
  end,
}
-- return {
--   {
--     "williamboman/mason.nvim",
--     lazy = false,
--     config = function()
--       require("mason").setup()
--     end,
--   },
--   {
--     "williamboman/mason-lspconfig.nvim",
--     lazy = false,
--     opts = {
--       auto_install = true,
--     },
--   },
--   {
--     "neovim/nvim-lspconfig",
--     lazy = false,
--     config = function()
--       local capabilities = require("cmp_nvim_lsp").default_capabilities()
--
--       local lspconfig = require("lspconfig")
--       lspconfig.lua_ls.setup({
--         settings = {
--           Lua = {
--             diagnostics = {
--               globals = { "vim" },
--             },
--           },
--         },
--         capabilities = capabilities,
--       })
--       lspconfig.pyright.setup({
--         -- pyright = {
--         settings = {
--           pyright = {
--             disableOrganizeImports = true, -- Using Ruff
--           },
--           python = {
--             analysis = {
--               ignore = { "*" }, -- Using Ruff
--               typeCheckingMode = "off", -- Using mypy
--             },
--           },
--         },
--         -- }
--       })
--       -- lspconfig.ruff_lsp.setup({
--       --   capabilities = capabilities,
--       -- })
--       lspconfig.html.setup({
--         capabilities = capabilities,
--       })
--       vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
--       vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
--       vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
--       vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
--     end,
--   },
-- }
