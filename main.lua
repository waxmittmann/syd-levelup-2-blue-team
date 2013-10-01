require 'input'
require 'player'
require 'scary_animal'
require 'obstacle'
require 'world'
require 'distance'
require 'person'

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

local spawningPerson = false


function spawnScaryAnimal()
    local scaryAnimal = ScaryAnimal:new(love)
    table.insert(entities, scaryAnimal)
    --entities[scaryAnimal] = true
    print("Added scary animal")
end

function spawnPerson()
    local person = Person:new(love)
    local i = 0
    for i=0, math.random(0, 2) do
      local person = Person:new(love)
      person.x = person.x - (person.size.x * i)
      table.insert(entities, person)
    end
    spawningPerson = false
   -- table.insert(entities, person)
 --   print("Added scary animal")
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
--    cron.after(math.random(2, 4), spawnPerson)
end

function love.update(dt)

    cron.update(dt)
--    cron.update(0.01)

    -- loop over scary animals
        -- if off screen
            -- remove
            -- and respawn
           
   -- print("Test")
    
    --remove dead scaryAnimal and respawn after 2-4 seconds
    local i = 1
    local hadPerson = false
    while i <= #entities do
        local removedItem = false
        if entities[i].type ~= nil and entities[i].type == "scary_animal" 
          and not world:onScreen(entities[i]) then
            table.remove(entities, i)
            cron.after(math.random(2, 4), spawnScaryAnimal)
            removedItem = true
       elseif entities[i].type ~= nil and entities[i].type == "person" then
          if not world:onScreen(entities[i]) then
            table.remove(entities, i)
           -- cron.after(math.random(2, 4), spawnPerson)
            removedItem = true
          else
--            print("Had person")
            hadPerson = true
          end
        end
        if removedItem == false then
          i = i + 1
        end
    end    
  
    if hadPerson ~= true and spawningPerson ~= true then
      spawningPerson = true
      cron.after(math.random(2, 4), spawnPerson)
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
