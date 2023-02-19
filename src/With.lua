local Unwrap = require(script.Parent.Unwrap)

local function With(source)
	return function(with)
		local destination = table.clone(Unwrap(source))
		if type(with) == "table" then
			for index, value in pairs(Unwrap(with)) do
				destination[index] = value
			end
		end
		return destination
	end
end

return With