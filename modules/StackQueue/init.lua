--[=[
	@class StackQueue
]=]
local StackQueue = {}
StackQueue.__index = StackQueue

--[=[
	Creates `StackQueue` instance.
]=]
function StackQueue.new(): StackQueue return setmetatable({ _Stack = {} }, StackQueue) end

--[=[
	Append function to queue.
]=]
function StackQueue:Append(fn: Function)
	table.insert(self._Stack, fn)
	if #self._Stack == 1 then self:_SpawnScheduler() end
end

function StackQueue:_SpawnScheduler()
	task.spawn(function()
		while #self._Stack > 0 do
			pcall(function() self._Stack[1]() end)
			-- function needs to be removed after it has been run to ensure single
			-- scheduler per class instance
			table.remove(self._Stack, 1)
		end
	end)
end

return StackQueue
