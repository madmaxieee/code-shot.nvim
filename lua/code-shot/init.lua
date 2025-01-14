local static = require("code-shot.static")
local core = require("code-shot.core")
local utils = require("code-shot.utils")

local shot = function()
	local source_file = vim.api.nvim_buf_get_name(0)
	local use_temp_source = false
	---@type {s_start: {row: number, col: number}, s_end: {row: number, col: number}} | nil
	local select_area

	if vim.fn.mode() == "v" then
		use_temp_source = true
		select_area = core.text.selected_area()
		source_file = utils.temp_file_path(source_file)
		local lines = core.lua.string.split(core.text.selection(), "\n")
		vim.fn.writefile(lines, source_file)
	elseif not core.file.file_or_dir_exists(source_file) then
		use_temp_source = true
		source_file = utils.temp_file_path(source_file)
		local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
		vim.fn.writefile(lines, source_file)
	end

	local err = false
	local args = {}

	core.lua.list.each(static.config.options(select_area), function(option)
		table.insert(args, option)
	end)

	local output_path = static.config.output()

	if static.config.to_clipboard then
		core.lua.list.each({
			"--to-clipboard",
			source_file,
		}, function(option)
			table.insert(args, option)
		end)
	else
		core.lua.list.each({
			"--output",
			output_path,
			source_file,
		}, function(option)
			table.insert(args, option)
		end)
	end

	core.job.spawn("silicon", args, {}, function()
		if not err then
			if static.config.to_clipboard then
				vim.notify("Code shot succeed, output to clipboard", vim.log.levels.INFO, {
					title = "Code Shot",
				})
			else
				vim.notify("Code shot succeed, output to " .. output_path, vim.log.levels.INFO, {
					title = "Code Shot",
				})
			end
		end
		if use_temp_source then
			vim.uv.fs_unlink(source_file)
		end
	end, function(_, data)
		if string.sub(data, 1, 9) == "[warning]" then
			vim.notify(data, vim.log.levels.WARN, { title = "Code Shot" })
			return
		end
		err = true
		vim.notify("Code shot failed, error is " .. data, vim.log.levels.ERROR, {
			title = "Code Shot",
		})
	end, function() end)
end

local setup = function(new_config)
	static.config = vim.tbl_deep_extend("force", static.config, new_config or {})
	vim.api.nvim_create_user_command("CodeShot", function()
		shot()
	end, { range = true })
end

return {
	shot = shot,
	setup = setup,
}
