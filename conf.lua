-- Set DEBUG_MODE to true to enable useful debugging output
-- such as drawing the bounding box
--DEBUG_MODE = true

-- See https://love2d.org/wiki/Config_Files for the full list of configuration
-- options and defaults.
ScreenWidth = 700
ScreenHeight = 500
DistanceMeterYOffset = 30
DistanceMeterXOffset = ScreenWidth - 260
DistanceFontSize = 20
PathHeightOffset = 30

function love.conf(config)
    config.title = "New Game - Alex's Team"
    config.screen.width = ScreenWidth
    config.screen.height = ScreenHeight
    config.modules.joystick = false
    config.modules.mouse = false
    config.modules.physics = false
    config.jump_height = 1500
    config.gravity = 1000
end
