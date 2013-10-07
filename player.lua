require 'input'
require 'entity'
require 'conf'

Player = {}
Player.__index = Player
setmetatable(Player, {__index = Entity})

function Player:new(game, config)
    local config = config or {}

    local newPlayer = Entity:new(game)
    newPlayer.type = "player"
    newPlayer.colliding = false
    newPlayer.jumpCounter = 0
    newPlayer.ticksElapsedSinceLastJump = 1000000
    newPlayer.size = config.size or {
        x = 52,
        y = 50
    }
    csize = {
        x = 5,
        y = 5
    }

    newPlayer.x = config.x or 200
    newPlayer.originX = newPlayer.x
    newPlayer.y = config.y or ScreenHeight - newPlayer.size.y - GroundYOffset
    newPlayer.dy = config.dy or 0
--    newPlayer.jump_height = config.jump_height or 300
--    newPlayer.gravity = config.gravity or 400
--    newPlayer.jump_height = config.jump_height or 600
    newPlayer.jump_height = config.jump_height or 350
    newPlayer.gravity = config.gravity or 600
    newPlayer.speed = config.speed or 5
    
    newPlayer.hitScaryAnimal = false

    newPlayer.keys = config.keys or {
        up = "up"
    }

    newPlayer.graphics = config.graphics or {
        source = "assets/images/PlayerAnimalSprites2.png",
        facing = "right"
    }

    newPlayer.sound = config.sound or {
        moving = {
            source = "assets/sounds/move.wav"
        }
    }

    newPlayer.lastPosition = {
        x = nil,
        y = nil
    }

    if game.audio ~= nil then
        newPlayer.sound.moving.sample = game.audio.newSource(newPlayer.sound.moving.source)
        newPlayer.sound.moving.sample:setLooping(true)
    end

    if game.graphics ~= nil and game.animation ~= nil then
        newPlayer.graphics.sprites = game.graphics.newImage(newPlayer.graphics.source)
        newPlayer.graphics.grid = game.animation.newGrid(
            newPlayer.size.x, newPlayer.size.y,
            newPlayer.graphics.sprites:getWidth(),
            newPlayer.graphics.sprites:getHeight()
        )
        newPlayer.graphics.animation = game.animation.newAnimation(
            newPlayer.graphics.grid("1-4", 1),
            0.05
        )
    end

    return setmetatable(newPlayer, self)
end

function Player:collide(other)
  if other.type == 'person' then
    self.colliding = true
  end
  if self.lastScaryAnimalHit ~= other and other.type == 'scary_animal' and other.alreadyHit == false then
    other.alreadyHit = true
    self.hitScaryAnimal = true
    self.flashCountDown = 120
--    self.lastScaryAnimalHit = other
  end
end

function Player:isHitScaryAnimal()
  return self.hitScaryAnimal
end

function Player:resetHitScaryAnimal()
  self.hitScaryAnimal = false
end

function Player:stopFallingThroughFloor()
    if self.y > ScreenHeight - self.size.y - GroundYOffset then
        self.y = ScreenHeight - self.size.y - GroundYOffset
    end
end

function Player:isOnFloor()
    return self.y == ScreenHeight - self.size.y - GroundYOffset
end

function Player:handleJump()
--    self.dy = -self.jump_height
    self.dy = -self.jump_height
end

function Player:update(dt)
  
  if self.flashCountDown ~= nil and self.flashCountDown ~= 0 then
    print(math.floor(self.flashCountDown / 5) % 2 )
    if math.floor(self.flashCountDown / 5) % 2 == 0 then
      self.drawMe = false
    else
      self.drawMe = true
    end
    self.flashCountDown = self.flashCountDown - 1
  else
    self.drawMe = true    
  end
  
  if self:isOnFloor() then
    self.jumpCounter = 0
    self.ticksElapsedSinceLastJump = 1000000
  end
 
--  print(self.jumpCounter .. ", " .. self.ticksElapsedSinceLastJump)
  if self.game.input.pressed(self.keys.up) and self.ticksElapsedSinceLastJump >= 20 and self.jumpCounter < 2 then
    self:handleJump();
    self.jumpCounter = self.jumpCounter + 1
    self.ticksElapsedSinceLastJump = 0
--    print("doing jump " .. self.jumpCounter)
  elseif self.ticksElapsedSinceLastJump < 20 then
--    print("Ticking jump")
    self.ticksElapsedSinceLastJump = self.ticksElapsedSinceLastJump + 1
  end
  
--[[  
    if self.game.input.pressed(self.keys.up) and self:isOnFloor() then
        self:handleJump();
    end
--]]

    self.lastPosition = {
        x = self.x,
        y = self.y
    }

    self.dy = self.dy + self.gravity * dt
    self.y = self.y + self.dy * dt

    if self.colliding == true then
      self.x = self.x - CameraXSpeed
      self.colliding = false
    elseif self.x < self.originX then
      self.x = self.x + 1
    end

    self:stopFallingThroughFloor()

    if self.graphics.animation ~= nil then
        self.graphics.animation:update(dt)
    end

--[[
    if self.sound.moving.sample ~= nil then
        if dy ~= 0 then
            self.sound.moving.sample:play()
        else
            self.sound.moving.sample:stop()
        end
    end
--]]
end
