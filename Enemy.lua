-- Libraries
local class = require("libs/middleclass/middleclass")

local lg = love.graphics

local MovableEntity = require("MovableEntity")
local Enemy = class("Enemy", MovableEntity)

-- Jumper
local Grid = require("libs/jumper/jumper.grid")
local Pathfinder = require("libs/jumper/jumper.pathfinder")

function Enemy:initialize(position, level)
	self.health = 25
	self.dosh = 20
	self.sprite = lg.newImage("graphics/sprites/enemy.png")

	MovableEntity.initialize(self, position, level)

	self.speed = 5

	self.hitSounds = {
		love.audio.newSource("sounds/splat.ogg", "static"),
		love.audio.newSource("sounds/splat.ogg", "static"),
		love.audio.newSource("sounds/splat.ogg", "static"),
		love.audio.newSource("sounds/splat.ogg", "static"),
		love.audio.newSource("sounds/splat.ogg", "static")
	}

	self.deathSounds = {
		love.audio.newSource("sounds/enemy death.ogg", "static")
	}
end

function Enemy:playSound(sources, volume)
    for _, source in ipairs(sources) do
        if source:isStopped() then
    		if volume then
    			source:setVolume(volume)
    		end

            source:play()
            return
        end
    end
end

function Enemy:getMoveIntention()
	if not self.level.princess then
		print("No princess found on level!")
		return
	end

	local pathFindingMap = self.level:getPathFindingMap()
	local grid = Grid(pathFindingMap)
	self.pathFinder = Pathfinder(grid, 'JPS', 0)
	self.pathFinder:setMode('ORTHOGONAL')

	self.path = nil
	self.pathStep = nil

	local startX = math.floor(self.position.x + 0.5)
	local startY = math.floor(self.position.y + 0.5)

	local endX = math.floor(self.level.princess.position.x + 0.5)
	local endY = math.floor(self.level.princess.position.y + 0.5)

	local path = self.pathFinder:getPath(startX, startY, endX, endY)

	if path then
		for node, count in path:nodes() do
			if node:getX() > self.position.x then
				return "right"
			end

			if node:getY() > self.position.y then
				return "down"
			end

			if node:getX() < self.position.x then
				return "left"
			end

			if node:getY() < self.position.y then
				return "up"
			end
		end
	end
end

function Enemy:draw(x, y)
	if self.destroyed then return end

	local x = (self.position.x - 1) * self.level.tilesize
	local y = (self.position.y - 1) * self.level.tilesize

	lg.setColor(255, 255, 255)
	lg.draw(self.sprite, x, y)
end

function Enemy:damage(damage)
	if self.destroyed then return end

	self.health = self.health - damage

	if self.health <= 0 then
		self.destroyed = true

		local x = math.floor(self.position.x + 0.5)
		local y = math.floor(self.position.y + 0.5)
		local currentTile = self.level.tiles[x][y]
		currentTile.floorDosh = currentTile.floorDosh + self.dosh

		self:playSound(self.deathSounds, 0.1)
	else
		self:playSound(self.hitSounds, 0.5)
	end
end

function Enemy:isPrincessHit()
	local princess = self.level.princess

	if self.position.x == princess.position.x and self.position.y == princess.position.y then
		return true
	end

	return false
end

function Enemy:update(dt)
	if self.destroyed then return end
	if self.level.princess.destroyed then return end

	self:updateMovement(dt)

	if self:isPrincessHit() then
		self.destroyed = true
		self.level.princess.destroyed = true
	end
end

return Enemy