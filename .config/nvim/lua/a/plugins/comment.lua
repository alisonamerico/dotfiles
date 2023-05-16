-- [[ Comment ]]
-- Smart and Powerful commenting plugin for neovim.
-- https://github.com/numToStr/Comment.nvim

return {
    {
        -- commenting with gc. Ex: (gc2j (Down) - gc4k(Up)) motions
        "numToStr/Comment.nvim",
        config = function()
            -- import comment plugin safely
            local setup, comment = pcall(require, "Comment")
            if not setup then
                return
            end

            -- enable comment
            comment.setup()
        end
    }

}
