# lsp-commands.nvim

[More neovim plugins](https://github.com/niuiic/awesome-neovim-plugins)

## Usage

Register lsp commands, then pick and run them.

```lua
require("lsp-commands").register_command("rename vars", {
	name = "lua_ls",
	run = function()
		vim.lsp.buf.rename(nil, {
			name = "lua_ls",
		})
	end,
	is_enabled = function()
		return #vim.lsp.get_clients({
			name = "lua_ls",
		}) > 0
	end,
})

local keys = {
	{
		"<space>lF",
		function()
			require("lsp-commands").run_command("rename file")
		end,
		desc = "rename file",
	},
	{
		"<space>lr",
		function()
			require("lsp-commands").run_command("rename vars")
		end,
		desc = "rename vars",
	},
	{
		"<space>li",
		function()
			require("lsp-commands").run_command("organize imports")
		end,
		desc = "organize imports",
	},
	{
		"<space>lf",
		function()
			require("lsp-commands").run_command("fix all")
		end,
		desc = "fix all",
	},
	{
		"<space>lR",
		"<cmd>LspRestart *<cr>",
		desc = "restart all lsp",
	},
	{
		"<space>lp",
		function()
			require("lsp-commands").run_command("copy path")
		end,
		desc = "copy path",
	},
}
```
