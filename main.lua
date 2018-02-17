local Game = require("Game")
local lg = love.graphics

function love.load()
  Game = Game:new()
  love.graphics.setBackgroundColor(86, 113, 112, 255)
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

function love.textinput(t)
  Game:textinput(t)
end

function love.keyreleased(key)
  Game:keyreleased(key)
end