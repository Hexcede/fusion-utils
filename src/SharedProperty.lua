local RunService = game:GetService("RunService")
local Fusion = require(script.Parent.Parent.Fusion)

local Value = Fusion.Value
local Ref = Fusion.Ref
local Hydrate = Fusion.Hydrate
local New = Fusion.New
local OnEvent = Fusion.OnEvent
local Children = Fusion.Children

local Child = require(script.Parent.Child)
local Observe = require(script.Parent.Observe)

local REMOTE_CONTAINER_NAME = "_SharedProperties"

local SharedProperty = {
	type = "SpecialKey";
	kind = "SharedProperty";
	stage = "descendants";

	apply = function<T>(self, value: Fusion.Value<T>, applyTo, cleanupTasks)
		local name = self.name

		local remoteRef = Value()
		if RunService:IsServer() then
			Hydrate(applyTo) {
				[Child(REMOTE_CONTAINER_NAME)] = {
					[Children] = New "RemoteEvent" {
						[Ref] = remoteRef;

						Name = name;
						[OnEvent "OnServerEvent"] = function(player: Player)
							local remote = remoteRef:get()
							if not remote then return end
							remote:FireClient(player, value:get())
						end;
					}
				};
	
				[Children] = if not applyTo:FindFirstChild(REMOTE_CONTAINER_NAME) then New "Folder" {
					Name = REMOTE_CONTAINER_NAME;
				} else nil
			}

			table.insert(cleanupTasks, Observe(value, function(newValue)
				local remote = remoteRef:get()
				remote:FireAllClients(newValue)
			end))
		else
			Hydrate(applyTo) {
				[Child(REMOTE_CONTAINER_NAME)] = {
					[Ref] = remoteRef;

					[Child(name)] = {
						[OnEvent "OnClientEvent"] = function(newValue: any)
							value:set(newValue)
						end;
					}
				}
			}

			table.insert(cleanupTasks, Observe(remoteRef, function(remote)
				if not remote then return end
				remote:FireServer()
			end))
		end
	end
}
SharedProperty.__index = SharedProperty

return function(name: string)
	return setmetatable({ name = name; }, SharedProperty)
end