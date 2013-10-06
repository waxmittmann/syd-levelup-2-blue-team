require 'input'
require 'player'
require 'world'
require 'conf'

Distance = {}
Distance.__index = Distance
setmetatable(Distance, {__index = Entity})

function Distance:new(game)	
	local newDistance = Entity:new(game)
	newDistance.type = "Distance"
	newDistance.counter = 0
  game.graphics.setFont(game.graphics.newFont('assets/fonts/LilyScriptOne-Regular.ttf', DistanceFontSize))
	newDistance.size = {
        x = 0,
        y = 0
    }

	return setmetatable(newDistance, self)
end

function Distance:update(dt)
	self.counter = self.counter + dt
end

function Distance:draw()
  self.game.graphics.setColor(0, 0, 0, 255);
  distance = self.type .. " travelled: " .. tostring(math.floor(self.counter).."m")
  --distance = self.type .. " travelled: " .. tostring(math.floor(self.counter).."m")
	self.game.graphics.print(distance, DistanceMeterXOffset, DistanceMeterYOffset)
  self.game.graphics.setColor(255, 255, 255, 255);
end

function Distance:getDistance()
  if self.counter == nil then
    return 0
  end
  return math.floor(self.counter)
end