local file = require("code-shot.core.file")
local job = require("code-shot.core.job")
local text = require("code-shot.core.text")
local win = require("code-shot.core.win")
local lua = require("code-shot.core.lua")
local tree = require("code-shot.core.tree")
local timer = require("code-shot.core.timer")

return {
	file = file,
	job = job,
	text = text,
	win = win,
	lua = lua,
	tree = tree,
	timer = timer,
}
