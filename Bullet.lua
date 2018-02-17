-- Libraries
local class = require("libs/middleclass/middleclass")

local lg = love.graphics

local Bullet = class("Bullet")

function Bullet:initialize(target, x, y, level, size)
	self.target = target
	self.x = x
	self.y = y
	self.level = level
	self.size = size or 4
	self.speed = 200
	self.damage = 5
end

function Bullet:draw(x, y)
	if self.destroyed then return end

	lg.setColor(255, 255, 100)
	lg.circle("fill", self.x, self.y, self.size)
	lg.setColor(255, 255, 255)
end

function Bullet:update(dt)
	if self.destroyed then return end

	if not self.target then
		self.destroyed = true
		return
	end

	local x = ((self.target.position.x - 1) * self.level.tilesize) + self.level.tilesize / 2
	local y = ((self.target.position.y - 1) * self.level.tilesize) + self.level.tilesize / 2

	local tx = x - self.x
	local ty = y - self.y
	local distance = math.sqrt(tx*tx+ty*ty)

	local velocityX = (tx/distance)
	local velocityY = (ty/distance)

	self.x = self.x + ((velocityX * self.speed) * dt)
	self.y = self.y + ((velocityY * self.speed) * dt)

	if distance < 8 then
		self.target = nil
		self.destroyed = true
		self.target:damage(self.damage)
	end
end

return Bullet