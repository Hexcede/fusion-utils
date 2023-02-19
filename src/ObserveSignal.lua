local Defer = require(script.Parent.Defer)

local function ObserveSignal<T>(signal: RBXScriptSignal<T>, callback: (value: T?, ...any) -> ...any, ...)
	local connection = signal:Connect(Defer(callback, ...))
	return function()
		connection:Disconnect()
	end
end

return ObserveSignal
