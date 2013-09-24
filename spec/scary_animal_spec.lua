require 'scary_animal'
require 'entity'

describe("Scary Animals", function()


-- should appear on screen every 2-4s

    describe("new scary animal",function()

        it("should be on the ground right hand side of the screen", function()
            local scaryAnimal = ScaryAnimal:new({})
            assert.is.equal(scaryAnimal.x, 350)
            assert.is.equal(scaryAnimal.y, 300)
        end)

        it("should be moving at speed 5 from right to left", function()

            local scaryAnimal = ScaryAnimal:new({})
            local origin_x = scaryAnimal.x

            scaryAnimal:update(dt)

            assert.is.equal(scaryAnimal.speed, 5)
            assert.is.equal(scaryAnimal.x, origin_x - scaryAnimal.speed)

        end)

    end)

    describe("drawing the scary animal", function()

        it("should look like a scary animal", function()
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
