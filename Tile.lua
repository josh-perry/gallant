-- Libraries
local class = require("libs/middleclass/middleclass")

local lg = love.graphics

local Tile = class("Tile")

function Tile:initialize(solid, spritepath)
	self.solid = solid
	self.sprite = lg.newImage(spritepath)
end

function Tile:draw(x, y)
	lg.draw(self.sprite, x, y)
end

return Tile