-- Libraries
local class = require("libs/middleclass/middleclass")

-- Shorthands
local lg = love.graphics

local Level = require("Level")
local Princess = require("Princess")
local Knight = require("Knight")
local Bullet = require("Bullet")

local Game = require("Game")
local InGame = Game:addState("InGame")

function InGame:initialize()
  self:initLevel()
end

function InGame:initLevel()
  self.level = Level:new()

  self.knight = Knight:new({x = 3, y = 4}, self.level)
end

function InGame:initUi()
  self.ui = lg.newImage("graphics/ui/ui.png")

  self.uiFont = lg.newFont("fonts/vinque.ttf", 24)
end

function InGame:update(dt)
  self.level:update(dt)
  self.knight:update(dt)

  if self.level.princess.destroyed then
    -- I'M SORRY
    love.event.quit("restart")
  end
end

function InGame:draw()
  self.level:draw()

  self.knight:draw()

  self:drawUi()

  if self.level.tip then
    lg.setFont(self.uiFont)
    lg.setColor(255, 255, 255)

    lg.printf(self.level.tip.text, self.level.tip.x, self.level.tip.y, lg:getWidth() - self.level.tip.x, "center")
  end
end

function InGame:drawUi()
  lg.setFont(self.uiFont)

  local uiX = (lg:getWidth()/2) - (self.ui:getWidth()/2)
  local uiY = lg:getHeight()-self.ui:getHeight()

  lg.setColor(255, 255, 255)
  lg.draw(self.ui, uiX, uiY)

  lg.setColor(0, 0, 0)
  lg.print(self.level.dosh, uiX + 220, uiY + 40)
  lg.print(self:getEnemyCount(), uiX + 85, uiY + 40)
end

function InGame:getEnemyCount()
  local enemies = table.getn(self.level.enemies)

  for _, enemySpawn in pairs(self.level.enemySpawns) do
    enemies = enemies + table.getn(enemySpawn.enemies)
  end

  return enemies
end

function InGame:buildGun()
  if self.knight:lookingAtWall() then
    self.knight:buildGun()
  end
end

function InGame:keypressed(key, unicode)
end

function InGame:keyreleased(key)
  if key == "space" then
    self:buildGun()
  end
end

return InGame