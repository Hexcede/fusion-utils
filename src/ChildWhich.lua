local Fusion = require(script.Parent.Parent.Fusion)

local Value = Fusion.Value
local Hydrate = Fusion.Hydrate

local ChildWhichRef = require(script.Parent.ChildRef)
local Observe = require(script.Parent.Observe)

local ChildWhich = {
	type = "SpecialKey";
	kind = "ChildWhich";
	stage = "descendants";

	apply = function(self, value, applyTo, cleanupTasks)
		local childRef = Value()
		Hydrate(applyTo) {
			[ChildWhichRef(self.condition)] = childRef
		}

		local isHydrated = {}
		local result = Observe(childRef, function(child)
			if isHydrated[child] then return end
			isHydrated[child] = Hydrate(child)(value)
		end, Fusion.doNothing)

		table.insert(cleanupTasks, result)
		table.insert(cleanupTasks, function()
			childRef = nil
		end)
	end;
}
ChildWhich.__index = ChildWhich

return function(condition: (Instance) -> boolean)
	return setmetatable({ condition = condition; }, ChildWhich)
end
