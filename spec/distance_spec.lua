require 'distance'

describe("Distance", function()
	mock_graphics = function()
        local graphics_spy = {
            print = spy.new(function() end)
        }

        return graphics_spy
    end

	describe("#update", function()
		describe("every tick the timer should increment", function()
			local distance = Distance:new()
			distance:update(0.5)
			assert.is.equal(0.5, distance.counter)
		end)
	end)

	describe("#draw", function()
		describe("fractional distance should print nearest second", function()
			local game = {
				graphics = mock_graphics()
			}
			local distance = Distance:new(game)
			distance:update(1.65)
			distance:draw()

			assert.spy(game.graphics.print).was_called_with(1, 300, 300)
		end)
	end)
end)