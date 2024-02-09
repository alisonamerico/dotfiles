return {
    "epwalsh/pomo.nvim",
    version = "*", -- Recommended, use latest release instead of latest commit
    lazy = true,
    cmd = { "TimerStart", "TimerRepeat" },
    dependencies = {
        -- Optional, but highly recommended if you want to use the "Default" timer
        "rcarriga/nvim-notify",

    },
    config = function()
        require("pomo").setup({
            -- See below for full list of options 👇
        })
        require("notify").setup({
            background_colour = "#000000",
        })
    end,
    opts = {
        -- See below for full list of options 👇
    },
}
