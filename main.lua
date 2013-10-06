require 'input'
require 'player'
require 'scary_animal'
require 'world'
require 'distance'
require 'conf'
require 'person'
require 'panicmeter'

love.animation = require 'vendor/anim8'

local entities = {}
local world = World:new(love)
local image = love.graphics.newImage("assets/images/BackgroundImage2.png")
local quad = love.graphics.newQuad(0,0, ScreenWidth, ScreenHeight, image:getWidth(), image:getHeight())
local quad2 = love.graphics.newQuad(ScreenWidth, ScreenHeight, ScreenWidth, ScreenHeight, image:getWidth(), image:getHeight())

local view_width = 0
local view_height = 0

local player = Player:new(love)
local distance = Distance:new(love)
local panicmeter = Panicmeter:new(love)

-- more info on cron here http://tannerrogalsky.com/blog/2012/09/19/favourite-lua-libraries/
local cron = require 'cron'

local spawningCrowd = false

local isGameOver = false

local scaryAnimalsSpawning = 0

function initGame()
  entities = {}
  world = World:new(love)
  quad = love.graphics.newQuad(0,0, ScreenWidth, ScreenHeight, image:getWidth(), image:getHeight())

  player = Player:new(love)
  distance = Distance:new(love)
  panicmeter = Panicmeter:new(love)

  cron = require 'cron'

  spawningCrowd = false

  isGameOver = false  
      
  table.insert(entities, player)
  table.insert(entities, world)
  table.insert(entities, distance)
  table.insert(entities, panicmeter)
  
end

function spawnScaryAnimal()

    local scaryAnimal = ScaryAnimal:createRandomScaryAnimal(game)
    
    table.insert(entities, scaryAnimal)
    
    scaryAnimalsSpawning = scaryAnimalsSpawning - 1
end

function removeOutOfBoundsCrowds()
    local i = 1
    local hadPerson = false
    while i <= #entities do
       if entities[i].type ~= nil and entities[i].type == "person" then
          if not world:rightOfLeftBorder(entities[i]) then
            table.remove(entities, i)
          else
            hadPerson = true
            i = i + 1
          end
        else
          i = i + 1
        end
    end      
    return hadPerson
end

function isPlayerOutOfBounds()
  return not world:onScreen(player)
end

function isPanicmeterFull()
  return panicmeter:getPanic() >= 100
end

function spawnCrowd()
    local i = 0
    local lastPerson = nil
    for i=0, math.random(0, 2) do
      local person = Person:createRandomPerson(love)
      if lastPerson ~= nil then
        person.x = (lastPerson.size.x) + lastPerson.x        
      end
      lastPerson = person
      table.insert(entities, person)
    end
    spawningCrowd = false
end

function hitScaryAnimal()
  panicmeter:incPanic()
end

function love.load()

    love.input.bind('up', 'up')
    love.input.bind('left', 'left')
    love.input.bind('right', 'right')
    love.input.bind('down', 'down')
    love.input.bind('return', 'return')
    
    math.randomseed(os.time())

    initGame()
end

function love.update(dt)
    if isGameOver == true then
      if love.input.pressed("return") then
        initGame()
        isGameOver = false
      else
        return
      end
    elseif isPlayerOutOfBounds() then
      --this is where we can add code for ending the game if the player   
      isGameOver = true
      return
    elseif isPanicmeterFull() then
      isGameOver = true
      return      
    end
    
    cron.update(dt)

    if spawningCrowd or removeOutOfBoundsCrowds() == false then
      spawnCrowd()
    end

    local i = 1    
    local scaryAnimalCount = 0
    local removedScaryAnimal = false
    while i <= #entities do
        local removedItem = false
        if entities[i].type ~= nil and entities[i].type == 'scary_animal' then
            if not world:onScreen(entities[i]) then
                table.remove(entities, i)
                removedScaryAnimal = true
                removedItem = true
            else
                scaryAnimalCount = scaryAnimalCount + 1
            end
        end

        if removedItem == false then
            i = i + 1
        end
    end
    
    --Spawn one animal every 2-4 seconds
    --[[
    if scaryAnimalCount == 0 and scaryAnimalsSpawning == 0 then
      cron.after(math.random(2, 4), spawnScaryAnimal)
      scaryAnimalsSpawning = scaryAnimalsSpawning + 1
    end
    --]]
    
    --Spawn one animal every 2-4 seconds, up to 3 total
    if scaryAnimalCount < 3 and scaryAnimalsSpawning == 0 then
      cron.after(math.random(2, 4), spawnScaryAnimal)
      scaryAnimalsSpawning = scaryAnimalsSpawning + 1
    end
    
    if view_width > -ScreenWidth then            
            view_width = view_width - 2
            if view_width <= -ScreenWidth then
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
    
    if player:isHitScaryAnimal() then
      panicmeter:incPanic()      
      player:resetHitScaryAnimal()
    end

end

function drawGameOver()
  local image = love.graphics.newImage( 'assets/images/GameOverScreen.png' )
  love.graphics.setColor(255, 255, 255,255);
  local msg1 = "You were caught! But you made it " .. distance:getDistance() .. " meters. " 
  local msg2 = "Press Enter to play again..."
  local font = love.graphics.newFont('assets/fonts/LilyScriptOne-Regular.ttf', DistanceFontSize)
  love.graphics.draw(image, 0, 0)
  love.graphics.setColor(0, 0, 0,255);
  love.graphics.print(msg1, ScreenWidth/2-font:getWidth(msg1)/2, ScreenHeight/2-font:getHeight());
  love.graphics.print(msg2, ScreenWidth/2-font:getWidth(msg2)/2, ScreenHeight/2);
  love.graphics.setColor(255, 255, 255,255);
end  

function drawGameScreen()
    love.graphics.drawq(image, quad, view_width, view_height)
    love.graphics.drawq(image, quad, ScreenWidth + view_width, view_height)
    for _, e in pairs(entities) do
        e:draw()
    end  
end

function love.draw()
    if isGameOver then
      drawGameOver()
    else
      drawGameScreen()
    end
end
