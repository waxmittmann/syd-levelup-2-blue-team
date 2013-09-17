require 'scary_animal'
require 'entity'

describe("Scary Animals", function()

-- Scary animals
-- should appear on screen every 2-4s
-- the player shold pass through the scary animal
-- the scary animal should be on the ground

    describe("new scay animal",function()
        it("should be on the right hand side of the scren", function()   

            local scaryAnimal = ScaryAnimal:new({})
            assert.is.equal(scaryAnimal.x, 525)
            assert.is.equal(scaryAnimal.y, 300)
        end)
    end)

end)
