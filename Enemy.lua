-- Libraries
local class = require("libs/middleclass/middleclass")

local lg = love.graphics

local MovableEntity = require("MovableEntity")
local Enemy = class("Enemy", MovableEntity)

function Enemy:initialize(position, level)
	self.health = 25
	self.dosh = 20

	self.sprite = lg.newImage("graphics/sprites/enemy.png")

	MovableEntity.initialize(self, position, level)
end

function Enemy:draw(x, y)
	if self.destroyed then return end

	local x = (self.position.x - 1) * self.level.tilesize
	local y = (self.position.y - 1) * self.level.tilesize

	lg.setColor(255, 255, 255)
	lg.draw(self.sprite, x, y)
end

function Enemy:damage(damage)
	if self.destroyed then return end

	self.health = self.health - damage

	if self.health <= 0 then
		self.destroyed = true

		local x = math.floor(self.position.x + 0.5)
		local y = math.floor(self.position.y + 0.5)
		local currentTile = self.level.tiles[x][y]
		currentTile.floorDosh = currentTile.floorDosh + self.dosh
	end
end

function Enemy:update(dt)
	self:updateMovement(dt)
end

return Enemy