World = {}
World.__index = World
setmetatable(World, {__index = Entity})


-- instantiate the world class
function  World:new(game)
	-- body
	local newWorld = Entity:new(game)
    newWorld.type = "world"

    newWorld.graphics =  {
        source = "assets/images/landscape.png",
      
    }

    newWorld.size = {
        x = 600,
        y = 400
    }

    return setmetatable(newWorld, self)
    
end

function World:update(dt)
    local dx = 0
    local dy = 0
end

function World:draw()
end