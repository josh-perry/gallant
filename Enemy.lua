-- Libraries
local class = require("libs/middleclass/middleclass")

local lg = love.graphics

local Enemy = class("Enemy")

function Enemy:initialize(position, level)
	self.position = position
	self.level = level
	self.health = 25
	self.dosh = 20

	self.sprite = lg.newImage("graphics/sprites/enemy.png")
end

function Enemy:draw(x, y)
	local x = (self.position.x - 1) * self.level.tilesize
	local y = (self.position.y - 1) * self.level.tilesize

	lg.setColor(255, 255, 255)
	lg.draw(self.sprite, x, y)
end

function Enemy:damage(damage)
	self.health = self.health - damage

	if self.health <= 0 then
		self.destroyed = true
	end
end

function Enemy:update(dt)
end

return Enemy