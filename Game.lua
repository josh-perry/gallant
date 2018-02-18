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

	self.levels = self:getLevelData()
	self.levelImage = lg.newImage(self.levels[1].image)
	self.levelImage:setFilter("nearest", "nearest")

	self.leftArrow = lg.newImage("graphics/ui/leftarrow.png")
	self.rightArrow = lg.newImage("graphics/ui/rightarrow.png")

	self.showingLevel = 1
end

function Game:getLevelData()
	local files = {}

	for _, file in ipairs(love.filesystem.getDirectoryItems("levels")) do
		if string.sub(file, -4) == ".lua" then
			local levelData = require("levels/"..file:sub(1, -5))
			table.insert(files, levelData)
			print(file)
		end
	end

	return files
end

function Game:draw()
	if self.showingLevel < table.getn(self.levels) then
		lg.draw(self.rightArrow, 762, 207)
	end

	if self.showingLevel > 1 then
		lg.draw(self.leftArrow, 388, 207)
	end

	local width = self.pressStart:getWidth()
	local height = self.pressStart:getHeight()

	lg.draw(self.background, 0, 0)
	lg.draw(self.pressStart, 500 + (width/2), 500 + (height/2), self.pressStartRotation, 1, 1, width/2, height/2)

	lg.draw(self.levelImage, 564, 195, 0, 9, 9)
end

function Game:update(dt)
	self.runningTime = self.runningTime + dt

	self.pressStartRotation = math.sin(self.runningTime) / 4
end

function Game:previousLevel()
	if self.showingLevel <= 1 then
		return
	end

	self.showingLevel = self.showingLevel - 1
	self.levelImage = lg.newImage(self.levels[self.showingLevel].image)
	self.levelImage:setFilter("nearest", "nearest")
end

function Game:nextLevel()
	if self.showingLevel >= table.getn(self.levels) then
		return
	end

	self.showingLevel = self.showingLevel + 1
	self.levelImage = lg.newImage(self.levels[self.showingLevel].image)
	self.levelImage:setFilter("nearest", "nearest")
end

function Game:keypressed(key, unicode)
	if key == "a" then
		self:previousLevel()
	elseif key == "d" then
		self:nextLevel()
	end
end

function Game:keyreleased(key)
	if key == "space" then
		self:gotoState("InGame")
		self:initLevel(self.levels[self.showingLevel].data)
		self:initUi()
	end
end

return Game