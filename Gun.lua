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

function Gun:findTarget()
	local closest = nil
	local closestDistance = nil

	local x = (self.position.x - 1) * self.level.tilesize
	local y = (self.position.y - 1) * self.level.tilesize

	for _, enemy in ipairs(self.level.enemies) do
		local enemyX = (enemy.position.x - 1) * self.level.tilesize
		local enemyY = (enemy.position.y - 1) * self.level.tilesize
		local distance = math.sqrt((enemyX - x) ^ 2 + (enemyY - y) ^ 2)

		if closest == nil then
			closest = enemy
			closestDistance = distance
		else
			if distance < closestDistance then
				closest = enemy
				closestDistance = distance
			end
		end
	end

	return closest
end

function Gun:update(dt)
	self.target = self:findTarget()

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