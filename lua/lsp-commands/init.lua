local M = {
	_commands = {},
}

---@class lsp-commands.Command
---@field name string
---@field run fun()
---@field is_enabled (fun(): boolean) | nil

---@param command lsp-commands.Command
function M.register_command(command)
	M._commands[command.name] = command
end

---@param filter (fun(name): boolean) | nil
---@param silent boolean | nil
function M.run_command(filter, silent)
	local items = {}
	for name, command in pairs(M._commands) do
		if not filter or filter(name) then
			if not command.is_enabled or command.is_enabled() then
				table.insert(items, name)
			end
		end
	end

	if #items == 0 then
		vim.notify("No commands available", vim.log.levels.WARN)
		return
	end

	if #items == 1 then
		if not silent then
			vim.notify(string.format("Running command: %s", items[1]), vim.log.levels.INFO)
		end
		M._commands[items[1]].run()
		return
	end

	vim.ui.select(items, {
		prompt = "Select a command:",
	}, function(choice)
		if not choice then
			return
		end

		if not silent then
			vim.notify(string.format("Running command: %s", choice), vim.log.levels.INFO)
		end
		M._commands[choice].run()
	end)
end

return M
