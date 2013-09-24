require 'input'
require 'player'
require 'scary_animal'
require 'obstacle'
require 'world'
require 'distance'

love.animation = require 'vendor/anim8'

local entities = {}
local world = World:new(love)
local image = love.graphics.newImage("assets/images/background.png")
local quad = love.graphics.newQuad(0,0, 900, 500, image:getWidth(), image:getHeight())

local max_view = -450
local view_width = 0
local  view_height = 0

local player = Player:new(love)
local scaryAnimal = ScaryAnimal:new(love)
local distance = Distance:new(love)

function love.load()
    table.insert(entities, player)
    table.insert(entities, scaryAnimal)
    table.insert(entities, world)
    table.insert(entities, distance)

    love.input.bind('up', 'up')
    love.input.bind('left', 'left')
    love.input.bind('right', 'right')
    love.input.bind('down', 'down')
end

function love.update(dt)
    if view_width > max_view then
            love.graphics.drawq(image, quad, view_width, view_height)
            view_width = view_width - 30
            if view_width == -450 then
                 view_width = 0
             end
    end

    for _, entity in pairs(entities) do
        entity:update(dt)

        for _, other in pairs(entities) do
            if other ~= entity then
                if entity:collidingWith(other) then
                    entity:collide(other)
                end
            end
        end
    end
end


function love.draw()
    love.graphics.drawq(image, quad, view_width, view_height)
    for _, e in pairs(entities) do
        e:draw()
    end
end
