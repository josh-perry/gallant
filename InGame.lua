-- Libraries
local class = require("libs/middleclass/middleclass")
local cron = require("libs/cron/cron")

-- Shorthands
local lg = love.graphics

local Level = require("Level")
local Princess = require("Princess")
local Bullet = require("Bullet")

local Game = require("Game")
local InGame = Game:addState("InGame")

function InGame:initialize()
  self:initLevel()

  self.endRoundTimer = nil
end

function InGame:initLevel(path)
  self.level = Level:new(path)
end

function InGame:initUi()
  self.ui = lg.newImage("graphics/ui/ui.png")

  self.uiFont = lg.newFont("fonts/vinque.ttf", 24)
  self.smallUiFont = lg.newFont("fonts/vinque.ttf", 18)

  self.thoughtBubble = lg.newImage("graphics/ui/thought.png")
  self.baseGun = lg.newImage("graphics/sprites/redgun.png")
  self.knightDosh = lg.newImage("graphics/sprites/knightdosh.png")
  self.upgradeArrow = lg.newImage("graphics/ui/upgrade.png")
end

function InGame:update(dt)
  if self:getEnemyCount() == 0 then
    if self.endRoundTimer == nil then
      self.endRoundTimer = cron.after(5, function() love.event.quit("restart") end)
    else
      self.endRoundTimer:update(dt)
    end
  end

  self.level:update(dt)
  self.level.knight:update(dt)

  if self.level.princess.destroyed then
    -- I'M SORRY
    love.event.quit("restart")
  end
end

function InGame:showTurretRangeCircle()
  local turret = self.level.knight.facingTurret

  local lookingAtPosition = self.level.knight:getCenterOfLookingAt()
  lg.setColor(255, 255, 0, 100)
  lg.circle("fill", lookingAtPosition.x, lookingAtPosition.y, turret.range)

  lg.setColor(200, 200, 0, 150)
  lg.circle("line", lookingAtPosition.x, lookingAtPosition.y, turret:getRangeUpgrade())
end

function InGame:showBaseTurretRangeCircle()
  local lookingAtPosition = self.level.knight:getCenterOfLookingAt()

  lg.setColor(255, 255, 0, 100)
  lg.circle("line", lookingAtPosition.x, lookingAtPosition.y, 200)

  lg.draw(self.baseGun, lookingAtPosition.x - (self.baseGun:getWidth() / 2), lookingAtPosition.y - (self.baseGun:getHeight() / 2))
end

function InGame:showBuildThoughtBubble()
  local knightX = (self.level.knight.position.x - 1) * self.level.tilesize
  local knightY = (self.level.knight.position.y - 2) * self.level.tilesize

  local x = knightX - self.thoughtBubble:getWidth()
  local y = knightY - self.thoughtBubble:getHeight()

  lg.setColor(255, 255, 255, 200)
  lg.draw(self.thoughtBubble, x, y)

  lg.draw(self.baseGun, x + 10, y + 20)
  lg.draw(self.knightDosh, x + 60, y + 20)

  lg.setColor(0, 0, 0, 200)
  lg.setFont(self.smallUiFont)
  lg.print("x 50", x + 110, y + 30)

  lg.setColor(255, 255, 255)
end

function InGame:showUpgradeThoughtBubble()
  local turret = self.level.knight.facingTurret

  local upgradeBaseCost = 100

  local knightX = (self.level.knight.position.x - 1) * self.level.tilesize
  local knightY = (self.level.knight.position.y - 2) * self.level.tilesize

  local x = knightX - self.thoughtBubble:getWidth()
  local y = knightY - self.thoughtBubble:getHeight()

  lg.setColor(255, 255, 255, 200)
  lg.draw(self.thoughtBubble, x, y)

  lg.draw(self.baseGun, x + 10, y + 20)
  lg.draw(self.upgradeArrow, x + 10, y + 20)
  lg.draw(self.knightDosh, x + 60, y + 20)

  lg.setColor(0, 0, 0, 200)
  lg.setFont(self.smallUiFont)
  lg.print("x "..upgradeBaseCost*turret.upgradeLevel, x + 110, y + 30)

  lg.setColor(255, 255, 255)
end

function InGame:draw()
  self.level:draw()

  if self.level.knight.facingTurret then
    self:showTurretRangeCircle()
    self:showUpgradeThoughtBubble()
  elseif self.level.knight.facingWall then
    self:showBaseTurretRangeCircle()
    self:showBuildThoughtBubble()
  end

  lg.setColor(255, 255, 255)

  self:drawUi()

  if self.level.tip then
    lg.setFont(self.uiFont)
    lg.setColor(255, 255, 255)

    lg.printf(self.level.tip.text, self.level.tip.x, self.level.tip.y, lg:getWidth() - self.level.tip.x, "center")
  end

  if self:getEnemyCount() == 0 then
    lg.setColor(0, 0, 0, 200)
    lg.rectangle("fill", 0, 0, lg:getWidth(), lg:getHeight())

    lg.setColor(255, 255, 255)
    lg.setFont(self.uiFont)
    lg.printf("Level clear!", 0, lg:getHeight() / 2, lg:getWidth(), "center")
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
  local gunCost = 50
  local upgradeBaseCost = 100

  if self.level.knight.facingWall then
    local turret = self.level.knight.facingTurret

    if turret then
      local upgradeCost = upgradeBaseCost*turret.upgradeLevel

      if self.level.dosh >= upgradeCost and turret:upgrade() then
        self.level.dosh = self.level.dosh - upgradeCost
      end
    else
      self.level.knight:buildGun(gunCost)
    end
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