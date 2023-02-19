local Unwrap = require(script.Parent.Unwrap)

local function WithItems(source)
	return function(with)
		local destination = table.clone(Unwrap(source))
		if type(with) == "table" then
			local withUnwrapped = Unwrap(with)
			table.move(withUnwrapped, 1, #withUnwrapped, #destination + 1, destination)
		end
		return destination
	end
end

return WithItems