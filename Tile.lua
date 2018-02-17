-- Libraries
local class = require("libs/middleclass/middleclass")

local lg = love.graphics

local Tile = class("Tile")

function Tile:initialize(solid, spritepath)
	self.solid = solid
	self.sprite = lg.newImage(spritepath)
	self.doshSprite = lg.newImage("graphics/sprites/knightdosh.png")
	self.floorDosh = 0
end

function Tile:draw(x, y)
	lg.draw(self.sprite, x, y)

	if self.floorDosh > 0 then
		lg.draw(self.doshSprite, x, y)
	end
end

return Tile