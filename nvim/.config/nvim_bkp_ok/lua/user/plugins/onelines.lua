return {
    { -- This helps with ssh tunneling and copying to clipboard
        "ojroques/vim-oscyank",
    },
    { -- This generates docblocks
        "kkoomen/vim-doge",
        build = ":call doge#install()",
    },
    { -- Show historical versions of the file locally
        "mbbill/undotree",
    },
    { "stevearc/dressing.nvim" },
    { -- Show CSS Colors
        "brenoprata10/nvim-highlight-colors",
        config = function()
            require("nvim-highlight-colors").setup({})
        end,
    },
    {
        "danymat/neogen",
        -- config = true,
        -- Uncomment next line if you want to follow only stable versions
        version = "*",
        config = function()
            require("neogen").setup({
                enabled = true,
                languages = {
                    python = {
                        template = {
                            annotation_convention = "google_docstrings", -- for a full list of annotation_conventions, see supported-languages below,
                        },
                    },
                },
            })
        end,
    },
}
