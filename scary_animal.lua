require 'entity'
require 'conf'

ScaryAnimal = {}
ScaryAnimal.__index = ScaryAnimal
setmetatable(ScaryAnimal, {__index = Entity})

function ScaryAnimal:createRandomScaryAnimal(game)
    local toGen = math.random(1,3)
    local scaryAnimal = nil
    if toGen == 1 then
      scaryAnimal = ScaryAnimal:createHawk(love)
    elseif toGen == 2 then
      scaryAnimal = ScaryAnimal:createPorcupine(love)      
    else
      scaryAnimal = ScaryAnimal:createFox(love)
    end
    return scaryAnimal
end

function ScaryAnimal:createPorcupine(game)
  
    local stillCounter = 50
    local moveCounter = 50
  
    local function porcupineMoveStrategy(animal)
        animal.x = animal.x - CameraXSpeed          
      if animal.standingStill then 
        if animal.standingStillCounter == 0 then
          animal.standingStill = false
          animal.standingStillCounter = moveCounter
        end
      else
        animal.x = animal.x - animal.speed          
        if animal.standingStillCounter == 0 then
          animal.standingStill = true
          animal.standingStillCounter = stillCounter
        end
      end
      animal.standingStillCounter = animal.standingStillCounter - 1
    end

    local porcupineSize = {
      x = 75,
      y = 66
    }
    local porcupineCSize = {
      x = 6,
      y = 5
    }
    local porcupineImage = "assets/images/porcupineS.png"
    local porcupineFrames = 1
  
    local animal = ScaryAnimal:new(love, porcupineMoveStrategy, porcupineSize, porcupineCSize, porcupineImage, porcupineFrames)
    animal.standingStill = false
    animal.standingStillCounter = moveCounter
    return animal
end

function ScaryAnimal:createFox(game)
  
    local function foxMoveStrategy(animal)
      animal.x = animal.x - animal.speed  
    end

    local foxSize = {
      x = 64,
      y = 60
    }
    local foxCSize = {
      x = 6,
      y = 5
    }
    local foxImage = "assets/images/scary-animal-sprites-wolf.png"
    local foxFrames = 3
  
    return ScaryAnimal:new(love, foxMoveStrategy, foxSize, foxCSize, foxImage, foxFrames)
end

function ScaryAnimal:createHawk(game)
    local size = {
        x = 65,
        y = 51
    }
    local csize = {
        x = 5,
        y = 5
    }
    
    local function hawkMoveStrategy(animal)
      if animal.flyingUp == true then 
        if animal.y >= (ScreenHeight) then
          animal.flyingUp = false
        else
          animal.y = animal.y + 3
        end
      end

      if animal.flyingUp == false then 
        if animal.y <= 0 + ScreenHeight * animal.maxHeightPercent then
          animal.flyingUp = true
        else
          animal.y = animal.y - 3
        end
      end

      animal.x = animal.x - animal.speed
    end

    local hawkImage = "assets/images/scary-bird-sprites.png"
    local hawkFrames = 1
    
    local newScaryAnimal = ScaryAnimal:new(love, hawkMoveStrategy, size, csize, hawkImage, hawkFrames)
    newScaryAnimal.maxHeightPercent = 0.25
    newScaryAnimal.flyingUp = false
    newScaryAnimal.y = math.random(ScreenHeight * newScaryAnimal.maxHeightPercent, ScreenHeight - newScaryAnimal.size.y)
    return newScaryAnimal
end

function ScaryAnimal:new(game, moveStrategy, size, csize, img, frames)

    local newScaryAnimal = Entity:new(game)
    newScaryAnimal.type = "scary_animal"
    newScaryAnimal.size = size
    newScaryAnimal.csize = csize
    newScaryAnimal.moveStrategy = moveStrategy
    newScaryAnimal.x = ScreenWidth
    newScaryAnimal.y = ScreenHeight - newScaryAnimal.size.y - GroundYOffset

    newScaryAnimal.speed = 3
    newScaryAnimal.alreadyHit = false

    newScaryAnimal.graphics = {
        source = img --"assets/images/scary-animal-sprites-wolf.png"
    }

    if game.graphics ~= nil and game.animation ~= nil then
        newScaryAnimal.graphics.sprites = game.graphics.newImage(newScaryAnimal.graphics.source)
        newScaryAnimal.graphics.grid = game.animation.newGrid(
            newScaryAnimal.size.x, newScaryAnimal.size.y,
            newScaryAnimal.graphics.sprites:getWidth(),
            newScaryAnimal.graphics.sprites:getHeight()
        )
        newScaryAnimal.graphics.animation = game.animation.newAnimation(
            newScaryAnimal.graphics.grid("1-" .. frames, 1),
            0.05
        )
    end

    return setmetatable(newScaryAnimal, self)
end

function ScaryAnimal:update(dt)

  self.moveStrategy(self)

  if self.graphics.animation ~= nil then
      self.graphics.animation:update(dt)
  end

end
