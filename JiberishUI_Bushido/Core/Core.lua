local E, L, V, P, G = unpack(ElvUI)
local PI = E.PluginInstaller
local EP = E.Libs.EP
local D = E.Distributor
local AddOnName, Engine = ...

function Engine:Print(...)
	(E.db and _G[E.db.general.messageRedirect] or _G.DEFAULT_CHAT_FRAME):AddMessage(strjoin('', Engine.Config.Title, ':|r ', ...))
end

E.PopupDialogs.BUSHIDO_EDITBOX = {
	text = Engine.Config.Title,
	button1 = OKAY,
	hasEditBox = 1,
	OnShow = function(self, data)
		self.editBox:SetAutoFocus(false)
		self.editBox.width = self.editBox:GetWidth()
		self.editBox:Width(280)
		self.editBox:AddHistoryLine('text')
		self.editBox.temptxt = data
		self.editBox:SetText(data)
		self.editBox:HighlightText()
		self.editBox:SetJustifyH('CENTER')
	end,
	OnHide = function(self)
		self.editBox:Width(self.editBox.width or 50)
		self.editBox.width = nil
		self.temptxt = nil
	end,
	EditBoxOnEnterPressed = function(self)
		self:GetParent():Hide()
	end,
	EditBoxOnEscapePressed = function(self)
		self:GetParent():Hide()
	end,
	EditBoxOnTextChanged = function(self)
		if self:GetText() ~= self.temptxt then
			self:SetText(self.temptxt)
		end
		self:HighlightText()
		self:ClearFocus()
	end,
	OnAccept = E.noop,
	whileDead = 1,
	preferredIndex = 3,
	hideOnEscape = 1,
}

local function GetOptions()
	for _, func in pairs(Engine.Options) do
		func()
	end
end

local disabled = {}
local function AllAddOnsEnabled()
	wipe(disabled)
	for addon in pairs(Engine.ProfileData) do
		if addon ~= 'Blizzard' and addon ~= 'ElvUI' then
			if not E:IsAddOnEnabled(addon) then
				disabled[#disabled + 1] = addon
			end
		end
	end
	if not E:IsAddOnEnabled('JiberishMedia') then
		disabled[#disabled + 1] = 'JiberishMedia'
	end
	if not E:IsAddOnEnabled('ElvUI_mMediaTag') then
		disabled[#disabled + 1] = 'ElvUI_mMediaTag'
	end
	if #disabled > 0 then return false end
	return true
end

local function Initialize()
	if E.Retail then
		E:AddLib('EditModeOverride', 'LibEditModeOverride-1.0-JIBERISH')
	end
	local enabled = AllAddOnsEnabled()
	if not JiberishUIBushidoDB.install_complete and enabled then
		PI:Queue(Engine.InstallerData)
	elseif not JiberishUIBushidoDB.install_complete and not enabled then
		Engine:Print('Not all addons are enabled for the installer to automatically run. You may still use the setup buttons in ElvUI options to configure the profiles for the addons that are enabled.')
		Engine:Print('The following addons are disabled:')
		Engine:Print(table.concat(disabled, ', '))
	end

	EP:RegisterPlugin(AddOnName, GetOptions)
end

EP:HookInitialize(AddOnName, Initialize)

hooksecurefunc(PI, 'RunInstall', function()
	if JiberishUIBushidoDB.install_complete then return end
	if not E:IsAddOnEnabled('ElvUI_EltreumUI') or E.private.ElvUI_EltreumUI.install_version then return end

	if _G.PluginInstallFrame.Title:GetText() == ElvUI_EltreumUI.Name then
		PI:CloseInstall()
		Engine:Print(format('As part of the installation of Bushido profile, %s installer has been automatically skipped.', ElvUI_EltreumUI.Name))
	end
end)
