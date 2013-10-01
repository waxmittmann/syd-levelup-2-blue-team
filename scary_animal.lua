require 'entity'

ScaryAnimal = {}
ScaryAnimal.__index = ScaryAnimal
setmetatable(ScaryAnimal, {__index = Entity})

function ScaryAnimal:new(game)

    local newScaryAnimal = Entity:new(game)
    newScaryAnimal.type = "scary_animal"
--[[    newScaryAnimal.size = {
        x = 98,
        y = 60
    }--]]
    newScaryAnimal.size = {
        x = 79,
        y = 55
    }
    newScaryAnimal.x = 700
    newScaryAnimal.y = ScreenHeight - newScaryAnimal.size.y

    newScaryAnimal.speed = 5

    newScaryAnimal.graphics = {
        source = "assets/images/ScaryAnimal.png"
    }

    if game.graphics ~= nil and game.animation ~= nil then
        newScaryAnimal.graphics.sprites = game.graphics.newImage(newScaryAnimal.graphics.source)
        newScaryAnimal.graphics.grid = game.animation.newGrid(
            newScaryAnimal.size.x, newScaryAnimal.size.y,
            newScaryAnimal.graphics.sprites:getWidth(),
            newScaryAnimal.graphics.sprites:getHeight()
        )
        newScaryAnimal.graphics.animation = game.animation.newAnimation(
            newScaryAnimal.graphics.grid("1-1", 1),
            0.05
        )
    end

    return setmetatable(newScaryAnimal, self)
end

function ScaryAnimal:update(dt)

    self.x = self.x - self.speed

    --silly little jumpy anim 
    if self.y > ScreenHeight - self.size.y + 8 then
      self.y = ScreenHeight - self.size.y
    else
      self.y = self.y + 1
    end

    if self.graphics.animation ~= nil then
        self.graphics.animation:update(dt)
    end

end
