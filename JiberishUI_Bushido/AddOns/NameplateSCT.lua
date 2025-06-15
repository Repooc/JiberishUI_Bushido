local E = unpack(ElvUI)
local _, Engine = ...

Engine.NameplateSCT = {}
local nameplatesct = Engine.NameplateSCT

local function SetImportedProfile(dataProfile, force, merge)
	if force or (force and merge) then
		if merge then
			for k, v in pairs(dataProfile.global) do
				NameplateSCTDB.global[k] = v
			end
		else
			E:CopyTable(NameplateSCTDB.global, dataProfile.global)
		end
	else
		E.PopupDialogs.BUSHIDO_PROFILE_EXISTS = {
			text = 'NameplateSCT settings appear to be for all characters, be aware this alter the settings you currently have. You can choose to overwrite, which will replace your current settings, or merge the settings.',
			button1 = 'Overwrite',
			button2 = CANCEL,
			button3 = 'Merge',
			selectCallbackByIndex = true,
			OnButton1 = function(frame, data)
				SetImportedProfile(data.profileData, true, false)
			end,
			OnCancel = function() end,
			OnButton3 = function(frame, data)
				SetImportedProfile(data.profileData, true, true)
			end,
			timeout = 0,
			whileDead = 1,
			hideOnEscape = true,
			preferredIndex = 3
		}
		E:StaticPopup_Show('BUSHIDO_PROFILE_EXISTS', nil, nil, { profileKey = dataKey, profileData = dataProfile })
	end
end

function nameplatesct:SetupProfile(profile, profileID)
	if not E:IsAddOnEnabled('NameplateSCT') then Engine:Print(format('%s is |cffff3300disabled|r!', 'NameplateSCT')) return end
	if not profile then return Engine:Print('No profile table provided.') end
	if not profileID or profileID == '' then return Engine:Print('No profile id provided.') end
	if type(profile) ~= 'table' then return Engine:Print('Invalid profile table provided.') end

	SetImportedProfile(profile, false, false)
end
