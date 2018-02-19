-- Libraries
local class = require("libs/middleclass/middleclass")
local cron = require("libs/cron/cron")

local Enemy = require("Enemy")

local lg = love.graphics

local EnemySpawn = class("EnemySpawn")

function EnemySpawn:initialize(position, level, enemyList, spawnDelay, colour)
	self.position = position
	self.level = level

	self.enemies = enemyList
	self.spawnDelay = spawnDelay

	self.sprite = lg.newImage("graphics/sprites/spawn"..colour..".png")

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

	local enemy = Enemy:new({x = self.position.x, y = self.position.y}, self.level)

	if self.enemies[1] == "red_blob" then
		enemy.health = 30
		enemy.dosh = 5
		enemy.speed = 3
		enemy.sprite = lg.newImage("graphics/sprites/enemy.png")
	elseif self.enemies[1] == "green_blob" then
		enemy.health = 100
		enemy.dosh = 5
		enemy.speed = 1
		enemy.sprite = lg.newImage("graphics/sprites/green.png")
	elseif self.enemies[1] == "blue_blob" then
		enemy.health = 15
		enemy.dosh = 5
		enemy.speed = 5
		enemy.sprite = lg.newImage("graphics/sprites/blue.png")
	end

	-- Spawn new enemy on level
	table.insert(self.level.enemies, enemy)

	-- Remove enemy from spawn list
	table.remove(self.enemies, 1)
end

return EnemySpawn