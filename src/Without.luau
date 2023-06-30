local Unwrap = require(script.Parent.Unwrap)

local function Without(source)
	return function(with)
		local destination = table.clone(Unwrap(source))
		if type(with) == "table" then
			for _, index in ipairs(Unwrap(with)) do
				destination[index] = nil
			end
		end
		return destination
	end
end

return Without