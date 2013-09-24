require 'input'
require 'entity'

Player = {}
Player.__index = Player
setmetatable(Player, {__index = Entity})

function Player:new(game, config)
    local config = config or {}

    local newPlayer = Entity:new(game)
    newPlayer.type = "player"
    newPlayer.x = config.x or 325
    newPlayer.y = config.y or 300
    newPlayer.dy = config.dy or 0
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

function Player:update(dt)

    if self.game.input.pressed(self.keys.up) then
        self.dy = -300
    end

    self.lastPosition = {
        x = self.x,
        y = self.y
    }

    local gravity = 400

    self.dy = self.dy + gravity * dt
    self.y = self.y + self.dy * dt 

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
