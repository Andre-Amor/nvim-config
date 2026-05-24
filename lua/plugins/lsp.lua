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
        },
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local lspconfig = vim.lsp.config
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local on_attach = function(_, bufnr)
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
                vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
                vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { buffer = bufnr })
                vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr })
                vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr })
                vim.api.nvim_create_autocmd("BufWritePre", {
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format({ async = false })
                    end,
                })
            end

            lspconfig("astro", {
                on_attach = on_attach,
                capabilities = capabilities,
            })

            lspconfig("texlab", {
                on_attach = on_attach,
                capabilities = capabilities,
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
            })
            lspconfig("clangd", {
                on_attach = on_attach,
                capabilities = capabilities,
            })
            
            lspconfig("rust_analyzer", {
                on_attach = on_attach,
                capabilities = capabilities,
            })

            lspconfig("gopls", {
                on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                    gopls = {
                        analyses = {
                            unusedparams = true,
                        },
                        staticcheck = true,
                        gofumpt = true,
                    }
                }
            })

            lspconfig("bashls", {
                on_attach = on_attach,
                capabilities = capabilities,
            })

            lspconfig("yamlls", {
                on_attach = on_attach,
                capabilities = capabilities,
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
            })
        end,
    },
} 
