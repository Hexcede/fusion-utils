local Defer = require(script.Parent.Defer)

local AttributeOut = {
	type = "SpecialKey";
	kind = "AttributeOut";
	stage = "self";

	apply = function(self, value, applyTo, cleanupTasks)
		local attribute = self.attribute
		table.insert(cleanupTasks, applyTo:GetAttributeChangedSignal(attribute):Connect(Defer(function()
			value:set(applyTo:GetAttribute(attribute))
		end)))
	end;
}
AttributeOut.__index = AttributeOut

return function(attribute: string)
	return setmetatable({ attribute = attribute; }, AttributeOut)
end
