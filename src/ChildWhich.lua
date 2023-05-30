local Fusion = require(script.Parent.Parent.Fusion)

local Value = Fusion.Value
local Hydrate = Fusion.Hydrate
local Cleanup = Fusion.Cleanup

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
			if not child then return end
			if isHydrated[child] then return end
			isHydrated[child] = Hydrate(child)(value)

			-- Bind to child
			Hydrate(child)(value)

			-- Bind to cleanup of child
			Hydrate(child) {
				[Cleanup] = function()
					isHydrated[child] = nil
				end;
			}
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
