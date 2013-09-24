require 'scary_animal'
require 'entity'

describe("Scary Animals", function()

-- Scary animals
-- should appear on screen every 2-4s
-- the scaryAnimal shold pass through the scary animal
-- the scary animal should be on the ground

    describe("new scay animal",function()
        it("should be on the right hand side of the scren", function()

            local scaryAnimal = ScaryAnimal:new({})
            assert.is.equal(scaryAnimal.x, 350)
            assert.is.equal(scaryAnimal.y, 300)
        end)
    end)

    describe("drawing the scary animal", function()

        it("should be scary animal image", function()
            local scaryAnimal = ScaryAnimal:new({})
            assert.is.equal(scaryAnimal.graphics.source, "assets/images/scary-animal-sprites.png")
        end)

        it("should always be updating the animation state", function ()
            local scaryAnimal = ScaryAnimal:new({})
            scaryAnimal.graphics.animation = mock_animation()
            scaryAnimal:update(dt)
            assert.spy(scaryAnimal.graphics.animation.update).was.called()
        end)

    end)

end)
