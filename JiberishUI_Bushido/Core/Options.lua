local E, L, V, P, G = unpack(ElvUI)
local ACH = E.Libs.ACH
local PI = E.PluginInstaller
local AddOnName, Engine = ...

local tconcat, sort = table.concat, sort
local config = Engine.Config

local function SortList(a, b)
	return E:StripString(a) < E:StripString(b)
end
sort(config.Credits, SortList)
local CREDITS_STRING = tconcat(config.Credits, '|n')
local hexElvUIBlue = '|cff1785d1'

local function GetBlizzardProfile()
	if not E.Retail then return end
	local EMO = E.Libs.EditModeOverride
	EMO:LoadLayouts()
	return EMO:GetActiveLayout() or UNKNOWN
end

local function GetCurrentProfile(addon, profile)
	if addon == 'blizzard' then
		return GetBlizzardProfile()
	elseif addon == 'elvui' and profile == 'general' then
		return E.data:GetCurrentProfile()
	elseif addon == 'elvui' and profile == 'private' then
		return E.charSettings:GetCurrentProfile()
	elseif addon == 'details' then
		return Details:GetCurrentProfileName()
	elseif addon == 'bigwigs' then
		return Engine.BigWigs:GetCurrentProfileName()
	elseif addon == 'omnicd' then
		return OmniCD and OmniCD[1].DB:GetCurrentProfile()
	elseif addon == 'plater' then
		return Plater and Plater.db:GetCurrentProfile()
	end
end

local function SetCurrentProfileHeader(addon, profileID)
	if not addon or not Engine.ProfileData[addon] then return Engine:Print('Invalid addon argument.') end
	if not profileID or profileID == '' then return Engine:Print('Invalid profile id argument.') end

	local curProfile = ''
	if addon == 'Blizzard' then
		curProfile = GetBlizzardProfile()
	elseif addon == 'ElvUI' and profileID == 'Profile1' then
		curProfile =  E.data:GetCurrentProfile()
	elseif addon == 'ElvUI' and profileID == 'Private1' then
		curProfile =  E.charSettings:GetCurrentProfile()
	elseif addon == 'Details' then
		curProfile =  Details:GetCurrentProfileName()
	elseif addon == 'BigWigs' then
		curProfile =  Engine.BigWigs:GetCurrentProfileName()
	elseif addon == 'OmniCD' then
		curProfile =  OmniCD and OmniCD[1].DB:GetCurrentProfile()
	elseif addon == 'Plater' then
		curProfile =  Plater and Plater.db:GetCurrentProfile()
	end

	return format('Current Profile: |cff5CE1E6%s|r', curProfile)
end

local function UpdateCurrentProfileHeder(addon, profileID)
	if not profileID or profileID == '' then return Engine:Print('Invalid profile id argument.') end
	if not E.Options.args.JiberishUIBushido.args.steps.args[addon].args[profileID..'Header'] then return Engine:Print('Invalid profile id argument.') end
	E.Options.args.JiberishUIBushido.args.steps.args[addon].args[profileID..'Header'].name = SetWeakAuraHeader(profileID)
	E:RefreshGUI()
end

local function SetWeakAuraHeader(profileID)
	if not profileID then return Engine:Print('Invalid profile id argument.') end
	local profileString = Engine.ProfileData.WeakAuras[profileID..'String']
	if not profileString or profileString == '' then return Engine:Print('No profile string provided.') end
	local doesExist = Engine.WeakAuras:doesAuraExist(profileString)

	return format('%s %s(|r%s%s)|r', Engine.ProfileData.WeakAuras[profileID..'ButtonText'], hexElvUIBlue, doesExist and '|cff99ff33Detected|r' or '|cffff3300Not Detected|r', hexElvUIBlue)
end

local function UpdateWeakAuraHeader(profileID)
	if not profileID or profileID == '' then return Engine:Print('Invalid profile id argument.') end
	if not E.Options.args.JiberishUIBushido.args.steps.args.WeakAuras.args[profileID..'Header'] then return Engine:Print('Invalid profile id argument.') end
	E.Options.args.JiberishUIBushido.args.steps.args.WeakAuras.args[profileID..'Header'].name = SetWeakAuraHeader(profileID)
	E:RefreshGUI()
end

local function SetupProfileButton(addon, profileID, callback)
	if not addon or not Engine.ProfileData[addon] then return Engine:Print('Invalid addon argument.') end
	if not profileID then return Engine:Print('Invalid profile id argument.') end

	local profileString = Engine.ProfileData[addon][profileID..'String']
	if not profileString then return Engine:Print('No profile string provided.') end

	Engine[addon]:SetupProfile(profileString, profileID, callback)
end

local function configTable()
	local options = ACH:Group(config.Title, nil, 99, 'tab')
	E.Options.args.JiberishUIBushido = options
	options.args.logo = ACH:Description('', 1, nil, 'Interface\\AddOns\\JiberishUI_Bushido\\Media\\BusdhidoLogo512', imageCoords, 160, 160, width, hidden)
	options.args.header = ACH:Header(format('|cff99ff33%s|r', config.Version), 2)
	options.args.installButton = ACH:Execute('Run Installer', 'This will launch the step by step installer.', 3, function() PI:Queue(Engine.InstallerData) E:ToggleOptions() end)

	local Steps = ACH:Group(L["AddOn Steps"], nil, 1)
	options.args.steps = Steps

	for name, v in next, Engine.ProfileData do
		Steps.args[name] = ACH:Group(name, nil, 10)
		Steps.args[name].args.title = ACH:Header(name, 1)
	end

	--* BigWigs
	local BigWigs = Steps.args.BigWigs
	BigWigs.args.Profile1Header = ACH:Header(SetCurrentProfileHeader('BigWigs', 'Profile1'), 1)
	BigWigs.args.spacer = ACH:Spacer(3, 'full')
	BigWigs.args.button1 = ACH:Execute(Engine.ProfileData.BigWigs.Profile1ButtonText, 'This will import the BigWigs profile.', 4, function() Engine:Print("i said no jib lol") end, nil, nil, 'full')

	--* Blizzard (Retail Only)
	local Blizzard = Steps.args.Blizzard
	-- Blizzard.hidden = not E.Retail
	-- Blizzard.args.profile = ACH:Description(format('Current Profile: |cff5CE1E6%s|r', GetCurrentProfile('blizzard')), 2, nil, nil, nil, nil, nil, 'full')
	-- ACH:Header(name, order, get, set, hidden)
	Blizzard.args.profile = ACH:Header(format('Current Profile: |cff5CE1E6%s|r', GetCurrentProfile('blizzard')), 2, nil, nil, not E.Retail)
	-- ACH:Spacer(order, width, hidden)
	Blizzard.args.spacer = ACH:Spacer(3, 'full', not E.Retail)
	-- Blizzard.args.button1 = ACH:Execute(format('%s %s %s', 'Setup', E:TextureString([[Interface\AddOns\JiberishUI_Bushido\Media\Blizzard]], ':25:55'), 'Layout'), 'Re-Run step 2 of the installation process.', 50, function() end)
	-- ACH:Execute(name, desc, order, func, image, confirm, width, get, set, disabled, hidden)
	Blizzard.args.button1 = ACH:Execute(format('%s %s %s', 'Setup', E:TextureString([[Interface\AddOns\JiberishUI_Bushido\Media\Blizzard]], ':25:55'), 'Layout'), 'This will import the Blizzard layout.', 50, function() Engine:Print("i said no jib lol") end, nil, nil, 'full', nil, nil, nil, not E.Retail)
	Blizzard.args.button2 = ACH:Execute('Setup Chat', 'Setup chat frame channels.', 51, function() Engine:Print("i said no jib lol") end, nil, nil, 'full', nil, nil, nil, not E.Retail)

	--* Details
	local Details = Steps.args.Details
	Details.args.profile = ACH:Header(format('Current Profile: |cff5CE1E6%s|r', GetCurrentProfile('details')), 2)
	Details.args.spacer = ACH:Spacer(3, 'full')
	Details.args.button1 = ACH:Execute(Engine.ProfileData.Details.Profile1ButtonText, 'This will import the Details profile.', 4, function() Engine:Print("i said no jib lol") end, nil, nil, 'full')

	--* ElvUI Global Profile
	local ElvUI = Steps.args.ElvUI
	ElvUI.args.globalHeader = ACH:Header('Global', 5)
	ElvUI.args.globalButton = ACH:Execute(Engine.ProfileData.ElvUI.Global1ButtonText, 'This will import the ElvUI global profile.', 6, function() Engine:Print("i said no jib lol") end, nil, nil, 'full')
	ElvUI.args.spacer2 = ACH:Spacer(7, 'full')

	ElvUI.args.generalHeader = ACH:Header('General Profile', 10)
	ElvUI.args.generalProfile = ACH:Header(format('Current Profile: |cff5CE1E6%s|r', GetCurrentProfile('elvui', 'general')), 11)
	ElvUI.args.generalButton = ACH:Execute(Engine.ProfileData.ElvUI.Profile1ButtonText, 'This will import the ElvUI general profile.', 12, function() Engine:Print("i said no jib lol") end, nil, nil, 'full')
	ElvUI.args.spacer3 = ACH:Spacer(13, 'full')

	ElvUI.args.privateHeader = ACH:Header('Private Profile', 20)
	ElvUI.args.privateProfile = ACH:Header(format('Current Profile: |cff5CE1E6%s|r', GetCurrentProfile('elvui', 'private')), 21)
	ElvUI.args.privateButton = ACH:Execute(Engine.ProfileData.ElvUI.Private1ButtonText, 'This will import the ElvUI private profile.', 22, function() Engine:Print("i said no jib lol") end, nil, nil, 'full')

	--* WeakAuras
	local WeakAuras = Steps.args.WeakAuras
	WeakAuras.args.Profile1Header = ACH:Header(SetWeakAuraHeader('Profile1'), 10)
	WeakAuras.args.Profile1Button = ACH:Execute(format('Setup %s', Engine.ProfileData.WeakAuras.Profile1ButtonText), 'You can import the aura by clicking the button.', 11, function(info) SetupProfileButton('WeakAuras', 'Profile1', UpdateWeakAuraHeader) end, nil, nil, 'full')
	WeakAuras.args.spacer1 = ACH:Spacer(19, 'full')
	WeakAuras.args.Profile2Header = ACH:Header(SetWeakAuraHeader('Profile2'), 20)
	WeakAuras.args.Profile2Button = ACH:Execute(format('Setup %s', Engine.ProfileData.WeakAuras.Profile2ButtonText), 'You can import the aura by clicking the button.', 21, function(info) SetupProfileButton('WeakAuras', 'Profile2', UpdateWeakAuraHeader) end, nil, nil, 'full')
	WeakAuras.args.spacer2 = ACH:Spacer(29, 'full')
	WeakAuras.args.Profile3Header = ACH:Header(SetWeakAuraHeader('Profile3'), 30)
	WeakAuras.args.Profile3Button = ACH:Execute(format('Setup %s', Engine.ProfileData.WeakAuras.Profile3ButtonText), 'You can import the aura by clicking the button.', 31, function(info) SetupProfileButton('WeakAuras', 'Profile3', UpdateWeakAuraHeader) end, nil, nil, 'full')
	WeakAuras.args.spacer3 = ACH:Spacer(39, 'full')
	WeakAuras.args.Profile4Header = ACH:Header(SetWeakAuraHeader('Profile4'), 40)
	WeakAuras.args.Profile4Button = ACH:Execute(format('Setup %s', Engine.ProfileData.WeakAuras.Profile4ButtonText), 'You can import the aura by clicking the button.', 41, function(info) SetupProfileButton('WeakAuras', 'Profile4', UpdateWeakAuraHeader) end, nil, nil, 'full')

	--* Help
	local Help = ACH:Group(L["Help"], nil, 98, 'tab')
	options.args.help = Help
	Help.args.header = ACH:Header('Get Support', 1)

	local Support = ACH:Group('', nil, 2)
	Help.args.support = Support
	Support.inline = true
	Support.args.wago = ACH:Execute(L["Wago Page"], nil, 1, function() E:StaticPopup_Show('ELVUI_EDITBOX', nil, nil, 'https://addons.wago.io/addons/actionbar-buddy-elvui-plugin') end, nil, nil, 140)
	Support.args.curse = ACH:Execute(L["Curseforge Page"], nil, 1, function() E:StaticPopup_Show('ELVUI_EDITBOX', nil, nil, 'https://www.curseforge.com/wow/addons/actionbar-buddy-elvui-plugin') end, nil, nil, 140)
	Support.args.git = ACH:Execute(L["Ticket Tracker"], nil, 2, function() E:StaticPopup_Show('ELVUI_EDITBOX', nil, nil, 'https://github.com/Repooc/ElvUI_ActionBarBuddy/issues') end, nil, nil, 140)
	Support.args.discord = ACH:Execute(L["Discord"], nil, 3, function() E:StaticPopup_Show('ELVUI_EDITBOX', nil, nil, 'https://repoocreforged.dev/discord') end, nil, nil, 140)



	local credits = ACH:Group(L["Credits"], nil, 99)
	options.args.credits = credits

	credits.args.header = ACH:Header('Thank to all that have supported this project!', 1)
	credits.args.string = ACH:Description(CREDITS_STRING, 5, 'medium')
	credits.args.spacer = ACH:Spacer(6, 'full')
	local discordRolePath = [[Interface\AddOns\JiberishUI_Bushido\Media]]
	local discordTextures = E:TextureString(discordRolePath..'\\FabledMyth', ':80:80')..E:TextureString(discordRolePath..'\\Legend', ':80:80')..E:TextureString(discordRolePath..'\\Immortal', ':80:80')..E:TextureString(discordRolePath..'\\Eternal', ':80:80')..E:TextureString(discordRolePath..'\\Mythos', ':80:80')
	credits.args.thankyou = ACH:Description(E:TextGradient('Thank you to the JiberishUI Community & Supporters', 0.25, 0.78, 0.92, 0.64, 0.19, 0.79, 0.96, 0.55, 0.73), 7)
	credits.args.supporterroles = ACH:Description(discordTextures, 10)
end
-- ACH:Spacer(order, width, hidden)
tinsert(Engine.Options, configTable)
