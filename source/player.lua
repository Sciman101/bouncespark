import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/sprites"

local gfx <const> = playdate.graphics

local playerImg = gfx.image.new('images/player')

class('Player').extends(gfx.sprite)

local MOVE_SPEED <const> = 6
local AIM_SLOWDOWN <const> = 0.1
local AIM_COOLDOWN_DURATION <const> = 0.5

function Player:init(x, y)
	Player.super.init(self)
	-- Basic sprite stuff
	self:moveTo(x, y)
	self:setImage(playerImg)

	-- Collision
	self:setCollideRect(0, 0, self.width, self.height)
	self:setGroups({ 1 })
	self:setCollidesWithGroups(2)

	self.aiming = false
	self.canAim = true

	-- Setup aim timer
	local t = playdate.timer.new(AIM_COOLDOWN_DURATION * 1000, function()
		self.canAim = true
	end)
	t:pause()
	t.discardOnCompletion = false
	self.aimCooldownTimer = t

	self.vx = MOVE_SPEED
	self.vy = 0
end

function Player:collisionResponse(other)
	return 'overlap'
end

function Player:update()
	-- Bounce horizontal
	if self.x + self.vx > 400 - 8 or self.x + self.vx < 8 then
		self.vx = -self.vx
	end
	-- Bounce vertical
	if self.y + self.vy > 240 - 8 or self.y + self.vy < 8 then
		self.vy = -self.vy
	end

	local vx, vy = self.vx, self.vy
	if self.aiming then
		vx *= AIM_SLOWDOWN
		vy *= AIM_SLOWDOWN
	end

	local _, _, collisions = self:moveWithCollisions(self.x + vx, self.y + vy)

	-- Collide with pickups
	for i = 1, #collisions do
		local col = collisions[i]
		if col.other.type == 'pickup' then
			col.other:collect()
		elseif col.other.type == 'obstacle' then
			-- Game over D:
		end
	end
end

function Player:startAiming()
	if self.canAim then
		self.aiming = true
		slowdown = true
	end
end

function Player:stopAiming()
	if self.canAim and self.aiming then
		-- Lock in new direction
		local angle = math.rad(playdate.getCrankPosition() or 0)
		self.vx = math.cos(angle) * MOVE_SPEED
		self.vy = math.sin(angle) * MOVE_SPEED
		-- Set cooldown
		self.aiming = false
		slowdown = false
		self.canAim = false
		self.aimCooldownTimer:reset()
		self.aimCooldownTimer:start()
	end
end
