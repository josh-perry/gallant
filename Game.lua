-- Libraries
local class = require("libs/middleclass/middleclass")

-- Shorthands
local lg = love.graphics

local Level = require("Level")
local Princess = require("Princess")
local Knight = require("Knight")
local Bullet = require("Bullet")

local Game = class("Game")

function Game:initialize()
  self.level = Level:new()

  self.princess = Princess:new(5*self.level.tilesize, 5*self.level.tilesize)
  self.knight = Knight:new({x = 3, y = 4}, self.level)

  local bullet = Bullet:new(self.knight, 8, 8, self.level)
  table.insert(self.level.bullets, bullet)
end

function Game:update(dt)
  self.level:update(dt)
  self.knight:update(dt)
end

function Game:draw()
  self.level:draw()

  self.princess:draw()
  self.knight:draw()
end

function Game:keypressed(key, unicode)
end

function Game:keyreleased(key)
end

return Game