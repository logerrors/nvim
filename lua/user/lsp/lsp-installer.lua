local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
	return
end

local servers = {
	sumneko_lua = require("user.lsp.settings.sumneko_lua"), -- lua/lsp/config/lua.lua
	cmake = require("user.lsp.settings.cmake"),
	ccls = require("user.lsp.settings.ccls"),
  clangd = require("user.lsp.settings.clangd")
	-- rust_analyzer = require("lsp.lang.rust"),
	-- jsonls = require("lsp.lang.json"),
	-- tsserver = require("lsp.config.ts"),
	-- remark_ls = require("lsp.lang.markdown"),
	-- html = {},
}

for name, _ in pairs(servers) do
	local server_is_found, server = lsp_installer.get_server(name)
	if server_is_found then
	  if not server:is_installed() then
		print("Installing " .. name)
		server:install()
	  end
	end
  end

-- Register a handler that will be called for all installed servers.
-- Alternatively, you may also register handlers on specific server instances instead (see example below).
lsp_installer.on_server_ready(function(server)
	local opts = {
		on_attach = require("user.lsp.handlers").on_attach,
		capabilities = require("user.lsp.handlers").capabilities,
	}

	local config = servers[server.name]
	if config ~= nil then
		opts = vim.tbl_deep_extend("force", config, opts)
	end

	-- This setup() function is exactly the same as lspconfig's setup function.
	-- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
	server:setup(opts)
end)

