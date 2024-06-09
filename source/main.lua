import "CoreLibs/graphics"
import "CoreLibs/timer"
import "CoreLibs/crank"
import "CoreLibs/sprites"

import 'player'

-- Game constants
local gfx <const> = playdate.graphics

local player

local function setup()
    player = Player(200, 120)
    player:add()

    gfx.sprite.setBackgroundDrawingCallback(
        function(x, y, width, height)
            gfx.clear(gfx.kColorBlack)
        end
    )

    playdate.inputHandlers.push({
        rightButtonDown = function()
            player:startAiming()
        end,
        rightButtonUp = function()
            player:stopAiming()
        end
    })
end

function playdate.update()
    playdate.timer.updateTimers()
    gfx.sprite.update()

    -- Draw player overlays
    if player.aiming then
        local angle = math.rad(playdate.getCrankPosition() or 0)
        local xx = math.cos(angle) * 32
        local yy = math.sin(angle) * 32
        gfx.setColor(gfx.kColorWhite)
        gfx.drawLine(player.x, player.y, player.x + xx, player.y + yy)
    elseif not player.canAim then
        local progress = player.aimCooldownTimer.timeLeft / player.aimCooldownTimer.duration
        gfx.drawArc(player.x, player.y, 18, 0, 360 * progress)
    end
end

setup()
