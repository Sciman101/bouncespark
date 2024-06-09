import "CoreLibs/object"

class('Pool').extends(Object)

function Pool:init(object, capacity, ...)
	Pool.super.init(self)
	self.inactiveObjects = table.create(capacity)
	self.activeObjects = table.create(capacity)
	for i = 1, capacity do
		local o = object(...)
		self.inactiveObjects[i] = object(...)
	end
	self.capacity = capacity
end

function Pool:get()
	if #self.inactiveObjects > 0 then
		local obj = self.inactiveObjects[#self.inactiveObjects]
		self.inactiveObjects[#self.inactiveObjects] = nil
		self.activeObjects[#self.activeObjects + 1] = obj
		return obj
	end
	print('Attempting to get resource from empty pool!')
	return nil
end

function Pool:reclaim(obj)
	local i = table.indexOfElement(self.activeObjects, obj)
	if i then
		table.remove(self.activeObjects, i)
	end
	self.inactiveObjects[#self.inactiveObjects + 1] = obj
	if obj.reclaim then
		obj.reclaim()
	end
end

function Pool:runOnInactive(f)
	for i = 1, #self.inactiveObjects do
		f(self.inactiveObjects[i])
	end
end
