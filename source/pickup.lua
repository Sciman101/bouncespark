import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/sprites"

local gfx <const> = playdate.graphics

local pickupImg = gfx.image.new('images/pickup')

class('Pickup').extends(gfx.sprite)

function Pickup:init(collectedCallback)
	Pickup.super.init(self)
	-- Basic sprite stuff
	-- Pickups are pooled so we just move them to 0,0 and hide them
	self:moveTo(0, 0)
	self:setImage(pickupImg)
	self:setVisible(false)

	self.type = 'pickup'
	self.collectedCallback = collectedCallback

	-- Collision
	self:setCollideRect(0, 0, 16, 16)
	self:setCollisionsEnabled(false)
	self:setGroups({ 2 })
	self:setCollidesWithGroups(1)
end

function Pickup:spawn(x, y)
	self:setVisible(true)
	self:setCollisionsEnabled(true)
	self:moveTo(x, y)
end

function Pickup:disable()
	self:setVisible(false)
	self:setCollisionsEnabled(false)
end

function Pickup:collect()
	self:disable()
	self:collectedCallback()
end
