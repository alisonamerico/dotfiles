-- return {
--     "stevearc/conform.nvim",
--     opts = {
--         formatters_by_ft = {
--             lua = { "stylua" },
--             -- Conform will run multiple formatters sequentially
--             python = { "ruff" },
--             javascript = { "prettierd", "prettier", stop_after_first = true },
--             typescript = { "prettierd", "prettier", stop_after_first = true },
--         },
--         format_on_save = {
--             -- These options will be passed to conform.format()
--             timeout_ms = 500,
--             lsp_format = "fallback",
--         },
--     },
-- }
--https://github.com/hendrikmi/dotfiles/blob/main/nvim/lua/plugins/none-ls.lua
-- Format on save and linters
return {
    "nvimtools/none-ls.nvim",
    dependencies = {
        "nvimtools/none-ls-extras.nvim",
        "jayp0521/mason-null-ls.nvim", -- ensure dependencies are installed
    },

    config = function()
        local null_ls = require("null-ls")
        local formatting = null_ls.builtins.formatting   -- to setup formatters
        local diagnostics = null_ls.builtins.diagnostics -- to setup linters

        -- list of formatters & linters for mason to install
        require("mason-null-ls").setup({
            ensure_installed = {
                "checkmake",
                "prettier", -- ts/js formatter
                "stylua",   -- lua formatter
                "eslint_d", -- ts/js linter
                "shfmt",
                "ruff",     -- python formatter
                -- "blue", -- python formatter (alternative)
            },
            -- auto-install configured formatters & linters (with null-ls)
            automatic_installation = true,
        })

        local sources = {
            diagnostics.checkmake,
            formatting.prettier.with({ filetypes = { "html", "jinja", "htmldjango", "json", "yaml", "markdown" } }),
            formatting.stylua,
            formatting.shfmt.with({ args = { "-i", "4" } }),
            formatting.terraform_fmt,
            require("none-ls.formatting.ruff").with({
                extra_args = {
                    "--extend-select",
                    "I",
                    "--line-length",
                    "79",
                },
            }),
            require("none-ls.formatting.ruff_format").with({
                extra_args = { "--line-length", "79" },
            }),
        }

        local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
        null_ls.setup({
            -- debug = true, -- Enable debug mode. Inspect logs with :NullLsLog.
            sources = sources,
            -- you can reuse a shared lspconfig on_attach callback here
            on_attach = function(client, bufnr)
                if client:supports_method("textDocument/formatting") then
                    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = augroup,
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({ async = false })
                        end,
                    })
                end
            end,
        })
    end,
}
-- Format on save and linters
-- return {
--   "nvimtools/none-ls.nvim",
--   dependencies = {
--     "nvimtools/none-ls-extras.nvim",
--     "jayp0521/mason-null-ls.nvim", -- ensure dependencies are installed
--   },
--   config = function()
--     local null_ls = require("null-ls")
--     local formatting = null_ls.builtins.formatting -- to setup formatters
--     local diagnostics = null_ls.builtins.diagnostics -- to setup linters
--
--     -- list of formatters & linters for mason to install
--     require("mason-null-ls").setup({
--       ensure_installed = {
--         "checkmake",
--         "prettier", -- ts/js formatter
--         "stylua", -- lua formatter
--         "eslint_d", -- ts/js linter
--         "shfmt",
--         "ruff", -- python formatter
--         "blue", -- python formatter (alternative)
--       },
--       -- auto-install configured formatters & linters (with null-ls)
--       automatic_installation = true,
--     })
--
--     -- Common sources (non-Python formatters)
--     local sources = {
--       diagnostics.checkmake,
--       formatting.prettier.with({ filetypes = { "html", "json", "yaml", "markdown" } }),
--       formatting.stylua,
--       formatting.shfmt.with({ args = { "-i", "4" } }),
--       formatting.terraform_fmt,
--     }
--
--     -- Set up the format on save autocmd
--     local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
--
--     null_ls.setup({
--       sources = sources,
--
--       on_attach = function(client, bufnr)
--         if client.supports_method("textDocument/formatting") then
--           vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
--           vim.api.nvim_create_autocmd("BufWritePre", {
--             group = augroup,
--             buffer = bufnr,
--             callback = function()
--               -- Only apply conditional formatting for Python files
--               if vim.bo.filetype == "python" then
--                 -- Get the current file path
--                 local current_file = vim.fn.expand("%:p")
--                 local ball_path = vim.fn.expand("~/work/ball")
--
--                 -- Check if we're in the ball project
--                 if string.find(current_file, ball_path) == 1 then
--                   -- We're in the ball project, use ruff
--                   local ruff_cmd = "ruff format --line-length 79 " .. vim.fn.shellescape(current_file)
--                   vim.cmd("silent !clear && " .. ruff_cmd)
--                   vim.cmd("edit") -- Reload the file
--                 else
--                   -- We're not in the ball project, use blue
--                   local blue_cmd = "blue --line-length 79 " .. vim.fn.shellescape(current_file)
--                   vim.cmd("silent !clear && " .. blue_cmd)
--                   vim.cmd("edit") -- Reload the file
--                 end
--               else
--                 -- For non-Python files, use the regular LSP formatting
--                 vim.lsp.buf.format({ async = false })
--               end
--             end,
--           })
--         end
--       end,
--     })
--   end,
-- }
