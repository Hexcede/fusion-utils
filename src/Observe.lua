local Fusion = require(script.Parent.Parent.Fusion)
local Observer = Fusion.Observer

local Defer = require(script.Parent.Defer)

local function Observe<T>(stateObject: Fusion.StateObject<T>, callback: (value: T, ...any) -> ...any, ...)
	return Observer(stateObject):onChange(Defer(function(...)
		callback(stateObject:get(), ...)
	end, ...))
end

return Observe