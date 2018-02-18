-- Libraries
local class = require("libs/middleclass/middleclass")
local cron = require("libs/cron/cron")

local Bullet = require("Bullet")

local lg = love.graphics

local Gun = class("Gun")

function Gun:initialize(position, level)
	self.position = position
	self.level = level

	self.sprite = lg.newImage("graphics/sprites/redgun.png")

	self.target = nil
	self.rotation = 0

	self.readyToFire = false

	self.upgradeLevel = 1
	self.upgradeFireRate = 0.3

	self.baseRange = 200
	self.range = self.baseRange

	self.fireRate = 0.8
	self:refreshFireTimer()
end

function Gun:refreshFireTimer()
	self.fireTimer = cron.every(self.fireRate, function() self:fire() end)
end

function Gun:fire()
	if not self.target then
		return
	end

	local x = ((self.position.x - 1) * self.level.tilesize) + (self.level.tilesize / 2)
	local y = ((self.position.y - 1) * self.level.tilesize) + (self.level.tilesize / 2)

	local bullet = Bullet:new(self.target, x, y, self.level)
	bullet.size = bullet.size + (bullet.size * (0.5 * self.upgradeLevel))
	bullet.damage = bullet.damage + self.upgradeLevel
	table.insert(self.level.bullets, bullet)
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


		if closest == nil and distance <= self.range then
			closest = enemy
			closestDistance = distance
		else
			if distance <= self.range and distance < closestDistance then
				closest = enemy
				closestDistance = distance
			end
		end
	end

	return closest
end

function Gun:update(dt)
	self.fireTimer:update(dt)
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

function Gun:getRangeUpgrade()
	if self.upgradeLevel == 3 then
		return self.range
	end

	return self.baseRange + (30 * (self.upgradeLevel + 1))
end

function Gun:upgrade()
	if self.upgradeLevel == 3 then
		return false
	end

	-- Upgrade range
	self.range = self:getRangeUpgrade()

	-- Upgrade fire rate
	self.fireRate = self.fireRate - self.upgradeFireRate
	self:refreshFireTimer()

	self.upgradeLevel = self.upgradeLevel + 1

	if self.upgradeLevel == 1 then
		self.sprite = lg.newImage("graphics/sprites/redgun.png")
	elseif self.upgradeLevel == 2 then
		self.sprite = lg.newImage("graphics/sprites/greengun.png")
	elseif self.upgradeLevel == 3 then
		self.sprite = lg.newImage("graphics/sprites/bluegun.png")
	end

	return true
end

return Gun