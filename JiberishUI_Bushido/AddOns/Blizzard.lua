local AddOnName, Engine = ...
local E = unpack(ElvUI)

Engine.Blizzard = {}

local blizzard = Engine.Blizzard
local CH = E.Chat

--* Ripped from ElvUI function with some modifications
function blizzard:SetupChat()
	local chats = _G.CHAT_FRAMES
	FCF_ResetChatWindows()

	-- force initialize the tts chat (it doesn't get shown unless you use it)
	local voiceChat = _G[chats[3]]
	FCF_ResetChatWindow(voiceChat, VOICE)
	FCF_DockFrame(voiceChat, 3)

	for id, name in next, chats do
		local frame = _G[name]

		if E.private.chat.enable then
			CH:FCFTab_UpdateColors(CH:GetTab(frame))
		end

		if id == 1 then
			frame:ClearAllPoints()
			frame:Point('BOTTOMLEFT', _G.LeftChatToggleButton, 'TOPLEFT', 1, 3)
		elseif id == 2 then
			FCF_SetWindowName(frame, GUILD_EVENT_LOG)
		elseif id == 3 then
			VoiceTranscriptionFrame_UpdateVisibility(frame)
			VoiceTranscriptionFrame_UpdateVoiceTab(frame)
			VoiceTranscriptionFrame_UpdateEditBox(frame)
		end

		FCF_SetChatWindowFontSize(nil, frame, 12)
		FCF_SavePositionAndDimensions(frame)
		FCF_StopDragging(frame)
	end

	-- keys taken from `ChatTypeGroup` but doesnt add: 'OPENING', 'TRADESKILLS', 'PET_INFO', 'COMBAT_MISC_INFO', 'COMMUNITIES_CHANNEL', 'PET_BATTLE_COMBAT_LOG', 'PET_BATTLE_INFO', 'TARGETICONS'
	local chatGroup = { 'SYSTEM', 'CHANNEL', 'SAY', 'EMOTE', 'YELL', 'WHISPER', 'PARTY', 'PARTY_LEADER', 'RAID', 'RAID_LEADER', 'RAID_WARNING', 'INSTANCE_CHAT', 'INSTANCE_CHAT_LEADER', 'GUILD', 'OFFICER', 'MONSTER_SAY', 'MONSTER_YELL', 'MONSTER_EMOTE', 'MONSTER_WHISPER', 'MONSTER_BOSS_EMOTE', 'MONSTER_BOSS_WHISPER', 'ERRORS', 'AFK', 'DND', 'IGNORED', 'BG_HORDE', 'BG_ALLIANCE', 'BG_NEUTRAL', 'ACHIEVEMENT', 'GUILD_ACHIEVEMENT', 'BN_WHISPER', 'BN_INLINE_TOAST_ALERT' }
	ChatFrame_RemoveAllMessageGroups(_G.ChatFrame1)
	for _, v in next, chatGroup do
		ChatFrame_AddMessageGroup(_G.ChatFrame1, v)
	end

	ChatFrame_AddChannel(_G.ChatFrame1, GENERAL)
	ChatFrame_AddChannel(_G.ChatFrame1, TRADE)

	-- set the chat groups names in class color to enabled for all chat groups which players names appear
	chatGroup = { 'SAY', 'EMOTE', 'YELL', 'WHISPER', 'PARTY', 'PARTY_LEADER', 'RAID', 'RAID_LEADER', 'RAID_WARNING', 'INSTANCE_CHAT', 'INSTANCE_CHAT_LEADER', 'GUILD', 'OFFICER', 'ACHIEVEMENT', 'GUILD_ACHIEVEMENT', 'COMMUNITIES_CHANNEL' }
	for i = 1, _G.MAX_WOW_CHAT_CHANNELS do
		tinsert(chatGroup, 'CHANNEL'..i)
	end
	for _, v in next, chatGroup do
		ToggleChatColorNamesByClassGroup(true, v)
	end

	-- Adjust Chat Colors
	ChangeChatColor('CHANNEL1', 0.76, 0.90, 0.91) -- General
	ChangeChatColor('CHANNEL2', 0.91, 0.62, 0.47) -- Trade
	ChangeChatColor('CHANNEL3', 0.91, 0.89, 0.47) -- Local Defense

	if E.private.chat.enable then
		CH:PositionChats()
	end

	if E.db.RightChatPanelFaded then
		_G.RightChatToggleButton:Click()
	end

	if E.db.LeftChatPanelFaded then
		_G.LeftChatToggleButton:Click()
	end
end

local function SetImportedProfile(dataKey, dataProfile, force, callback)
	local EMO = E.Libs.EditModeOverride
	if not EMO:DoesLayoutExist(dataKey) or force then
		if EMO:DoesLayoutExist(dataKey) and force then
			EMO:DeleteLayout(dataKey)
			EMO:SaveOnly()
		end
		EMO:LoadLayouts()

		local layoutType = Enum.EditModeLayoutType.Account
		local layoutName = dataKey

		EMO:ImportLayout(layoutType, layoutName, dataProfile)
		EMO:SaveOnly()
		if callback then callback() end
	else
		E.PopupDialogs.BUSHIDO_PROFILE_EXISTS = {
			text = 'The profile you tried to import already exists. Choose a new name or accept to overwrite the existing profile.',
			button1 = ACCEPT,
			button2 = CANCEL,
			hasEditBox = 1,
			editBoxWidth = 350,
			maxLetters = 127,
			OnAccept = function(frame, data)
				local newProfileName = frame.editBox:GetText()
				SetImportedProfile(frame.editBox:GetText(), data.profileData, newProfileName == data.profileKey, callback)
			end,
			EditBoxOnTextChanged = function(frame)
				frame:GetParent().button1:SetEnabled(frame:GetText() ~= '')
			end,
			OnShow = function(frame, data)
				frame.editBox:SetText(data.profileKey)
				frame.editBox:SetFocus()
			end,
			timeout = 0,
			whileDead = 1,
			hideOnEscape = true,
			preferredIndex = 3
		}
		E:StaticPopup_Show('BUSHIDO_PROFILE_EXISTS', nil, nil, { profileKey = dataKey, profileData = dataProfile })
	end
end

function blizzard:SetupProfile(profile, profileID, callback)
	if not E.Retail then return Engine:Print('Blizzard profiles are only available on Retail.') end
	if not profile then return Engine:Print('No profile string provided.') end

	local profileName = Engine.ProfileData.Blizzard[profileID..'Name']
	if not profileName or profileName == '' then return Engine:Print('No profile name provided in the config for this profile.') end

	SetImportedProfile(profileName, profile, false, callback)
end
