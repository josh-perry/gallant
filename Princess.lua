-- Libraries
local class = require("libs/middleclass/middleclass")

local lg = love.graphics

local Princess = class("Princess")

function Princess:initialize(x, y)
	self.x = x
	self.y = y
	self.sprite = lg.newImage("graphics/sprites/princess.png")
end

function Princess:draw()
	lg.draw(self.sprite, self.x, self.y)
end

return Princess