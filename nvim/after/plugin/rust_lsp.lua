local capabilities = require('cmp_nvim_lsp').default_capabilities()

require('lspconfig').rust_analyzer.setup({
    capabilities = capabilities,
    settings = {
        ["rust-analyzer"] = {
            imports = {
                granularity = {
                    group = "module",
                },
                prefix = "self",
            },
            cargo = {
                features = "all",
                buildScripts = {
                    enable = true,
                },
            },
            check = {
                command = "clippy"
            },
            hover = {
                links = {
                    enable = false,
                },
                actions = {
                    debug = {
                        enable = true,
                    }
                }
            },
            completion = {
                callable = {
                    snippets = "fill_arguments",
                },
                postfix = {
                    enable = true
                },
            },
            inlayHints = {
                typeHints = {
                    enable = true,
                }
            },
            references = {
                excludeImports = {
                    enable = true,
                }
            },
            procMacro = {
                enable = true,
                attributes = {
                    enable = true,
                }
            },
        }
    }
})
