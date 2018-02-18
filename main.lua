local class = require("libs/middleclass/middleclass")
local stateful = require("libs/stateful/stateful")

local Game = require("Game")
require("InGame")

local lg = love.graphics

function love.load()
  Game = Game:new()

  lg.setBackgroundColor(86, 113, 112, 255)
end

function love.draw()
  lg.setColor(255, 255, 255)
  Game:draw()
end

function love.update(dt)
  Game:update(dt)
end

function love.keypressed(key, unicode)
  if key == "escape" then
    love.event.quit()
  end

  Game:keypressed(key, unicode)
end

function love.keyreleased(key)
  Game:keyreleased(key)
end