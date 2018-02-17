-- Libraries
local class = require("libs/middleclass/middleclass")

local lg = love.graphics

local Knight = class("Knight")

function Knight:initialize(x, y)
	self.x = x
	self.y = y
	self.sprite = lg.newImage("graphics/sprites/knight.png")
end

function Knight:draw()
	lg.draw(self.sprite, self.x, self.y)
end

return Knight