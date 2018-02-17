-- Libraries
local class = require("libs/middleclass/middleclass")

-- Shorthands
local lg = love.graphics

local Game = class("Game")
local Level = require("Level")

function Game:initialize()
  self.level = Level:new()
end

function Game:update(dt)
  self.level:update(dt)
end

function Game:draw()
  self.level:draw()
  lg.print("LÖVE JAM 2018", 10, 10)
end

function Game:keypressed(key, unicode)
end

function Game:keyreleased(key)
end

return Game