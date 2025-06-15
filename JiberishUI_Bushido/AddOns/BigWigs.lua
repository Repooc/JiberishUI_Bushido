local AddOnName, Engine = ...
local E = unpack(ElvUI)

Engine.BigWigs = {}

local bigwigs = Engine.BigWigs
local hexElvUIBlue = '|cff1785d1'

function bigwigs:GetCurrentProfileName()
	return BigWigs3DB and BigWigs3DB.profileKeys[E.mynameRealm] or UNKNOWN
end

local function BigWigsCallback(completed)
	if completed then
		Engine:Print('BigWigs profile import process has been completed.')
		PlaySound(888)

		local PI = E.PluginInstaller
		if _G.PluginInstallFrame:IsShown() and _G.PluginInstallFrame.Title:GetText() == Engine.InstallerData.Title and _G.PluginInstallFrame.CurrentPage == 7 then
			_G.PluginInstallFrame.Desc1:SetText(format('%sCurrent Profile:|r %s%s|r|n%s(|rBigWigs Config %s>|r Options %s>|r Profiles%s)|r', '|cffFFD900', '|cff5CE1E6', bigwigs:GetCurrentProfileName(), hexElvUIBlue, hexElvUIBlue, hexElvUIBlue, hexElvUIBlue))
		end

		return
	end
	Engine:Print('BigWigs profile import process has been cancelled. No profile has been imported.')
end

function bigwigs:SetupProfile(profile, profileID)
	if not E:IsAddOnEnabled('BigWigs') then Engine:Print(format('%s is |cffff3300disabled|r!', 'BigWigs')) return end
	if not profile then return Engine:Print('No profile string provided.') end

	local profileName = Engine.ProfileData.BigWigs[profileID..'Name']
	if not profileName or profileName == '' then return Engine:Print('No profile name provided in the config for this profile.') end

	BigWigsAPI.RegisterProfile(AddOnName, profile, profileName, BigWigsCallback)
end
