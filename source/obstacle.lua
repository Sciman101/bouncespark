import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/sprites"

local gfx <const> = playdate.graphics

local obstacleImg = gfx.image.new('images/obstacle')

class('Obstacle').extends(gfx.sprite)

local OBSTACLE_SPEED <const> = 3

function Obstacle:init()
	Obstacle.super.init(self)
	-- Basic sprite stuff
	-- Obstacles are pooled so we just move them to 0,0 and hide them
	self:moveTo(0, 0)
	self:setImage(obstacleImg)
	self:setVisible(false)
	self:setUpdatesEnabled(false)

	self.type = 'obstacle'

	-- Collision
	self:setCollideRect(0, 0, 16, 16)
	self:setCollisionsEnabled(false)
	self:setGroups({ 2 })
	self:setCollidesWithGroups(1)
end

function Obstacle:spawn(x, y)
	self:setVisible(true)
	self:setCollisionsEnabled(true)
	self:setUpdatesEnabled(true)
	self:moveTo(x, y)
end
