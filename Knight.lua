-- Libraries
local class = require("libs/middleclass/middleclass")
local cron = require("libs/cron/cron")

local Gun = require("Gun")

local lg = love.graphics
local lk = love.keyboard

local MovableEntity = require("MovableEntity")
local Knight = class("Knight", MovableEntity)

function Knight:initialize(position, level)
	self.sprite = lg.newImage("graphics/sprites/knight.png")
	self.spriteLeft = lg.newImage("graphics/sprites/knight_left.png")
	self.knightShadow = lg.newImage("graphics/sprites/knight_shadow.png")

	self.facingWall = false
	self.facingTurret = nil

	MovableEntity.initialize(self, position, level)

	self.yOffset = 0
	self.yTargetOffset = 0
	self.ySpeed = 100
	self.yFinished = true
	self.yMaxOffset = 16
end

function Knight:update(dt)
	if self:isMoving() then
		if self.yFinished then
			if self.yTargetOffset == 0 then
				self.yTargetOffset = -self.yMaxOffset
			elseif self.yTargetOffset == -self.yMaxOffset then
				self.yTargetOffset = 0
			end

			self.yFinished = false
		end
	end

	if self.yOffset < self.yTargetOffset then
		self.yOffset = self.yOffset + (self.ySpeed * dt)

		if self.yOffset > self.yTargetOffset then
			self.yOffset = self.yTargetOffset
			self.yFinished = true
		end
	elseif self.yOffset > self.yTargetOffset then
		self.yOffset = self.yOffset - (self.ySpeed * dt)

		if self.yOffset > self.yTargetOffset then
			self.yOffset = self.yTargetOffset
			self.yFinished = true
		end
	end

	self.facingWall = self:lookingAtWall()
	self.facingTurret = self:getFacingTurret()

	self:updateMovement(dt)
	self:collectFloorDosh()
end

function Knight:getFacingTurret()
	local position = nil

	local x = math.floor(self.position.x + 0.5)
	local y = math.floor(self.position.y + 0.5)

	if self.facing == "left" then
		position = {x = x - 1, y = y}
	elseif self.facing == "right" then
		position = {x = x + 1, y = y}
	elseif self.facing == "up" then
		position = {x = x, y = y - 1}
	elseif self.facing == "down" then
		position = {x = x, y = y + 1}
	else
		return nil
	end

	-- Check if a gun already exists at that position and abort if so
	for _, existingGun in ipairs(self.level.guns) do
		if existingGun.position.x == position.x and existingGun.position.y == position.y then
			return existingGun
		end
	end

	return nil
end

function Knight:getMoveIntention()
	local moveIntention = nil

	if lk.isDown("a") or lk.isDown("left") then
		moveIntention = "left"
	elseif lk.isDown("d") or lk.isDown("right") then
		moveIntention = "right"
	elseif lk.isDown("s") or lk.isDown("down") then
		moveIntention = "down"
	elseif lk.isDown("w") or lk.isDown("up") then
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

function Knight:buildGun(gunCost)
	if self.level.dosh < gunCost then
		return
	end

	local gun = nil

	local x = math.floor(self.position.x + 0.5)
	local y = math.floor(self.position.y + 0.5)

	if self.facing == "left" then
		gun = Gun:new({x = x - 1, y = y}, self.level)
	elseif self.facing == "right" then
		gun = Gun:new({x = x + 1, y = y}, self.level)
	elseif self.facing == "up" then
		gun = Gun:new({x = x, y = y - 1}, self.level)
	elseif self.facing == "down" then
		gun = Gun:new({x = x , y = y + 1}, self.level)
	else
		return
	end

	table.insert(self.level.guns, gun)
	self.level.dosh = self.level.dosh - gunCost
end

function Knight:draw()
	local x = (self.position.x - 1) * self.level.tilesize
	local y = (self.position.y - 1) * self.level.tilesize

	local yOffset = -48 + self.yOffset

	lg.setColor(255, 255, 255, 200)
	lg.draw(self.knightShadow, x, y - 48)

	lg.setColor(255, 255, 255)

	if self.lrFacing == "left" then
		lg.draw(self.spriteLeft, x, y + yOffset)
	else
		lg.draw(self.sprite, x, y + yOffset)
	end
end

return Knight