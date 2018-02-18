-- Libraries
local class = require("libs/middleclass/middleclass")
local stateful = require("libs/stateful/stateful")

local lg = love.graphics

local Game = class("Game")
Game:include(stateful)

function Game:draw()
	lg.print("uh press space to start!", 10, 10)
end

function Game:update(dt)
end

function Game:keypressed(key, unicode)
end

function Game:keyreleased(key)
	if key == "space" then
		self:gotoState("InGame")
		self:initLevel()
	end
end

return Game