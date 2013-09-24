require 'input'
require 'player'
require 'obstacle'
require 'world'

Distance = {}
Distance.__index = Distance
setmetatable(Distance, {__index = Entity})

function Distance:new(game)	
	local newDistance = Entity:new(game)
	newDistance.type = "Distance"
	newDistance.counter = 0
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
	self.game.graphics.print(math.floor(self.counter), 300, 300)
end