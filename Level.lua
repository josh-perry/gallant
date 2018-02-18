-- Libraries
local class = require("libs/middleclass/middleclass")
local cron = require("libs/cron/cron")

local lg = love.graphics

local Level = class("Level")
local Tile = require("Tile")
local Gun = require("Gun")
local Enemy = require("Enemy")
local Bullet = require("Bullet")
local EnemySpawn = require("EnemySpawn")
local Princess = require("Princess")
local Knight = require("Knight")

function Level:initialize(path)
	self.tiles = {}
	self.tilesize = 48
	self.tilesX = 10
	self.tilesY = 10

	self.tip = nil

	self.roundStarted = nil
	self.roundStartTimer = cron.after(5, function() self.roundStarted = true end)

  	self.princess = Princess:new({x = 1, y = 1}, self)
  	self.knight = Knight:new({x = 1, y = 1}, self)

	self.pathFindingMap = nil

	self.dosh = 100

	for x = 1, self.tilesX do
		self.tiles[x] = {}
	end

	self.guns = {}
	self.enemies = {}
	self.bullets = {}
	self.enemySpawns = {}

	self:loadFromImage(path)
end

function Level:loadFromImage(path)
	local levelData = require(path)

	local image = love.image.newImageData(levelData.image)

	local floor = lg.newImage("graphics/tiles/floor.png")
	local wall = lg.newImage("graphics/tiles/wall.png")

	self.tilesX = image:getWidth()
	self.tilesY = image:getHeight()

	for x = 1, self.tilesX do
		self.tiles[x] = {}

		for y = 1, self.tilesY do
			self.tiles[x][y] = nil
		end
	end

	for x = 1, image:getWidth() do
		for y = 1, image:getHeight() do
			local r, g, b, a = image:getPixel(x - 1, y - 1)

			-- Black = wall
			if r == 0 and g == 0 and b == 0 then
				self.tiles[x][y] = Tile:new(true, wall)
			else
				self.tiles[x][y] = Tile:new(false, floor)
			end

			-- Yellow = princess
			if r == 255 and g == 255 and b == 0 then
				self.princess.position = {x = x, y = y}
			end

			if r == 255 and g == 0 and b == 0 then
				local spawnEnemies = levelData.enemySpawns["red"].enemies
				local spawnDelay = levelData.enemySpawns["red"].spawnDelay
				self.enemySpawns["red"] = EnemySpawn:new({x = x, y = y}, self, spawnEnemies, spawnDelay)
			end

			if r == 0 and g == 255 and b == 0 then
				local spawnEnemies = levelData.enemySpawns["green"].enemies
				local spawnDelay = levelData.enemySpawns["green"].spawnDelay
				self.enemySpawns["green"] = EnemySpawn:new({x = x, y = y}, self, spawnEnemies, spawnDelay)
			end

			if r == 0 and g == 0 and b == 255 then
				local spawnEnemies = levelData.enemySpawns["blue"].enemies
				local spawnDelay = levelData.enemySpawns["blue"].spawnDelay
				self.enemySpawns["blue"] = EnemySpawn:new({x = x, y = y}, self, spawnEnemies, spawnDelay)
			end

			if r == 255 and g == 0 and b == 255 then
				self.knight.position.x = x
				self.knight.position.y = y
			end
		end
	end

	if levelData.tip then
		self.tip = levelData.tip
	end
end

function Level:update(dt)
	if not self.roundStarted then
		self.roundStartTimer:update(dt)
		return
	end

	for i, bullet in ipairs(self.bullets) do
		bullet:update(dt)

		if bullet.destroyed then
			table.remove(self.bullets, i)
		end
	end

	for _, gun in ipairs(self.guns) do
		gun:update(dt)
	end

	for _, enemySpawn in pairs(self.enemySpawns) do
		enemySpawn:update(dt)
	end

	for i, enemy in ipairs(self.enemies) do
		enemy:update(dt)

		if enemy.destroyed then
			table.remove(self.enemies, i)
		end
	end
end

function Level:draw()
	local ts = self.tilesize

	lg.setColor(255, 255, 255)

	for x = 1, self.tilesX do
		for y = 1, self.tilesY do
			if self.tiles[x][y] then
				lg.setColor(255, 255, 255)
				self.tiles[x][y]:draw((x - 1)*ts, (y - 1)*ts)
			end
		end
	end

	lg.setColor(255, 255, 255)

	for _, enemySpawn in pairs(self.enemySpawns) do
		enemySpawn:draw()
	end

	for _, bullet in ipairs(self.bullets) do
		bullet:draw()
	end

	for _, gun in ipairs(self.guns) do
		gun:draw()
	end

	for _, enemy in ipairs(self.enemies) do
		enemy:draw()
	end

	self.princess:draw()


end

function Level:getPathFindingMap()
	if self.pathFindingMap ~= nil then
		return self.pathFindingMap
	end

	local map = {}

	for y = 1, self.tilesY do
		map[y] = {}

		for x = 1, self.tilesX do
			if self.tiles[x][y].solid then
				map[y][x] = 1
			else
				map[y][x] = 0
			end
		end
	end

	self.pathFindingMap = map
	return self.pathFindingMap
end

return Level