local ChildWhichRef = {
	type = "SpecialKey";
	kind = "ChildWhichRef";
	stage = "descendants";

	apply = function(self, value, applyTo, cleanupTasks)
		local condition = self.condition

		if not applyTo then return end

		for _, child in ipairs(applyTo:GetChildren()) do
			if condition(child) then
				value:set(child)
				break
			end
		end

		table.insert(cleanupTasks, applyTo.ChildAdded:Connect(function(newChild)
			if condition(newChild) then
				value:set(newChild)
			end
		end))
	end;
}
ChildWhichRef.__index = ChildWhichRef

return function(condition: (Instance) -> boolean)
	return setmetatable({ condition = condition; }, ChildWhichRef)
end
