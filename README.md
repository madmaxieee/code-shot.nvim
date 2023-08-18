# code-shot.nvim

Take a picture of the code.

Similar features to [silicon.nvim](https://github.com/krivahtoo/silicon.nvim), keep simple, keep reliable.

## Dependencies

- [silicon](https://github.com/Aloxaf/silicon)
- [niuiic/core.nvim](https://github.com/niuiic/core.nvim)

## Usage

Just call `require("code-shot").shot()`, work in both `n` and `v` mode.

- Shot whole file

<img src="https://github.com/niuiic/assets/blob/main/code-shot.nvim/shot-whole.gif" />

- Shot selection

<img src="https://github.com/niuiic/assets/blob/main/code-shot.nvim/shot-range.gif" />

## Config

Default config here.

```lua
require("code-shot").setup({
	output = function()
		local core = require("core")
		local buf_name = vim.api.nvim_buf_get_name(0)
		return core.file.name(buf_name) .. ".png"
	end,
	options = function()
		return {}
	end,
})
```

Add any argument supported by silicon in `options`. For example, select a theme.

```lua
require("code-shot").setup({
	options = function()
		return {
			"--theme",
			"DarkNeon",
		}
	end,
})
```
