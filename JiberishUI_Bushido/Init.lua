local E, _, V, P, G = unpack(ElvUI)
local AddOnName, Engine = ...
local GetAddOnMetadata = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata

Engine.Config = {}
Engine.Config.Version = GetAddOnMetadata(AddOnName, 'Version')
Engine.Config.TestDBInfo = GetAddOnMetadata(AddOnName, 'X-SavedVariables')
Engine.Options = {}

JiberishUIBushidoDB = JiberishUIBushidoDB or {}
