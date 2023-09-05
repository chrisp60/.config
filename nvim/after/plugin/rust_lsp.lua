local capabilities = require('cmp_nvim_lsp').default_capabilities()

require('lspconfig').rust_analyzer.setup({
    capabilities = capabilities,
    settings = {
        ["rust-analyzer"] = {
            imports = {
                granularity = {
                    group = "crate",
                    enforce = true,
                },
                group = {
                    enable = true,
                },
                merge = {
                    glob = false,
                },
                prefix = "crate",
            },
            interpret = {
                tests = true,
            },
            cargo = {
                buildScripts = {
                    enable = true,
                },
                features = "all",
            },
            check = {
                command = "clippy"
            },
            hover = {
                links = {
                    enable = false,
                },
            },
            completion = {
                callable = {
                    snippets = "fill_arguments",
                },
                postfix = {
                    enable = false,
                },
            },
            references = {
                excludeImports = {
                    enable = true,
                }
            },
            hover = {
                memoryLayout = {
                    size = 'both',
                    enable = true,
                    niches = true,
                },
            },
            diagnostics = {
                disabled = { "inactive-code" },
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
