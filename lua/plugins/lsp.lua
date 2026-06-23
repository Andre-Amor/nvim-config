return {
    {
        "williamboman/mason.nvim",
        config = true,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        opts = {
            ensure_installed = { "astro", "texlab", "clangd", "rust_analyzer", "gopls", "bashls", "yamlls" },
            automatic_enable = false,
        },
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local on_attach = function(_, bufnr)
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
                vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
                vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { buffer = bufnr })
                vim.keymap.set("n", "[d", function()
                    vim.diagnostic.jump({ count = -1, float = true })
                end, { buffer = bufnr })
                vim.keymap.set("n", "]d", function()
                    vim.diagnostic.jump({ count = 1, float = true })
                end, { buffer = bufnr })
                vim.api.nvim_create_autocmd("BufWritePre", {
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format({ async = false })
                    end,
                })
            end

            local servers = {
                astro = {},
                texlab = {
                    settings = {
                        texlab = {
                            build = {
                                executable = "latexmk",
                                args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
                                onSave = true,
                            },
                            forwardSearch = {
                                executable = "zathura",
                                args = { "--synctex-forward", "%l:1:%f", "%p" },
                            },
                        },
                    },
                },
                clangd = {},
                rust_analyzer = {},
                gopls = {
                    settings = {
                        gopls = {
                            analyses = {
                                unusedparams = true,
                            },
                            staticcheck = true,
                            gofumpt = true,
                        },
                    },
                },
                bashls = {},
                yamlls = {
                    settings = {
                        yaml = {
                            completion = true,
                            hover = true,
                            validate = true,
                            schemas = {
                                kubernetes = {
                                    "k8s/**/*.yaml",
                                    "k8s/**/*.yml",
                                    "kubernetes/**/*.yaml",
                                    "kubernetes/**/*.yml",
                                    "manifests/**/*.yaml",
                                    "manifests/**/*.yml",
                                    "deploy/**/*.yaml",
                                    "deploy/**/*.yml",
                                    "*.k8s.yaml",
                                    "*.k8s.yml",
                                },
                            },
                            kubernetesCRDStore = {
                                enable = true,
                            },
                        },
                    },
                },
            }

            for server, config in pairs(servers) do
                config.on_attach = on_attach
                config.capabilities = capabilities
                vim.lsp.config(server, config)
                vim.lsp.enable(server)
            end
        end,
    },
} 
