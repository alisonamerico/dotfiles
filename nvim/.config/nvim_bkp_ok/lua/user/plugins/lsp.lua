return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        -- Autocompletion
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lua",
        -- Snippets
        "L3MON4D3/LuaSnip",
        "rafamadriz/friendly-snippets",
    },
    config = function()
        local autoformat_filetypes = {
            "lua",
        }
        -- Create a keymap for vim.lsp.buf.implementation
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if not client then
                    return
                end
                if vim.tbl_contains(autoformat_filetypes, vim.bo.filetype) then
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = args.buf,
                        callback = function()
                            vim.lsp.buf.format({
                                formatting_options = { tabSize = 4, insertSpaces = true },
                                bufnr = args.buf,
                                id = client.id,
                            })
                        end,
                    })
                end
            end,
        })

        -- Add borders to floating windows
        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
        vim.lsp.handlers["textDocument/signatureHelp"] =
            vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

        -- Configure error/warnings interface
        vim.diagnostic.config({
            virtual_text = true,
            severity_sort = true,
            float = {
                style = "minimal",
                border = "rounded",
                header = "",
                prefix = "",
            },
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = "✘",
                    [vim.diagnostic.severity.WARN] = "▲",
                    [vim.diagnostic.severity.HINT] = "⚑",
                    [vim.diagnostic.severity.INFO] = "»",
                },
            },
        })

        -- Add cmp_nvim_lsp capabilities settings to lspconfig
        -- This should be executed before you configure any language server
        local lspconfig_defaults = require("lspconfig").util.default_config
        lspconfig_defaults.capabilities =
            vim.tbl_deep_extend("force", lspconfig_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

        -- This is where you enable features that only work
        -- if there is a language server active in the file
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(event)
                local opts = { buffer = event.buf }

                vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
                vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
                vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
                vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
                vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
                vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
                vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
                vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
                vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
                vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
                vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
            end,
        })

        require("mason").setup({})
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                -- "intelephense",
                -- "ts_ls",
                "eslint",
            },
            handlers = {
                -- this first function is the "default handler"
                -- it applies to every language server without a custom handler
                function(server_name)
                    require("lspconfig")[server_name].setup({})
                end,

                -- this is the "custom handler" for `lua_ls`
                lua_ls = function()
                    require("lspconfig").lua_ls.setup({
                        settings = {
                            Lua = {
                                runtime = {
                                    version = "LuaJIT",
                                },
                                diagnostics = {
                                    globals = { "vim" },
                                },
                                workspace = {
                                    library = { vim.env.VIMRUNTIME },
                                },
                            },
                            ruff = {
                                -- Notes on code actions: https://github.com/astral-sh/ruff-lsp/issues/119#issuecomment-1595628355
                                -- Get isort like behavior: https://github.com/astral-sh/ruff/issues/8926#issuecomment-1834048218
                                -- commands = {
                                --     RuffAutofix = {
                                --         function()
                                --             vim.lsp.buf.execute_command({
                                --                 command = "ruff.applyAutofix",
                                --                 arguments = {
                                --                     { uri = vim.uri_from_bufnr(0) },
                                --                 },
                                --             })
                                --         end,
                                --         description = "Ruff: Fix all auto-fixable problems",
                                --     },
                                --     RuffOrganizeImports = {
                                --         function()
                                --             vim.lsp.buf.execute_command({
                                --                 command = "ruff.applyOrganizeImports",
                                --                 arguments = {
                                --                     { uri = vim.uri_from_bufnr(0) },
                                --                 },
                                --             })
                                --         end,
                                --         description = "Ruff: Format imports",
                                --     },
                                -- },
                                lint = {
                                    enable = true, -- Enable linting
                                    preview = false, -- Disable preview mode
                                    select = { "E", "F" }, -- Enable specific rules
                                    extendSelect = { "W" }, -- Extend the selected rules
                                    ignore = {}, -- Ignore specific rules
                                    extendIgnore = {}, -- Extend the ignored rules
                                    exclude = { "**/tests/**" }, -- Exclude specific directories
                                    lineLength = 79, -- Set the line length
                                    disableRuleComment = {
                                        enable = true, -- Enable/disable disable rule comment
                                    },
                                    fixAll = true, -- Enable/disable fix all code actions
                                    organizeImports = true, -- Enable/disable organize imports code actions
                                },
                            },
                            pyright = {
                                pyright = {
                                    -- Using Ruff's import organizer
                                    disableOrganizeImports = true,
                                },
                                python = {
                                    analysis = {
                                        -- Ignore all files for analysis to exclusively use Ruff for linting
                                        ignore = { "*" },
                                        autoImportCompletions = false,
                                    },
                                },
                            },
                            tsserver = {},
                            jinja_lsp = {
                                filetypes = { "jinja", "html" },
                            },
                        },
                    })
                end,
            },
        })

        local cmp = require("cmp")

        require("luasnip.loaders.from_vscode").lazy_load()

        vim.opt.completeopt = { "menu", "menuone", "noselect" }

        cmp.setup({
            preselect = "item",
            completion = {
                completeopt = "menu,menuone,noinsert",
            },
            window = {
                documentation = cmp.config.window.bordered(),
            },
            sources = {
                { name = "path" },
                { name = "nvim_lsp" },
                { name = "buffer",  keyword_length = 3 },
                { name = "luasnip", keyword_length = 2 },
            },
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },
            formatting = {
                fields = { "abbr", "menu", "kind" },
                format = function(entry, item)
                    local n = entry.source.name
                    if n == "nvim_lsp" then
                        item.menu = "[LSP]"
                    else
                        item.menu = string.format("[%s]", n)
                    end
                    return item
                end,
            },
            mapping = cmp.mapping.preset.insert({
                -- confirm completion item
                ["<CR>"] = cmp.mapping.confirm({ select = false }),

                -- scroll documentation window
                ["<C-f>"] = cmp.mapping.scroll_docs(5),
                ["<C-u>"] = cmp.mapping.scroll_docs(-5),

                -- toggle completion menu
                ["<C-e>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.abort()
                    else
                        cmp.complete()
                    end
                end),

                -- tab complete
                ["<Tab>"] = cmp.mapping(function(fallback)
                    local col = vim.fn.col(".") - 1

                    if cmp.visible() then
                        cmp.select_next_item({ behavior = "select" })
                    elseif col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
                        fallback()
                    else
                        cmp.complete()
                    end
                end, { "i", "s" }),

                -- go to previous item
                ["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = "select" }),

                -- navigate to next snippet placeholder
                ["<C-d>"] = cmp.mapping(function(fallback)
                    local luasnip = require("luasnip")

                    if luasnip.jumpable(1) then
                        luasnip.jump(1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),

                -- navigate to the previous snippet placeholder
                ["<C-b>"] = cmp.mapping(function(fallback)
                    local luasnip = require("luasnip")

                    if luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),
        })
    end,
}

-- return { -- LSP Configuration & Plugins
--     "neovim/nvim-lspconfig",
--     dependencies = {
--         -- Automatically install LSPs and related tools to stdpath for neovim
--         "williamboman/mason.nvim",
--         "williamboman/mason-lspconfig.nvim",
--         "WhoIsSethDaniel/mason-tool-installer.nvim",
--
--         -- Useful status updates for LSP.
--         -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
--         {
--             "j-hui/fidget.nvim",
--             tag = "v1.4.0",
--             opts = {
--                 progress = {
--                     display = {
--                         done_icon = "✓", -- Icon shown when all LSP progress tasks are complete
--                     },
--                 },
--                 notification = {
--                     window = {
--                         winblend = 0, -- Background color opacity in the notification window
--                     },
--                 },
--             },
--         },
--     },
--     config = function()
--         vim.api.nvim_create_autocmd("LspAttach", {
--             group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
--             -- Create a function that lets us more easily define mappings specific LSP related items.
--             -- It sets the mode, buffer and description for us each time.
--             callback = function(event)
--                 local map = function(keys, func, desc)
--                     vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
--                 end
--
--                 -- Jump to the definition of the word under your cursor.
--                 --  This is where a variable was first declared, or where a function is defined, etc.
--                 --  To jump back, press <C-T>.
--                 map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
--
--                 -- Find references for the word under your cursor.
--                 map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
--
--                 -- Jump to the implementation of the word under your cursor.
--                 --  Useful when your language has ways of declaring types without an actual implementation.
--                 map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
--
--                 -- Jump to the type of the word under your cursor.
--                 --  Useful when you're not sure what type a variable is and you want to see
--                 --  the definition of its *type*, not where it was *defined*.
--                 map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
--
--                 -- Fuzzy find all the symbols in your current document.
--                 --  Symbols are things like variables, functions, types, etc.
--                 map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
--
--                 -- Fuzzy find all the symbols in your current workspace
--                 --  Similar to document symbols, except searches over your whole project.
--                 map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
--
--                 -- Rename the variable under your cursor
--                 --  Most Language Servers support renaming across files, etc.
--                 map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
--
--                 -- Execute a code action, usually your cursor needs to be on top of an error
--                 -- or a suggestion from your LSP for this to activate.
--                 map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
--
--                 -- Opens a popup that displays documentation about the word under your cursor
--                 --  See `:help K` for why this keymap
--                 map("K", vim.lsp.buf.hover, "Hover Documentation")
--
--                 -- WARN: This is not Goto Definition, this is Goto Declaration.
--                 --  For example, in C this would take you to the header
--                 map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
--
--                 map("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
--                 map("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
--                 map("<leader>wl", function()
--                     print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
--                 end, "[W]orkspace [L]ist Folders")
--
--                 -- The following two autocommands are used to highlight references of the
--                 -- word under your cursor when your cursor rests there for a little while.
--                 --    See `:help CursorHold` for information about when this is executed
--                 --
--                 -- When you move your cursor, the highlights will be cleared (the second autocommand).
--                 local client = vim.lsp.get_client_by_id(event.data.client_id)
--                 if client and client.server_capabilities.documentHighlightProvider then
--                     vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
--                         buffer = event.buf,
--                         callback = vim.lsp.buf.document_highlight,
--                     })
--
--                     vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
--                         buffer = event.buf,
--                         callback = vim.lsp.buf.clear_references,
--                     })
--                 end
--             end,
--         })
--
--         local capabilities = vim.lsp.protocol.make_client_capabilities()
--         capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
--
--         -- Enable the following language servers
--         local servers = {
--             lua_ls = {
--                 -- cmd = {...},
--                 -- filetypes { ...},
--                 -- capabilities = {},
--                 settings = {
--                     Lua = {
--                         runtime = { version = "LuaJIT" },
--                         workspace = {
--                             checkThirdParty = false,
--                             -- Tells lua_ls where to find all the Lua files that you have loaded
--                             -- for your neovim configuration.
--                             library = {
--                                 "${3rd}/luv/library",
--                                 unpack(vim.api.nvim_get_runtime_file("", true)),
--                             },
--                             -- If lua_ls is really slow on your computer, you can try this instead:
--                             -- library = { vim.env.VIMRUNTIME },
--                         },
--                         completion = {
--                             callSnippet = "Replace",
--                         },
--                         telemetry = { enable = false },
--                         diagnostics = { disable = { "missing-fields" } },
--                     },
--                 },
--             },
--             pylsp = {
--                 settings = {
--                     pylsp = {
--                         plugins = {
--                             pyflakes = { enabled = false },
--                             pycodestyle = { enabled = false },
--                             autopep8 = { enabled = false },
--                             yapf = { enabled = false },
--                             mccabe = { enabled = false },
--                             pylsp_mypy = { enabled = false },
--                             pylsp_black = { enabled = false },
--                             pylsp_isort = { enabled = false },
--                         },
--                     },
--                 },
--             },
--             -- basedpyright = {
--             --   -- Config options: https://github.com/DetachHead/basedpyright/blob/main/docs/settings.md
--             --   settings = {
--             --     basedpyright = {
--             --       disableOrganizeImports = true, -- Using Ruff's import organizer
--             --       disableLanguageServices = false,
--             --       analysis = {
--             --         ignore = { '*' },                 -- Ignore all files for analysis to exclusively use Ruff for linting
--             --         typeCheckingMode = 'off',
--             --         diagnosticMode = 'openFilesOnly', -- Only analyze open files
--             --         useLibraryCodeForTypes = true,
--             --         autoImportCompletions = true,     -- whether pyright offers auto-import completions
--             --       },
--             --     },
--             --   },
--             -- },
--             ruff = {
--                 -- Notes on code actions: https://github.com/astral-sh/ruff-lsp/issues/119#issuecomment-1595628355
--                 -- Get isort like behavior: https://github.com/astral-sh/ruff/issues/8926#issuecomment-1834048218
--                 commands = {
--                     RuffAutofix = {
--                         function()
--                             vim.lsp.buf.execute_command({
--                                 command = "ruff.applyAutofix",
--                                 arguments = {
--                                     { uri = vim.uri_from_bufnr(0) },
--                                 },
--                             })
--                         end,
--                         description = "Ruff: Fix all auto-fixable problems",
--                     },
--                     RuffOrganizeImports = {
--                         function()
--                             vim.lsp.buf.execute_command({
--                                 command = "ruff.applyOrganizeImports",
--                                 arguments = {
--                                     { uri = vim.uri_from_bufnr(0) },
--                                 },
--                             })
--                         end,
--                         description = "Ruff: Format imports",
--                     },
--                 },
--             },
--             jsonls = {},
--             sqlls = {},
--             terraformls = {},
--             yamlls = {},
--             bashls = {},
--             dockerls = {},
--             docker_compose_language_service = {},
--             -- tailwindcss = {},
--             -- graphql = {},
--             -- html = { filetypes = { 'html', 'twig', 'hbs' } },
--             -- cssls = {},
--             -- ltex = {},
--             -- texlab = {},
--         }
--
--         -- Ensure the servers and tools above are installed
--         require("mason").setup()
--
--         -- You can add other tools here that you want Mason to install
--         -- for you, so that they are available from within Neovim.
--         local ensure_installed = vim.tbl_keys(servers or {})
--         vim.list_extend(ensure_installed, {
--             "stylua", -- Used to format lua code
--         })
--         require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
--
--         require("mason-lspconfig").setup({
--             handlers = {
--                 function(server_name)
--                     local server = servers[server_name] or {}
--                     -- This handles overriding only values explicitly passed
--                     -- by the server configuration above. Useful when disabling
--                     -- certain features of an LSP (for example, turning off formatting for tsserver)
--                     server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
--                     require("lspconfig")[server_name].setup(server)
--                 end,
--             },
--         })
--     end,
-- }
