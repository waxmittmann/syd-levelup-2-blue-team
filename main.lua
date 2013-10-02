require 'input'
require 'player'
require 'scary_animal'
require 'obstacle'
require 'world'
require 'distance'
require 'conf'
require 'person'

love.animation = require 'vendor/anim8'

local entities = {}
local world = World:new(love)
local image = love.graphics.newImage("assets/images/background.png")
local quad = love.graphics.newQuad(0,0, ScreenWidth, ScreenHeight, image:getWidth(), image:getHeight())

local max_view = -450
local view_width = 0
local view_height = 0

local player = Player:new(love)
local distance = Distance:new(love)

local cron = require 'cron'

local spawningCrowd = false

local isGameOver = false

function initGame()
  entities = {}
  world = World:new(love)
  quad = love.graphics.newQuad(0,0, ScreenWidth, ScreenHeight, image:getWidth(), image:getHeight())

  player = Player:new(love)
  distance = Distance:new(love)

  cron = require 'cron'

  spawningCrowd = false

  isGameOver = false  
    
  table.insert(entities, player)
  table.insert(entities, world)
  table.insert(entities, distance)
  
  cron.after(math.random(2, 4), spawnScaryAnimal)
end

function spawnScaryAnimal()
    local scaryAnimal = ScaryAnimal:new(love)
    table.insert(entities, scaryAnimal)
end

function removeOutOfBoundsCrowds()
    local i = 1
    local hadPerson = false
    while i <= #entities do
       if entities[i].type ~= nil and entities[i].type == "person" then
          if not world:onScreen(entities[i]) then
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

function spawnCrowd()
    local person = Person:new(love)
    local i = 0
    for i=0, math.random(0, 2) do
      local person = Person:new(love)
      person.x = person.x - (person.size.x * i)
      table.insert(entities, person)
    end
    spawningCrowd = false
end

function love.load()

    love.input.bind('up', 'up')
    love.input.bind('left', 'left')
    love.input.bind('right', 'right')
    love.input.bind('down', 'down')
    love.input.bind('return', 'return')
    
    -- more info on cron here http://tannerrogalsky.com/blog/2012/09/19/favourite-lua-libraries/

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
    end
    
    cron.update(dt)

    if spawningCrowd or removeOutOfBoundsCrowds() == false then
      spawnCrowd()
    end

    local i = 1    
    while i <= #entities do
        local removedItem = false
        if entities[i].type ~= nil and entities[i].type == 'scary_animal'
            and not world:onScreen(entities[i]) then
                table.remove(entities, i)
                cron.after(math.random(2, 4), spawnScaryAnimal)
                removedItem = true
        end

        if removedItem == false then
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

function drawGameOver()
  local image = love.graphics.newImage( 'assets/images/GameOverScreen.png' )
--  local quad = love.graphics.newQuad(0,0, image:getWidth(), image:getHeight(), 1, 1)
--  love.graphics.drawq( image, quad, 100, 100)
  love.graphics.setColor(255, 255, 255,255);
  local msg = "You were caught! But you made it " .. distance:getDistance() .. " meters. " .. "Press Enter to play again..."
  local font = love.graphics.newFont('assets/fonts/LilyScriptOne-Regular.ttf', DistanceFontSize)
  local offset = 100
  love.graphics.draw(image, 0, 0)
  love.graphics.setColor(0, 0, 0,255);
  love.graphics.print(msg, ScreenWidth/2-font:getWidth(msg)/2, ScreenHeight/2-font:getHeight()/2);
--  love.graphics.print(msg, ScreenWidth/2-font:getWidth(msg)/2, offset+ScreenHeight/2-font:getHeight()/2);
--  love.graphics.print(msg, 0);
--  love.graphics.draw(image, (ScreenWidth-image:getWidth())/2, ScreenHeight-image:getHeight()-font:getHeight()/2)
--  love.graphics.draw(image, (ScreenWidth-image:getWidth())/2, offset)
  love.graphics.setColor(255, 255, 255,255);
  return  
end  

function drawGameScreen()
    love.graphics.drawq(image, quad, view_width, view_height)
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
