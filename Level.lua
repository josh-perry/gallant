-- Libraries
local class = require("libs/middleclass/middleclass")

local lg = love.graphics

local Level = class("Level")
local Tile = require("Tile")

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
end

function Level:update(dt)
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
end

return Level