# lsp-commands.nvim

[More neovim plugins](https://github.com/niuiic/awesome-neovim-plugins)

## Usage

Register lsp commands, then pick and run them.

```lua
---@param filter (fun(name): boolean) | nil
---@param silent boolean | nil
function M.run_command(filter, silent) end

---@param command lsp-commands.Command
function M.register_command(command) end

---@class lsp-commands.Command
---@field name string
---@field run fun()
---@field is_enabled (fun(): boolean) | nil
```
