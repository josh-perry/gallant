-- Libraries
local class = require("libs/middleclass/middleclass")

local lg = love.graphics

local Princess = class("Princess")

function Princess:initialize(position, level)
	self.position = position
	self.sprite = lg.newImage("graphics/sprites/princess.png")
	self.level = level
end

function Princess:draw()
	local x = (self.position.x - 1) * self.level.tilesize
	local y = (self.position.y - 1) * self.level.tilesize

	local yOffset = -62

	lg.setColor(255, 255, 255)
	lg.draw(self.sprite, x, y + yOffset)
end

return Princess