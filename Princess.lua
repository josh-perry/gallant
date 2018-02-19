-- Libraries
local class = require("libs/middleclass/middleclass")

local lg = love.graphics

local Princess = class("Princess")

function Princess:initialize(position, level)
	self.position = position
	self.sprite = lg.newImage("graphics/sprites/princess.png")
	self.level = level
	self.destroyed = false
end

function Princess:draw()
	if self.destroyed then return end

	local x = (self.position.x - 1) * self.level.tilesize
	local y = (self.position.y - 1) * self.level.tilesize

	lg.setColor(255, 255, 255)
	lg.draw(self.sprite, x, y - 48)
end

return Princess