require 'entity'
require 'conf'

FlyingAnimal = {}
FlyingAnimal.__index = FlyingAnimal
setmetatable(FlyingAnimal, {__index = Entity})

function FlyingAnimal:new(game)

    local newFlyingAnimal = Entity:new(game)
    newFlyingAnimal.type = "scary_animal"
    newFlyingAnimal.size = {
        x = 65,
        y = 51
    }
    newFlyingAnimal.csize = {
        x = 5,
        y = 5
    }

    newFlyingAnimal.x = ScreenWidth
    newFlyingAnimal.maxHeightPercent = 0.25
    math.random(ScreenHeight * newFlyingAnimal.maxHeightPercent, ScreenHeight - newFlyingAnimal.size.y)
    newFlyingAnimal.y = ScreenHeight - newFlyingAnimal.size.y
    newFlyingAnimal.flyingUp = true
    newFlyingAnimal.alreadyHit = false
    newFlyingAnimal.speed = 3

    newFlyingAnimal.graphics = {
        source = "assets/images/scary-bird-sprites.png"
    }

    if game.graphics ~= nil and game.animation ~= nil then
        newFlyingAnimal.graphics.sprites = game.graphics.newImage(newFlyingAnimal.graphics.source)
        newFlyingAnimal.graphics.grid = game.animation.newGrid(
            newFlyingAnimal.size.x, newFlyingAnimal.size.y,
            newFlyingAnimal.graphics.sprites:getWidth(),
            newFlyingAnimal.graphics.sprites:getHeight()
        )
        newFlyingAnimal.graphics.animation = game.animation.newAnimation(
            newFlyingAnimal.graphics.grid("1-1", 1),
            0.05
        )
    end

    return setmetatable(newFlyingAnimal, self)
end

function FlyingAnimal:update(dt)

  if self.flyingUp == true then 
    if self.y >= (ScreenHeight) then
      self.flyingUp = false
    else
      self.y = self.y + 3
    end
  end

  if self.flyingUp == false then 
    if self.y <= 0 + ScreenHeight * self.maxHeightPercent then
      self.flyingUp = true
    else
      self.y = self.y - 3
    end
  end

    self.x = self.x - self.speed
    

    if self.graphics.animation ~= nil then
        self.graphics.animation:update(dt)
    end

end
