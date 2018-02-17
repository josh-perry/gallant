-- Libraries
local class = require("libs/middleclass/middleclass")

-- Shorthands
local lg = love.graphics

local Game = class("Game")

function Game:initialize()
end

function Game:update(dt)
end

function Game:draw()
  lg.print("LÖVE JAM 2018", 10, 10)
end

function Game:keypressed(key, unicode)
end

function Game:keyreleased(key)
end

return Game