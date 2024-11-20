local M = {
	_commands = {},
}

---@class lsp-commands.Command
---@field name string
---@field run fun()
---@field is_enabled (fun(): boolean) | nil

---@param category string
---@param command lsp-commands.Command
function M.register_command(category, command)
	M._commands[category] = M._commands[category] or {}
	table.insert(M._commands[category], command)
end

function M._get_item(category, command)
	return string.format("%s: %s", category, command.name)
end

function M._run_command(item)
	for category, commands in pairs(M._commands) do
		for _, command in ipairs(commands) do
			if M._get_item(category, command) == item then
				command.run()
				return
			end
		end
	end
end

---@param category string | nil
function M.run_command(category)
	local items = {}
	if not category then
		for key, value in pairs(M._commands) do
			if not value.is_enabled or value.is_enabled() then
				table.insert(items, M._get_item(key, value))
			end
		end
	else
		items = vim.iter((M._commands[category] or {}))
			:filter(function(command)
				return not command.is_enabled or command.is_enabled()
			end)
			:map(function(item)
				return M._get_item(category, item)
			end)
			:totable()
	end

	if #items == 0 then
		vim.notify("No commands available", vim.log.levels.WARN)
		return
	end

	if #items == 1 then
		M._run_command(items[1])
		return
	end

	vim.ui.select(items, {
		prompt = "Select a command:",
	}, function(choice)
		if not choice then
			return
		end

		M._run_command(choice)
	end)
end

return M
