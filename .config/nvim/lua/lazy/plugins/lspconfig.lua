return {
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {},
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},

		config = function() 

			-- vstsls
			vim.lsp.config('vtsls', {
				settings = {
					complete_function_calls = true,
					vtsls = {
						enableMoveToFileCodeAction = true,
						autoUseWorkspaceTsdk = true,
						experimental = {
							maxInlayHintLength = 30,
							completion = {
								enableServerSideFuzzyMatch = true,
							},
						},
					},
					typescript = {
						updateImportsOnFileMove = { enabled = "always" },
						suggest = {
							completeFunctionCalls = true,
						},
						inlayHints = {
							enumMemberValues = { enabled = true },
							functionLikeReturnTypes = { enabled = true },
							parameterNames = { enabled = "literals" },
							parameterTypes = { enabled = true },
							propertyDeclarationTypes = { enabled = true },
							variableTypes = { enabled = false },
						},
					},
				},
				filetypes = { 
					"javascript",
					"javascriptreact",
					"javascript.jsx",
					"typescript",
					"typescriptreact",
					"typescript.tsx",
				},
			})

			-- lua_ls
			vim.diagnostic.config{
				virtual_text = false,  -- floating text next to code is too noisy.
				underline = true,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "",
						[vim.diagnostic.severity.WARN]  = "",
						[vim.diagnostic.severity.INFO]  = "",
						[vim.diagnostic.severity.HINT]  = "",
					},
					linehl = {
						[vim.diagnostic.severity.ERROR] = 'ErrorMsg',
					},
					numhl = {
						[vim.diagnostic.severity.WARN] = 'WarningMsg',
					},
				},
			}

			vim.lsp.config('lua_ls', {
				on_init = function(client)
					if client.workspace_folders then
						local path = client.workspace_folders[1].name
						if
							path ~= vim.fn.stdpath('config')
							and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
							then
								return
							end
						end

						client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
							runtime = {
								-- Tell the language server which version of Lua you're using (most
								-- likely LuaJIT in the case of Neovim)
								version = 'LuaJIT',
								-- Tell the language server how to find Lua modules same way as Neovim
								-- (see `:h lua-module-load`)
							path = {
									'lua/?.lua',
									'lua/?/init.lua',
								},
							},
							-- Make the server aware of Neovim runtime files
							workspace = {
								checkThirdParty = false,
								library = {
									vim.env.VIMRUNTIME,
								},
							},
						})
					end,
					settings = {
						Lua = {},
					},
				})

				require("mason-lspconfig").setup {
					ensure_installed = { 
						"lua_ls", 
						"rust_analyzer", 
						"stylua", 
						"vtsls",  
						"cssls",
						"html",
						"pyright",
						-- "clangd",
						"tailwindcss",
						"tombi",	
						"bashls",
						"vimls",
					},
				}
			end
		}
	}

