require 'entity'

ScaryAnimal = {}
ScaryAnimal.__index = ScaryAnimal
setmetatable(ScaryAnimal, {__index = Entity})

function ScaryAnimal:new(game, config)
    local config = config or {}

    local newScaryAnimal = Entity:new(game)
    newScaryAnimal.x = config.x or 525
    newScaryAnimal.y = config.y or 300

    return setmetatable(newScaryAnimal, self)
end

