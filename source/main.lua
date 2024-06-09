import "CoreLibs/graphics"
import "CoreLibs/timer"
import "CoreLibs/crank"
import "CoreLibs/sprites"

import 'pool'
import 'player'
import 'pickup'
import 'obstacle'

-- Game constants
local gfx <const> = playdate.graphics

local player
local pickups
local obstacles

local numberOfActivePickups = 0
local score = 0

slowdown = false -- nasty global eugh

local function randomPos()
    return math.random(16, 400 - 16), math.random(16, 240 - 16)
end

local function spawnPickup()
    local pickup = pickups:get()
    if pickup then
        pickup:spawn(randomPos())
        numberOfActivePickups += 1
    end
end

local function onPickupCollected(pickup)
    numberOfActivePickups -= 1
    score += 1
    pickups:reclaim(pickup)

    if numberOfActivePickups == 1 then
        local lastPickup = pickups.activeObjects[1]
        if lastPickup then
            lastPickup:disable()
            pickups:reclaim(lastPickup)
        else
            local x, y = randomPos()
            lastPickup = { x = x, y = y }
        end
        -- Spawn an obstacle
        local obstacle = obstacles:get()
        if obstacle then
            obstacle:spawn(lastPickup.x, lastPickup.y)
        end

        -- Spawn 3 new pickups
        for _ = 1, 3 do
            spawnPickup()
        end
    elseif numberOfActivePickups == 0 then
    end
end

local function setup()
    player = Player(200, 120)
    player:add()

    pickups = Pool(Pickup, 10, onPickupCollected)
    pickups:runOnInactive(function(p) p:add() end)

    obstacles = Pool(Obstacle, 20)
    obstacles:runOnInactive(function(p) p:add() end)

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

    -- Spawn initial pickups
    for _ = 1, 3 do
        spawnPickup()
    end
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
