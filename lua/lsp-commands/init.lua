local M = {
	_commands = {},
}

---@class lsp-commands.Command
---@field name string
---@field run fun()
---@field is_enabled (fun(): boolean) | nil

function M.register_command(category, command)
	M._commands[category] = M._commands[category] or {}
	table.insert(M._commands[category], command)
end

function M._get_item(category, command)
	return string.format("%s: %s", category, command.name)
end

function M._run_command(item)
	for category, command in pairs(M._commands) do
		if M._get_item(category, command) == item then
			category.run()
			return
		end
	end
end

function M.run_command(category)
	local items = {}
	if not category then
		for key, value in pairs(M._commands) do
			table.insert(items, M._get_item(key, value))
		end
	else
		items = vim.iter((M._commands[category] or {}))
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
