import "CoreLibs/graphics"
import "CoreLibs/timer"
import "CoreLibs/crank"
import "CoreLibs/sprites"

-- Game constants
local gfx <const> = playdate.graphics

function setup()
end

function playdate.update()
    playdate.timer.updateTimers()
    gfx.sprite.update()
end

setup()
