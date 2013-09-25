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
local view_height = 0

local player = Player:new(love)
local distance = Distance:new(love)

local cron = require 'cron'


function spawnScaryAnimal()
    local scaryAnimal = ScaryAnimal:new(love)
    table.insert(entities, scaryAnimal)
    --entities[scaryAnimal] = true
    print("Added scary animal")
end

function love.load()

    table.insert(entities, world)
    table.insert(entities, distance)
    table.insert(entities, player)

    love.input.bind('up', 'up')
    love.input.bind('left', 'left')
    love.input.bind('right', 'right')
    love.input.bind('down', 'down')

    -- more info on cron here http://tannerrogalsky.com/blog/2012/09/19/favourite-lua-libraries/

    math.randomseed(os.time())

    cron.after(math.random(2, 4), spawnScaryAnimal)
  
end

function love.update(dt)

    cron.update(dt)

    -- loop over scary animals
        -- if off screen
            -- remove
            -- and respawn
           
   -- print("Test")
    
    --remove dead scaryAnimal and respawn after 2-4 seconds
    local i = 1
    while i <= #entities do
        if entities[i].type ~= nil and entities[i].type == "ScaryAnimal" and not world:onScreen(entities[i]) then
            table.remove(entities, i)
            cron.after(math.random(2, 4), spawnScaryAnimal)
        else
          i = i + 1
        end
    end    
  
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
