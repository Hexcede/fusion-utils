local function Defer(callback, ...)
	task.defer(callback, ...)
	return callback
end

return Defer