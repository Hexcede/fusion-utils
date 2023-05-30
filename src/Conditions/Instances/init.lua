local Instances = {}

function Instances.IsA(class: string)
	return function(instance: Instance)
		return instance:IsA(class)
	end
end

function Instances.IsClass(class: string)
	return function(instance: Instance)
		return instance.ClassName == class
	end
end

return Instances