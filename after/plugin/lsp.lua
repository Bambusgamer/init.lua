local lsp = require("lsp-zero")

lsp.preset("recommended")

-- lsp.ensure_installed({
--   'tsserver',
--   'eslint',
--   'sumneko_lua',
--   'rust_analyzer',
-- })

require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = {
		"tsserver",
        -- "ts_ls",
		"eslint",
		"lua_ls",
		"rust_analyzer"
	},
	handlers = {
		function(server_name)
			require("lspconfig")[server_name].setup({})
		end,
		["tsserver"] = function()
			require("lspconfig").ts_ls.setup({
				settings = {
					completions = {
						completeFunctionCalls = true,
					},
				},
			})
		end,
	}
})

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
		['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
		['<C-y>'] = cmp.mapping.confirm({ select = true }),
		["<C-Space>"] = cmp.mapping.complete(),
	}),
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end,
	},
})

lsp.extend_lspconfig()

lsp.set_preferences({
  sign_icons = { }
})

lsp.on_attach(function(client, bufnr)
lsp.default_keymaps({buffer = bufnr})

  local opts = {buffer = bufnr, remap = false}

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.setup()

-- Function to restart all active LSP clients
local function restart_lsp()
  for _, client in pairs(vim.lsp.get_active_clients()) do
    client.stop()
  end
  vim.cmd("edit") -- Reload the current buffer to reattach the LSP clients
end

-- Create a Neovim command to restart LSP
vim.api.nvim_create_user_command('LspRestart', restart_lsp, {})
