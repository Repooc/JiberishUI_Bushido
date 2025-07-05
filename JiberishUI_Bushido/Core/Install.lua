local AddOnName, Engine = ...
local E, L = unpack(ElvUI)
local D = E.Distributor
local PI = E.PluginInstaller

local config = Engine.Config
local hexElvUIBlue = '|cff1785d1'

local mediaPath = [[Interface\AddOns\JiberishUI_Bushido\Media\Story\]]
local bushidoStory = {
	[1] = {
		size = { 256, 256 },
	},
	[2] = {
		size = { 256, 256 },
	},
	[3] = {
		size = { 384, 256 },
	},
	[4] = {
		size = { 256, 256 },
	},
	[5] = {
		size = { 256, 256 },
	},
	[6] = {
		size = { 256, 256 },
	},
	[7] = {
		size = { 256, 256 },
	},
	[8] = {
		size = { 256, 256 },
	},
	[9] = {
		size = { 256, 256 },
	},
	[10] = {
		size = { 256, 256 },
	},
	[11] = {
		size = { 256, 256 },
	},
	[12] = {
		size = { 256, 256 },
	},
}

local function GetStoryImage(page)
	if not page then return nil end
	if not bushidoStory[page] then return nil end
	local image = mediaPath..page
	return image, bushidoStory[page].size
end

local function BigWigsDesc3Text()
	return not E:IsAddOnEnabled('BigWigs') and '|cffFF3333WARNING:|r Details! is not enabled to configure.' or ''
end

local function BlizzardDesc1Text()
	local EMO = E.Libs.EditModeOverride
	EMO:LoadLayouts()
	local activeLayout = EMO:GetActiveLayout()
	_G.PluginInstallFrame.Desc1:SetText(format('%sCurrent Layout:|r %s%s|r|n%s(|rHit ESC %s>|r Edit Mode %s>|r Layout%s)|r', '|cffFFD900', '|cff5CE1E6', activeLayout, hexElvUIBlue, hexElvUIBlue, hexElvUIBlue, hexElvUIBlue))
end

local function DetailsDesc1Text()
	_G.PluginInstallFrame.Desc1:SetText(E:IsAddOnEnabled('Details') and format('%sCurrent Profile:|r %s%s|r|n%s(|rDetails Config %s>|r Options %s>|r Profiles%s)|r', '|cffFFD900', '|cff5CE1E6', Details:GetCurrentProfileName(), hexElvUIBlue, hexElvUIBlue, hexElvUIBlue, hexElvUIBlue) or '')
end

local function DetailsDesc2Text()
	return E:IsAddOnEnabled('Details') and format('|cffFFD900This page will setup the Details profile for %s|r', config.Title) or ''
end

local function DetailsDesc3Text()
	return not E:IsAddOnEnabled('Details') and '|cffFF3333WARNING:|r Details! is not enabled to configure.' or ''
end

local function ElvUIProfileDescText()
	return format('%sCurrent Profile:|r %s%s|r|n%s(|rElvUI Config %s>|r Profiles %s>|r Profile Tab%s)|r', '|cffFFD900', '|cff5CE1E6', E.data:GetCurrentProfile(), hexElvUIBlue, hexElvUIBlue, hexElvUIBlue, hexElvUIBlue)
end

local function OmniCDDesc1Text()
	return E:IsAddOnEnabled('OmniCD') and format('%sCurrent Profile:|r %s%s|r|n%s(|rOmniCD Config %s>|r Profiles%s)|r', '|cffFFD900', '|cff5CE1E6', OmniCD[1].DB:GetCurrentProfile(), hexElvUIBlue, hexElvUIBlue, hexElvUIBlue) or ''
end

local function PlaterDesc1Text()
	return E:IsAddOnEnabled('Plater') and format('%sCurrent Profile:|r %s%s|r|n%s(|rPlater Config %s>|r Profiles %s>|r Profile Settings%s)|r', '|cffFFD900', '|cff5CE1E6', Plater.db:GetCurrentProfile(), hexElvUIBlue, hexElvUIBlue, hexElvUIBlue, hexElvUIBlue) or ''
end

local function WeakAuraButtonText(profileID)
	if not profileID then return Engine:Print('Invalid profile id argument.') end
	local profileString = Engine.ProfileData.WeakAuras[profileID..'String']
	if not profileString or profileString == '' then return Engine:Print('No profile string provided.') end
	local doesExist = Engine.WeakAuras:doesAuraExist(profileString)
	local profileNum = tonumber(profileID:match('%d+'))

	if _G.PluginInstallFrame:IsShown() and _G.PluginInstallFrame.Title:GetText() == Engine.InstallerData.Title and _G.PluginInstallFrame.CurrentPage == 11 then
		_G.PluginInstallFrame['Option'..profileNum]:SetText(doesExist and format('%s\n%s(|r%s%s)|r', Engine.ProfileData.WeakAuras[profileID..'ButtonText'], hexElvUIBlue, '|cff99ff33Detected|r', hexElvUIBlue) or Engine.ProfileData.WeakAuras[profileID..'ButtonText'])
	end
end

local function SetupProfileButton(addon, profileID, callback)
	if not addon or not Engine.ProfileData[addon] then return Engine:Print('Invalid addon argument.') end
	if not profileID then return Engine:Print('Invalid profile id argument.') end

	local profileString = Engine.ProfileData[addon][profileID..'String']
	if not profileString then return Engine:Print('No profile string provided.') end

	Engine[addon]:SetupProfile(profileString, profileID, callback)
end

local function SetupOptionPreview()
	if not _G.PluginInstallFrame.optionPreview then
		_G.PluginInstallFrame.optionPreview = _G.PluginInstallFrame:CreateTexture()
		_G.PluginInstallFrame.optionPreview:SetAllPoints(_G.PluginInstallFrame)
	end
end

local function SetupOptionScripts(script, texture)
	if script == 'onEnter' then
		PluginInstallFrame.optionPreview:SetTexture(texture)
		if texture and texture ~= '' then
			--* Not sure which one is feels better
			-- UIFrameFadeIn(PluginInstallFrame.optionPreview, 0.5, 0, 0.7)
			-- UIFrameFadeOut(PluginInstallFrame.tutorialImage, 0.4, 1, 0)
			-- UIFrameFadeOut(PluginInstallFrame.Desc1, 0.4, 1, 0)
			-- UIFrameFadeOut(PluginInstallFrame.Desc2, 0.4, 1, 0)
			-- UIFrameFadeOut(PluginInstallFrame.Desc3, 0.4, 1, 0)
			-- UIFrameFadeOut(PluginInstallFrame.Desc4, 0.4, 1, 0)
			-- UIFrameFadeOut(PluginInstallFrame.SubTitle, 0.4, 1, 0)

			UIFrameFadeIn(_G.PluginInstallFrame.optionPreview, 0.5, _G.PluginInstallFrame.optionPreview:GetAlpha(), 0.7)
			UIFrameFadeOut(_G.PluginInstallFrame.tutorialImage, 0.4, _G.PluginInstallFrame.tutorialImage:GetAlpha(), 0)
			UIFrameFadeOut(_G.PluginInstallFrame.Title, 0.4, _G.PluginInstallFrame.Title:GetAlpha(), 0)
			UIFrameFadeOut(_G.PluginInstallFrame.Prev, 0.4, _G.PluginInstallFrame.Prev:GetAlpha(), 0)
			UIFrameFadeOut(_G.PluginInstallFrame.Status, 0.4, _G.PluginInstallFrame.Status:GetAlpha(), 0)
			UIFrameFadeOut(_G.PluginInstallFrame.Next, 0.4, _G.PluginInstallFrame.Next:GetAlpha(), 0)
			UIFrameFadeOut(_G.PluginInstallFrame.Desc1, 0.4, _G.PluginInstallFrame.Desc1:GetAlpha(), 0)
			UIFrameFadeOut(_G.PluginInstallFrame.Desc2, 0.4, _G.PluginInstallFrame.Desc2:GetAlpha(), 0)
			UIFrameFadeOut(_G.PluginInstallFrame.Desc3, 0.4, _G.PluginInstallFrame.Desc3:GetAlpha(), 0)
			UIFrameFadeOut(_G.PluginInstallFrame.Desc4, 0.4, _G.PluginInstallFrame.Desc4:GetAlpha(), 0)
			UIFrameFadeOut(_G.PluginInstallFrame.SubTitle, 0.4, _G.PluginInstallFrame.SubTitle:GetAlpha(), 0)
		end
	elseif script == 'onLeave' then
		--* Not sure which one is feels better
		-- UIFrameFadeOut(PluginInstallFrame.optionPreview, 0.5, 0.7, 0)
		-- UIFrameFadeIn(PluginInstallFrame.tutorialImage, 0.4, 0, 1)
		-- UIFrameFadeIn(PluginInstallFrame.Desc1, 0.4, 0, 1)
		-- UIFrameFadeIn(PluginInstallFrame.Desc2, 0.4, 0, 1)
		-- UIFrameFadeIn(PluginInstallFrame.Desc3, 0.4, 0, 1)
		-- UIFrameFadeIn(PluginInstallFrame.Desc4, 0.4, 0, 1)
		-- UIFrameFadeIn(PluginInstallFrame.SubTitle, 0.4, 0, 1)

		UIFrameFadeOut(_G.PluginInstallFrame.optionPreview, 0.5, _G.PluginInstallFrame.optionPreview:GetAlpha(), 0)
		UIFrameFadeIn(_G.PluginInstallFrame.tutorialImage, 0.4, _G.PluginInstallFrame.tutorialImage:GetAlpha(), 1)
		UIFrameFadeIn(_G.PluginInstallFrame.Title, 0.4, _G.PluginInstallFrame.Title:GetAlpha(), 1)
		UIFrameFadeIn(_G.PluginInstallFrame.Prev, 0.4, _G.PluginInstallFrame.Prev:GetAlpha(), 1)
		UIFrameFadeIn(_G.PluginInstallFrame.Status, 0.4, _G.PluginInstallFrame.Status:GetAlpha(), 1)
		UIFrameFadeIn(_G.PluginInstallFrame.Next, 0.4, _G.PluginInstallFrame.Next:GetAlpha(), 1)
		UIFrameFadeIn(_G.PluginInstallFrame.Desc1, 0.4, _G.PluginInstallFrame.Desc1:GetAlpha(), 1)
		UIFrameFadeIn(_G.PluginInstallFrame.Desc2, 0.4, _G.PluginInstallFrame.Desc2:GetAlpha(), 1)
		UIFrameFadeIn(_G.PluginInstallFrame.Desc3, 0.4, _G.PluginInstallFrame.Desc3:GetAlpha(), 1)
		UIFrameFadeIn(_G.PluginInstallFrame.Desc4, 0.4, _G.PluginInstallFrame.Desc4:GetAlpha(), 1)
		UIFrameFadeIn(_G.PluginInstallFrame.SubTitle, 0.4, _G.PluginInstallFrame.SubTitle:GetAlpha(), 1)
	end
end

local function resizeInstaller(reset)
	if reset then
		--* Defaults
		_G.PluginInstallFrame:SetSize(450, 50)
		_G.PluginInstallFrame.Desc1:ClearAllPoints()
		_G.PluginInstallFrame.Desc1:SetPoint('TOPLEFT', _G.PluginInstallFrame, 'TOPLEFT', 20, -75)

		return
	end

	_G.PluginInstallFrame:SetSize(1040, 520)
	_G.PluginInstallFrame.Desc1:ClearAllPoints()
	_G.PluginInstallFrame.Desc1:SetPoint('TOP', _G.PluginInstallFrame.SubTitle, 'BOTTOM', 0, -30)
end

local function resetButtonScripts()
	for i = 1, 4 do
		_G.PluginInstallFrame['Option'..i]:SetScript('onEnter', nil)
		_G.PluginInstallFrame['Option'..i]:SetScript('onLeave', nil)
	end
end

--* Installer Template
Engine.InstallerData = {
	Title = format('%s |cffFFD900%s|r', config.Title, L["Installation"]),
	Name = config.Title,
	tutorialImage = config.Logo,
	tutorialImageSize = { 384, 384 },
	tutorialImagePoint = { 0, 0 },
	Pages = {
		[1] = function()
			SetupOptionPreview()
			resizeInstaller()
			resetButtonScripts()

			local fileName, size = GetStoryImage(1)
			PluginInstallFrame.tutorialImage:SetTexture(fileName)
			PluginInstallFrame.tutorialImage:SetSize(size[1], size[2])

			PluginInstallFrame.SubTitle:SetFormattedText('|cffFFD900%s|r', L["Welcome"])

			PluginInstallFrame.Desc1:SetFormattedText('|cff4BEB2C%s|r', format('The %s installer will guide you through some steps and apply all the profile settings needed for the layout.', config.Title))
			PluginInstallFrame.Desc2:SetFormattedText('|cffFFFF00%s|r', format('%s layouts were made using 0.71 UI Scale in ElvUI\'s options. If using another resolution/scale, you may need to adjust some frames size/location to ensure optimal placement for your setup.', config.Title))

			if JiberishUIBushidoDB.SkipElvUIPrivateStep then
				JiberishUIBushidoDB.SkipElvUIPrivateStep = nil
				PI:SetPage(6, 5)
			elseif JiberishUIBushidoDB.SkipPlaterStep then
				JiberishUIBushidoDB.SkipPlaterStep = nil
				PI:SetPage(10, 9)
			end
		end,
		[2] = function()
			--* Blizzard Layout
			resizeInstaller()
			resetButtonScripts()

			local fileName, size = GetStoryImage(2)
			PluginInstallFrame.tutorialImage:SetTexture(fileName)
			PluginInstallFrame.tutorialImage:SetSize(size[1], size[2])

			PluginInstallFrame.SubTitle:SetText(format('|cffFFD900%s|r', 'Blizzard Layout'))

			if E.Retail then
				local EMO = E.Libs.EditModeOverride
				EMO:LoadLayouts()
				local activeLayout = EMO:GetActiveLayout()
				PluginInstallFrame.Desc1:SetText(format('%sCurrent Layout:|r %s%s|r|n%s(|rHit ESC %s>|r Edit Mode %s>|r Layout%s)|r', '|cffFFD900', '|cff5CE1E6', activeLayout, hexElvUIBlue, hexElvUIBlue, hexElvUIBlue, hexElvUIBlue))
			end

			PluginInstallFrame.Option1:SetEnabled(true)
			PluginInstallFrame.Option1:SetScript('OnClick', function() SetupProfileButton('Blizzard', 'Profile1', BlizzardDesc1Text) end)
			PluginInstallFrame.Option1:SetText(format('%s %s', E:TextureString([[Interface\AddOns\JiberishUI_Bushido\Media\Blizzard]], ':25:55'), 'Layout'))
			PluginInstallFrame.Option1:SetShown(E.Retail)

			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript('OnClick', function() Engine.Blizzard:SetupChat() Engine:Print('Chat setup complete.') end)
			PluginInstallFrame.Option2:SetText('Setup Chat')
			PluginInstallFrame.Option2:Show()
		end,
		[3] = function()
			--* ElvUI Global Profile
			resizeInstaller()
			resetButtonScripts()

			local fileName, size = GetStoryImage(3)
			PluginInstallFrame.tutorialImage:SetTexture(fileName)
			PluginInstallFrame.tutorialImage:SetSize(size[1], size[2])

			PluginInstallFrame.SubTitle:SetText(format('%sGlobal Profile (%s)|r', '|cffFFD900', E.title))

			PluginInstallFrame.Desc1:SetText(format('|cff4BEB2C%s', 'This page will set up the global profile for ElvUI. The options in this profile will be shared across all characters on your account.'))
			PluginInstallFrame.Desc2:SetText(format('|cffFF3300Warning: |r%s', '|cffFFD900Be warned that this will overwrite your current global profile settings. There is no "undo" button, backup your WTF folder before proceeding.|r'))

			PluginInstallFrame.Option1:SetEnabled(true)
			PluginInstallFrame.Option1:SetScript('OnClick', function() SetupProfileButton('ElvUI', 'Global1') end)
			PluginInstallFrame.Option1:SetText(Engine.ProfileData.ElvUI.Global1ButtonText)
			PluginInstallFrame.Option1:Show()
		end,
		[4] = function()
			--* ElvUI General Profile
			resizeInstaller()

			local fileName, size = GetStoryImage(4)
			PluginInstallFrame.tutorialImage:SetTexture(fileName)
			PluginInstallFrame.tutorialImage:SetSize(size[1], size[2])

			PluginInstallFrame.SubTitle:SetText(format('|cffFFD900%s|r', format('General Profile (%s)', E.title)))

			PluginInstallFrame.Desc1:SetText(ElvUIProfileDescText())
			PluginInstallFrame.Desc2:SetText('|cff4BEB2CThis page will import the profile you clicked into ElvUI and make it the active profile. If the profile you click exists in the list of profiles in ElvUI, it will let you decide to overwrite or change the name of the selected profile.|r')

			PluginInstallFrame.Option1:SetEnabled(true)
			PluginInstallFrame.Option1:SetScript('OnClick', function() SetupProfileButton('ElvUI', 'Profile1') PluginInstallFrame.Desc1:SetText(ElvUIProfileDescText()) end)
			PluginInstallFrame.Option1:SetScript('onEnter', function() SetupOptionScripts('onEnter', Engine.ProfileData.ElvUI.Profile1Preview) end)
			PluginInstallFrame.Option1:SetScript('onLeave', function() SetupOptionScripts('onLeave') end)
			PluginInstallFrame.Option1:SetText(Engine.ProfileData.ElvUI.Profile1ButtonText)
			PluginInstallFrame.Option1:Show()
		end,
		[5] = function()
			--* ElvUI Private Profile
			resizeInstaller()
			resetButtonScripts()

			local fileName, size = GetStoryImage(5)
			PluginInstallFrame.tutorialImage:SetTexture(fileName)
			PluginInstallFrame.tutorialImage:SetSize(size[1], size[2])

			PluginInstallFrame.SubTitle:SetText(format('|cffFFD900Private Profile (%s)|r', E.title))

			PluginInstallFrame.Desc1:SetText(format('%sCurrent Private Profile:|r %s%s|r|n%s(|rElvUI Config %s>|r Profiles %s>|r Private Tab%s)|r', '|cffFFD900', '|cff5CE1E6', E.charSettings:GetCurrentProfile(), hexElvUIBlue, hexElvUIBlue, hexElvUIBlue, hexElvUIBlue))

			PluginInstallFrame.Option1:SetEnabled(true)
			PluginInstallFrame.Option1:SetScript('OnClick', function() SetupProfileButton('ElvUI', 'Private1') end)
			PluginInstallFrame.Option1:SetText(Engine.ProfileData.ElvUI.Private1ButtonText)
			PluginInstallFrame.Option1:Show()

			PluginInstallFrame.Option2:Hide()
		end,
		[6] = function()
			--* Details
			resizeInstaller()
			resetButtonScripts()

			local fileName, size = GetStoryImage(6)
			PluginInstallFrame.tutorialImage:SetTexture(fileName)
			PluginInstallFrame.tutorialImage:SetSize(size[1], size[2])

			PluginInstallFrame.SubTitle:SetFormattedText('|cffFFD900%s|r', 'Details')

			DetailsDesc1Text()
			PluginInstallFrame.Desc2:SetText(DetailsDesc2Text())
			PluginInstallFrame.Desc3:SetText(DetailsDesc3Text())

			PluginInstallFrame.Option1:SetEnabled(E:IsAddOnEnabled('Details'))
			PluginInstallFrame.Option1:SetScript('OnClick', function() SetupProfileButton('Details', 'Profile1', DetailsDesc1Text) end)
			PluginInstallFrame.Option1:SetScript('onEnter', function() SetupOptionScripts('onEnter', Engine.ProfileData.Details.Profile1Preview) end)
			PluginInstallFrame.Option1:SetScript('onLeave', function() SetupOptionScripts('onLeave') end)
			PluginInstallFrame.Option1:SetText(Engine.ProfileData.Details.Profile1ButtonText)
			PluginInstallFrame.Option1:Show()
		end,
		[7] = function()
			--* BigWigs
			resizeInstaller()
			resetButtonScripts()

			local fileName, size = GetStoryImage(7)
			PluginInstallFrame.tutorialImage:SetTexture(fileName)
			PluginInstallFrame.tutorialImage:SetSize(size[1], size[2])

			PluginInstallFrame.SubTitle:SetText('|cffFFD900BigWigs|r')

			PluginInstallFrame.Desc1:SetText(E:IsAddOnEnabled('BigWigs') and format('%sCurrent Profile:|r %s%s|r|n%s(|rBigWigs Config %s>|r Options %s>|r Profiles%s)|r', '|cffFFD900', '|cff5CE1E6', Engine.BigWigs:GetCurrentProfileName(), hexElvUIBlue, hexElvUIBlue, hexElvUIBlue, hexElvUIBlue) or 'BigWigs is not enabled to setup.')
			PluginInstallFrame.Desc2:SetFormattedText('|cffFFD900%s|r', format('This page will setup the BigWigs profile for %s', config.Title))
			PluginInstallFrame.Desc3:SetText(BigWigsDesc3Text())

			PluginInstallFrame.Option1:SetEnabled(E:IsAddOnEnabled('BigWigs'))
			PluginInstallFrame.Option1:SetScript('OnClick', function() SetupProfileButton('BigWigs', 'Profile1') end)
			PluginInstallFrame.Option1:SetScript('onEnter', function() SetupOptionScripts('onEnter', Engine.ProfileData.BigWigs.Profile1Preview) end)
			PluginInstallFrame.Option1:SetScript('onLeave', function() SetupOptionScripts('onLeave') end)
			PluginInstallFrame.Option1:SetText(Engine.ProfileData.BigWigs.Profile1ButtonText)
			PluginInstallFrame.Option1:Show()
		end,
		[8] = function()
			--* OmniCD
			resizeInstaller()
			resetButtonScripts()

			local fileName, size = GetStoryImage(8)
			PluginInstallFrame.tutorialImage:SetTexture(fileName)
			PluginInstallFrame.tutorialImage:SetSize(size[1], size[2])

			PluginInstallFrame.SubTitle:SetText('|cffFFD900OmniCD|r')

			PluginInstallFrame.Desc1:SetText(OmniCDDesc1Text())
			PluginInstallFrame.Desc2:SetFormattedText('|cffFFD900%s|r', format('This page will setup the OmniCD profile for %s', config.Title))

			PluginInstallFrame.Option1:SetEnabled(E:IsAddOnEnabled('OmniCD'))
			PluginInstallFrame.Option1:SetScript('OnClick', function() SetupProfileButton('OmniCD', 'Profile1') PluginInstallFrame.Desc1:SetText(OmniCDDesc1Text()) end)
			PluginInstallFrame.Option1:SetScript('onEnter', function() SetupOptionScripts('onEnter', Engine.ProfileData.OmniCD.Profile1Preview) end)
			PluginInstallFrame.Option1:SetScript('onLeave', function() SetupOptionScripts('onLeave') end)
			PluginInstallFrame.Option1:SetText(Engine.ProfileData.OmniCD.Profile1ButtonText)
			PluginInstallFrame.Option1:Show()
		end,
		[9] = function()
			--* Plater
			resizeInstaller()
			resetButtonScripts()

			local fileName, size = GetStoryImage(9)
			PluginInstallFrame.tutorialImage:SetTexture(fileName)
			PluginInstallFrame.tutorialImage:SetSize(size[1], size[2])

			PluginInstallFrame.SubTitle:SetText('|cffFFD900Plater|r')

			PluginInstallFrame.Desc1:SetText(PlaterDesc1Text())
			PluginInstallFrame.Desc2:SetFormattedText('|cffFFD900%s|r', format('This page will setup the Plater profile for %s', config.Title))

			PluginInstallFrame.Option1:SetEnabled(E:IsAddOnEnabled('Plater'))
			PluginInstallFrame.Option1:SetScript('OnClick', function() SetupProfileButton('Plater', 'Profile1', PlaterDesc1Text) end)
			PluginInstallFrame.Option1:SetScript('onEnter', function() SetupOptionScripts('onEnter', Engine.ProfileData.Plater.Profile1Preview) end)
			PluginInstallFrame.Option1:SetScript('onLeave', function() SetupOptionScripts('onLeave') end)
			PluginInstallFrame.Option1:SetText('Setup Plater')
			PluginInstallFrame.Option1:Show()
		end,
		[10] = function()
			--* NameplateSCT
			resizeInstaller()
			resetButtonScripts()

			local fileName, size = GetStoryImage(10)
			PluginInstallFrame.tutorialImage:SetTexture(fileName)
			PluginInstallFrame.tutorialImage:SetSize(size[1], size[2])

			PluginInstallFrame.SubTitle:SetFormattedText('|cffFFD900%s|r', 'NameplateSCT')

			PluginInstallFrame.Desc1:SetText(format('|cffFFD900%s|r', format('This page will setup the NameplateSCT profile for %s', config.Title)))

			PluginInstallFrame.Option1:SetEnabled(E:IsAddOnEnabled('NameplateSCT'))
			PluginInstallFrame.Option1:SetScript('OnClick', function() SetupProfileButton('NameplateSCT', 'Profile1') end)
			PluginInstallFrame.Option1:SetText('Setup NameplateSCT')
			PluginInstallFrame.Option1:Show()
		end,
		[11] = function()
			--* WeakAuras
			resizeInstaller()
			resetButtonScripts()

			local fileName, size = GetStoryImage(11)
			PluginInstallFrame.tutorialImage:SetTexture(fileName)
			PluginInstallFrame.tutorialImage:SetSize(size[1], size[2])

			PluginInstallFrame.SubTitle:SetText('|cffFFD900WeakAuras|r')

			PluginInstallFrame.Desc1:SetFormattedText('|cffFFD900%s|r', 'This step will let you import my |cff4beb2cBushido|r |cffFFFF00WeakAuras|r that I use for the layout.')
			PluginInstallFrame.Desc2:SetText('|cffFFFF00Note:|r Once these are installed, you can update them with the wago app.')

			PluginInstallFrame.Option1:SetEnabled(E:IsAddOnEnabled('WeakAuras'))
			PluginInstallFrame.Option1:SetScript('OnClick', function() SetupProfileButton('WeakAuras', 'Profile1', WeakAuraButtonText) end)
			WeakAuraButtonText('Profile1')
			PluginInstallFrame.Option1:Show()

			PluginInstallFrame.Option2:SetEnabled(E:IsAddOnEnabled('WeakAuras'))
			PluginInstallFrame.Option2:SetScript('OnClick', function() SetupProfileButton('WeakAuras', 'Profile2', WeakAuraButtonText) end)
			WeakAuraButtonText('Profile2')
			PluginInstallFrame.Option2:Show()

			PluginInstallFrame.Option3:SetEnabled(E:IsAddOnEnabled('WeakAuras'))
			PluginInstallFrame.Option3:SetScript('OnClick', function() SetupProfileButton('WeakAuras', 'Profile3', WeakAuraButtonText) end)
			WeakAuraButtonText('Profile3')
			PluginInstallFrame.Option3:Show()

			PluginInstallFrame.Option4:SetEnabled(E:IsAddOnEnabled('WeakAuras'))
			PluginInstallFrame.Option4:SetScript('OnClick', function() SetupProfileButton('WeakAuras', 'Profile4', WeakAuraButtonText) end)
			WeakAuraButtonText('Profile4')
			PluginInstallFrame.Option4:Show()
		end,
		[12] = function()
			resizeInstaller()
			resetButtonScripts()

			local fileName, size = GetStoryImage(12)
			PluginInstallFrame.tutorialImage:SetTexture(fileName)
			PluginInstallFrame.tutorialImage:SetSize(size[1], size[2])

			PluginInstallFrame.SubTitle:SetFormattedText('|cffFFD900%s|r', L["Installation Complete"])

			PluginInstallFrame.Desc1:SetFormattedText('|cffFFD900%s|r', 'You have completed the installation process, please click "Finished" to reload the UI.')
			PluginInstallFrame.Desc2:SetFormattedText('|cffFFD900%s|r', 'Feel free to join our community Discord for support and feedback.')

			PluginInstallFrame.Option1:SetEnabled(true)
			PluginInstallFrame.Option1:SetScript('OnClick', function() E:StaticPopup_Show('BUSHIDO_EDITBOX', nil, nil, config.Discord) end)
			PluginInstallFrame.Option1:SetText(L["Discord"])
			PluginInstallFrame.Option1:Show()

			PluginInstallFrame.Option2:SetEnabled(true)
			PluginInstallFrame.Option2:SetScript('OnClick', function()
				JiberishUIBushidoDB.install_complete = config.Version
				E.private.ElvUI_EltreumUI.install_version = ElvUI_EltreumUI.Version
				resizeInstaller(true)
				C_UI.Reload()
			end)
			PluginInstallFrame.Option2:SetFormattedText('|cff4beb2c%s', L["Finished"])
			PluginInstallFrame.Option2:Show()
		end,
	},
	StepTitles = {
		[1] = L["Welcome"],
		[2] = 'Blizzard Layout',
		[3] = 'Global Profile',
		[4] = 'General Profile',
		[5] = 'Private Profile',
		[6] = 'Details',
		[7] = 'BigWigs',
		[8] = 'OmniCD',
		[9] = 'Plater',
		[10] = 'NameplateSCT',
		[11] = 'WeakAuras',
		[12] = L["Installation Complete"],
	},
	StepTitlesColor = config.Installer.StepTitlesColor,
	StepTitlesColorSelected = config.Installer.StepTitlesColorSelected,
	StepTitleWidth = config.Installer.StepTitleWidth,
	StepTitleButtonWidth = config.Installer.StepTitleButtonWidth,
	StepTitleTextJustification = config.Installer.StepTitleTextJustification,
}

if Engine.InstallerData.Pages[false] then Engine.InstallerData.Pages[false] = nil end
if Engine.InstallerData.StepTitles[false] then Engine.InstallerData.StepTitles[false] = nil end
