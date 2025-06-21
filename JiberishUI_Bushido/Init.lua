local AddOnName, Engine = ...
local GetAddOnMetadata = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata

JiberishUIBushidoDB = JiberishUIBushidoDB or {}
Engine.Config = {}
Engine.Config.Version = GetAddOnMetadata(AddOnName, 'Version')
Engine.Options = {}
