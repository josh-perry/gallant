-- Libraries
local class = require("libs/middleclass/middleclass")

local lg = love.graphics

local Gun = class("Gun")

function Gun:initialize(position, level)
	self.position = position
	self.level = level

	self.sprite = lg.newImage("graphics/sprites/redgun.png")

	self.target = nil
	self.rotation = 0
end

function Gun:draw()
	local ts = self.level.tilesize
	local x = (self.position.x - 1) * ts
	local y = (self.position.y - 1) * ts

	lg.draw(self.sprite, x+(ts/2), y+(ts/2), self.rotation, 1, 1, ts/2, ts/2)
end

function Gun:update(dt)
	if not self.target then
		return
	end

	local x = (self.position.x - 1) * self.level.tilesize
	local y = (self.position.y - 1) * self.level.tilesize

	local targetX = (self.target.position.x - 1) * self.level.tilesize
	local targetY = (self.target.position.y - 1) * self.level.tilesize

	self.rotation = math.atan2(targetY - y, targetX - x)
end

return Gun