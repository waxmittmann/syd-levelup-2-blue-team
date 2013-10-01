--require 'input'
require 'entity'
require 'conf'

World = {}
World.__index = World
setmetatable(World, {__index = Entity})


-- instantiate the world class
function  World:new(game)
	-- body
	local newWorld = Entity:new(game)

    newWorld.type = "world"
    newWorld.x = 0
    newWorld.y = 0
    newWorld.size = {
        x = ScreenWidth,
        y = ScreenHeight
    }


    newWorld.graphics =  {
         source = "assets/images/background.png",

    }

    return setmetatable(newWorld, self)
end

function World:update(dt)
    local dx = 0
    local dy = 0
end

function World:draw()
end

-- NOTE: seems weird but too lazy to handle both axis, not required right now
function World:onScreen(entity)
    local onScreen = true
    if entity.x > self.size.x then
        onScreen = false
    end
    if entity.x + entity.size.x < 0 then
        onScreen = false
    end
    return onScreen
end

