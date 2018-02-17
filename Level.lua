-- Libraries
local class = require("libs/middleclass/middleclass")

local lg = love.graphics

local Level = class("Level")
local Tile = require("Tile")
local Princess = require("Princess")
local Knight = require("Knight")

function Level:initialize()
	self.tiles = {}
	self.tilesize = 48
	self.tilesX = 10
	self.tilesY = 10

	self.princess = Princess:new(5*self.tilesize, 5*self.tilesize)
	self.knight = Knight:new(3*self.tilesize, 4*self.tilesize)

	for x = 1, self.tilesX do
		self.tiles[x] = {}

		for y = 1, self.tilesY do
			self.tiles[x][y] = Tile:new(false, "graphics/floor.png")

			if x == 1 or y == 1 or x == self.tilesX or y == self.tilesY then
				self.tiles[x][y] = Tile:new(true, "graphics/wall.png")
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
				self.tiles[x][y]:draw(x*ts, y*ts)
			end
		end
	end

	lg.setColor(255, 255, 255)
	self.princess:draw()
	self.knight:draw()
end

return Level