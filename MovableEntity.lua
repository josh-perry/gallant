-- Libraries
local class = require("libs/middleclass/middleclass")

local lg = love.graphics

local MovableEntity = class("MovableEntity")

function MovableEntity:initialize(position, level)
	self.position = position
	self.size = { w = 0, h = 0 }
	self.velocity = { x = 0, y = 0 }
	self.moveIntention = nil
	self.lastMove = nil
	self.destination = nil
	self.movingDirection = nil
	self.level = level
	self.facing = "down"

	self.size = { w = level.tilesize, h = level.tilesize }
	self.speed = 5
end

function MovableEntity:getMoveIntention()
	return nil
end

function MovableEntity:updateMovement(dt)
	if not self.level then
		return
	end

	self.moveIntention = self:getMoveIntention()

	if self.moveIntention ~= nil then
		self.facing = self.moveIntention
	end

	local moving = self:isMoving()
	local reachedDestination = self:reachedDestination()

	if reachedDestination then
		self.movingDirection = nil
		self:stopMoving()
	end

	if not moving and self.moveIntention then
		self.movingDirection = self.moveIntention
		self:move(self.moveIntention)
	end

	self:updatePosition(dt)
end

function MovableEntity:updatePosition(dt)
	self.position.x = self.position.x + ((self.velocity.x * self.speed) * dt)
	self.position.y = self.position.y + ((self.velocity.y * self.speed) * dt)
end

function MovableEntity:reachedDestination()
	if not self.destination then
		return false
	end

	local px = self.position.x * self.level.tilesize
	local py = self.position.y * self.level.tilesize

	local dx = self.destination.x * self.level.tilesize
	local dy = self.destination.y * self.level.tilesize

	if self.movingDirection == "up" then
		if py <= dy then return true end
	end

	if self.movingDirection == "down" then
		if py >= dy then return true end
	end

	if self.movingDirection == "left" then
		if px <= dx then return true end
	end

	if self.movingDirection == "right" then
		if px >= dx then return true end
	end

	return false
end

function MovableEntity:move(direction)
	self.destination = { x = self.position.x, y = self.position.y }
	self.velocity = { x = 0, y = 0 }
	self.moving = true

	self.destination.x = math.floor(self.destination.x + 0.5)
	self.destination.y = math.floor(self.destination.y + 0.5)

	if direction == "up" then
		self.destination.y = self.position.y - 1
		self.velocity.y = -1
	elseif direction == "down" then
		self.destination.y = self.position.y + 1
		self.velocity.y = 1
	elseif direction == "left" then
		self.destination.x = self.position.x - 1
		self.velocity.x = -1
	elseif direction == "right" then
		self.destination.x = self.position.x + 1
		self.velocity.x = 1
	else
		self.moving = false
	end

	if self:checkDestinationSolid() then
		self.destination = nil
		self.velocity = { x = 0, y = 0 }
		self.moving = false
	end
end

function MovableEntity:checkDestinationSolid()
	return self.level.tiles[self.destination.x][self.destination.y].solid
end

function MovableEntity:isMoving()
	return self.destination ~= nil
end

function MovableEntity:draw()
	local x = (self.position.x - 1) * self.level.tilesize
	local y = (self.position.y - 1) * self.level.tilesize

	lg.setColor(255, 255, 255)
	lg.draw(self.sprite, x, y)
end

function MovableEntity:stopMoving()
	self:snapPosition(self.destination.x, self.destination.y)
	self.destination = nil
	self.velocity = {x = 0, y = 0}
end

function MovableEntity:snapPosition(x, y)
	self.position = {x = x, y = y}
end

function MovableEntity:lookingAtWall()
	local x = math.floor(self.position.x + 0.5)
	local y = math.floor(self.position.y + 0.5)

	if self.facing == "left" then
		return self.level.tiles[x - 1][y].solid
	elseif self.facing == "right" then
		return self.level.tiles[x + 1][y].solid
	elseif self.facing == "up" then
		return self.level.tiles[x][y - 1].solid
	elseif self.facing == "down" then
		return self.level.tiles[x][y + 1].solid
	end
end

return MovableEntity