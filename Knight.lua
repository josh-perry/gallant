-- Libraries
local class = require("libs/middleclass/middleclass")

local Gun = require("Gun")

local lg = love.graphics
local lk = love.keyboard

local MovableEntity = require("MovableEntity")
local Knight = class("Knight", MovableEntity)

function Knight:initialize(position, level)
	self.sprite = lg.newImage("graphics/sprites/knight2.png")

	MovableEntity.initialize(self, position, level)
end

function Knight:update(dt)
	self:updateMovement(dt)
	self:collectFloorDosh()
end

function Knight:getMoveIntention()
	local moveIntention = nil

	if lk.isDown("a") then
		moveIntention = "left"
	elseif lk.isDown("d") then
		moveIntention = "right"
	elseif lk.isDown("s") then
		moveIntention = "down"
	elseif lk.isDown("w") then
		moveIntention = "up"
	end

	return moveIntention
end

function Knight:collectFloorDosh()
	local x = math.floor(self.position.x + 0.5)
	local y = math.floor(self.position.y + 0.5)

	local currentTile = self.level.tiles[x][y]

	self.level.dosh = self.level.dosh + currentTile.floorDosh
	currentTile.floorDosh = 0
end

function Knight:buildGun()
	local gunCost = 50

	if self.level.dosh < gunCost then
		return
	end

	local gun = nil

	if self.facing == "left" then
		gun = Gun:new({x = self.position.x - 1, y = self.position.y}, self.level)
	elseif self.facing == "right" then
		gun = Gun:new({x = self.position.x + 1, y = self.position.y}, self.level)
	elseif self.facing == "up" then
		gun = Gun:new({x = self.position.x, y = self.position.y - 1}, self.level)
	elseif self.facing == "down" then
		gun = Gun:new({x = self.position.x , y = self.position.y + 1}, self.level)
	else
		return
	end

	-- Check if a gun already exists at that position and abort if so
	for _, existingGun in ipairs(self.level.guns) do
		if existingGun.position.x == gun.position.x and existingGun.position.y == gun.position.y then
			if existingGun:upgrade() then
				self.level.dosh = self.level.dosh - gunCost
			end

			return
		end
	end

	table.insert(self.level.guns, gun)
	self.level.dosh = self.level.dosh - gunCost
end

function Knight:draw()
	local x = (self.position.x - 1) * self.level.tilesize
	local y = (self.position.y - 1) * self.level.tilesize

	local yOffset = -62 - 16

	lg.setColor(255, 255, 255)
	lg.draw(self.sprite, x, y + yOffset)
end

return Knight