-- Libraries
local class = require("libs/middleclass/middleclass")
local cron = require("libs/cron/cron")

local lg = love.graphics

local EnemySpawn = class("EnemySpawn")

function EnemySpawn:initialize(position, level, enemyList, spawnDelay)
	self.position = position
	self.level = level

	self.enemies = enemyList
	self.spawnDelay = spawnDelay

	self.sprite = lg.newImage("graphics/sprites/spawn.png")

	self.spawnTimer = cron.every(spawnDelay, function() self:spawnEnemy() end)
end

function EnemySpawn:draw()
	local ts = self.level.tilesize
	local x = (self.position.x - 1) * ts
	local y = (self.position.y - 1) * ts

	lg.draw(self.sprite, x, y)
end

function EnemySpawn:update(dt)
	if self.spawnTimer then
		self.spawnTimer:update(dt)
	end
end

function EnemySpawn:spawnEnemy()
	if table.getn(self.enemies) <= 0 then
		self.spawnTimer = nil
		return
	end

	local enemy = self.enemies[1]
	enemy.position.x = self.position.x
	enemy.position.y = self.position.y

	-- Spawn new enemy on level
	table.insert(self.level.enemies, enemy)

	-- Remove enemy from spawn list
	table.remove(self.enemies, 1)
end

return EnemySpawn