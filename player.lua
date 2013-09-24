require 'input'
require 'entity'

Player = {}
Player.__index = Player
setmetatable(Player, {__index = Entity})

function Player:new(game, config)
    local config = config or {}

    local newPlayer = Entity:new(game)
    newPlayer.type = "player"
    newPlayer.x = config.x or 100
    newPlayer.y = config.y or 400
    newPlayer.dy = config.dy or 0
    newPlayer.jump_height = config.jump_height or 300
    newPlayer.gravity = config.gravity or 400
    newPlayer.size = config.size or {
        x = 98,
        y = 60
    }

    newPlayer.keys = config.keys or {
        up = "up"
    }

    newPlayer.graphics = config.graphics or {
        source = "assets/images/nyancat-sprites.png",
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
            newPlayer.graphics.grid("1-6", 1),
            0.05
        )
    end

    return setmetatable(newPlayer, self)
end

function Player:collide(other)
    self.x = self.lastPosition.x
    self.y = self.lastPosition.y
end

function Player:stopFallingThroughFloor()
    if self.y > self.game.graphics:getHeight() - self.size.y then
        self.y = self.game.graphics:getHeight() - self.size.y
    end
end

function Player:isOnFloor()
    return self.y == self.game.graphics:getHeight() - self.size.y
end

function Player:handleJump()
    self.dy = -self.jump_height
end

function Player:update(dt)

    if self.game.input.pressed(self.keys.up) and self:isOnFloor() then
        self:handleJump();
    end

    self.lastPosition = {
        x = self.x,
        y = self.y
    }

    self.dy = self.dy + self.gravity * dt
    self.y = self.y + self.dy * dt

    self:stopFallingThroughFloor()

    if self.graphics.animation ~= nil then
        self.graphics.animation:update(dt)
    end

    if self.sound.moving.sample ~= nil then
        if dy ~= 0 then
            self.sound.moving.sample:play()
        else
            self.sound.moving.sample:stop()
        end
    end
end
