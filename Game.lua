-- Libraries
local class = require("libs/middleclass/middleclass")
local stateful = require("libs/stateful/stateful")

local lg = love.graphics

local Game = class("Game")
Game:include(stateful)

function Game:initialize()
	self.background = lg.newImage("graphics/ui/menu.png")
	self.pressStart = lg.newImage("graphics/ui/start.png")
	self.runningTime = 0
	self.pressStartRotation = 0
end

function Game:draw()
	local width = self.pressStart:getWidth()
	local height = self.pressStart:getHeight()

	lg.draw(self.background, 0, 0)
	lg.draw(self.pressStart, 500 + (width/2), 500 + (height/2), self.pressStartRotation, 1, 1, width/2, height/2)
end

function Game:update(dt)
	self.runningTime = self.runningTime + dt

	self.pressStartRotation = math.sin(self.runningTime) / 4
end

function Game:keypressed(key, unicode)
end

function Game:keyreleased(key)
	if key == "space" then
		self:gotoState("InGame")
		self:initLevel("levels/1")
		self:initUi()
	end
end

return Game