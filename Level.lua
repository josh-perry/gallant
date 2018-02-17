-- Libraries
local class = require("libs/middleclass/middleclass")

local lg = love.graphics

local Level = class("Level")
local Tile = require("Tile")
local Gun = require("Gun")
local Enemy = require("Enemy")
local Bullet = require("Bullet")

function Level:initialize()
	self.tiles = {}
	self.tilesize = 48
	self.tilesX = 10
	self.tilesY = 10

	self.dosh = 100

	for x = 1, self.tilesX do
		self.tiles[x] = {}

		for y = 1, self.tilesY do
			self.tiles[x][y] = Tile:new(false, "graphics/tiles/floor.png")

			if x == 1 or y == 1 or x == self.tilesX or y == self.tilesY then
				self.tiles[x][y] = Tile:new(true, "graphics/tiles/wall.png")
			end
		end
	end

	self.guns = {}

	self.enemies = {
		Enemy:new({x = 6, y = 4}, self),
		Enemy:new({x = 7, y = 4}, self),
		Enemy:new({x = 8, y = 4}, self),
		Enemy:new({x = 9, y = 4}, self),
		Enemy:new({x = 2, y = 2}, self),
		Enemy:new({x = 2, y = 3}, self),
		Enemy:new({x = 2, y = 4}, self),
		Enemy:new({x = 2, y = 5}, self),
		Enemy:new({x = 2, y = 6}, self),
		Enemy:new({x = 9, y = 9}, self),
		Enemy:new({x = 8, y = 9}, self),
		Enemy:new({x = 7, y = 9}, self)
	}

	self.bullets = {}
end

function Level:update(dt)
	for i, bullet in ipairs(self.bullets) do
		bullet:update(dt)

		if bullet.destroyed then
			table.remove(self.bullets, i)
		end
	end

	for _, gun in ipairs(self.guns) do
		gun:update(dt)
	end

	for i, enemy in ipairs(self.enemies) do
		enemy:update(dt)

		if enemy.destroyed then
			self.dosh = self.dosh + enemy.dosh
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

	for _, bullet in ipairs(self.bullets) do
		bullet:draw()
	end

	for _, gun in ipairs(self.guns) do
		gun:draw()
	end

	for _, enemy in ipairs(self.enemies) do
		enemy:draw()
	end
end

return Level