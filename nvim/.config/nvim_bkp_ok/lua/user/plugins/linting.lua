return {
    "mfussenegger/nvim-lint",
    event = {
        "BufReadPre",
        "BufNewFile",
    },
    config = function()
        local lint = require("lint")
        lint.linters_by_ft = {
            html = { "eslint_d" },
            javascript = { "eslint_d" },
            typescript = { "eslint_d" },
            javascriptreact = { "eslint_d" },
            typescriptreact = { "eslint_d" },
            svelte = { "eslint_d" },
            jinja = { "eslint_d" },
            python = { "ruff" },
            -- htmldjango = { "djlint" },
        }

        -- Configure djlint (optional but recommended)
        lint.linters.djlint = {
            cmd = "djlint",
            args = { "--linting-error-code=E" },
            stdin = false,
            ignore_exitcode = true,
        }

        local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
            group = lint_augroup,
            callback = function()
                lint.try_lint()
            end,
        })
        vim.keymap.set("n", "<leader>l", function()
            lint.try_lint()
        end, { desc = "Trigger linting for current file" })
    end,
}
-- return {}
