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

	for x = 1, self.tilesX do
		self.tiles[x] = {}

		for y = 1, self.tilesY do
			self.tiles[x][y] = Tile:new(false, "graphics/tiles/floor.png")

			if x == 1 or y == 1 or x == self.tilesX or y == self.tilesY then
				self.tiles[x][y] = Tile:new(true, "graphics/tiles/wall.png")
			end
		end
	end

	self.guns = {
		Gun:new({x = 1, y = 1}, self),
		Gun:new({x = 10, y = 10}, self),
		Gun:new({x = 1, y = 10}, self),
		Gun:new({x = 10, y = 1}, self)
	}

	self.enemies = {
		Enemy:new({x = 6, y = 4}, self)
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

	for _, enemy in ipairs(self.enemies) do
		enemy:update(dt)
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