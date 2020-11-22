local AceGUI = LibStub("AceGUI-3.0")
local LSM = LibStub("LibSharedMedia-3.0")

local function OnPulloutOpen(this)
	local self = this.userdata.obj
	self.open = true
end

local function OnPulloutClose(this)
	local self = this.userdata.obj
	self.open = nil
end

local function SetValue(this, _, value)
	local self = this.userdata.obj
	self:SetText(self.list[value] or "")
	self.value = value
	self:Fire("OnValueChanged", value)
end

local function OnAcquire(self)
	local pullout = AceGUI:Create("Eliote-LSM-Dropdown-Pullout")
	self.pullout = pullout
	pullout.userdata.obj = self
	pullout:SetCallback("OnClose", OnPulloutClose)
	pullout:SetCallback("OnOpen", OnPulloutOpen)
	pullout:SetCallback("OnValueChanged", SetValue)
	self.pullout.frame:SetFrameLevel(self.frame:GetFrameLevel() + 1)

	self:SetHeight(44)
	self:SetWidth(200)
	self:SetLabel()
	self:SetPulloutWidth(nil)
	self.list = {}
	self.pullout.list = self.list
end

local function OnSpeakerClick(this, button)
	local self = this.obj
	local sound = self.list[self.value]
	PlaySoundFile(tostring(LSM:Fetch("sound", sound)), "Master")
end

local function SetList(self, list, order, itemType)
	self.list = list or {}
	self.pullout:Clear()
	self.pullout.list = self.list
	self.hasClose = nil
end

local function Constructor()
	local self = AceGUI:Create("Dropdown")

	self.SetList = SetList
	self.OnAcquire = OnAcquire

	local playButton = CreateFrame("Button", nil, self.dropdown)
	playButton:SetWidth(16)
	playButton:SetHeight(16)
	playButton:SetPoint("TOPLEFT", self.dropdown, "TOPLEFT", 25, -6)
	playButton.obj = self
	playButton:SetScript("OnClick", OnSpeakerClick)
	self.playButton = playButton

	local playButtonIconOff = playButton:CreateTexture(nil, "BACKGROUND")
	playButtonIconOff:SetTexture("Interface\\Common\\VoiceChat-Speaker")
	playButtonIconOff:SetAllPoints(playButton)
	self.playButtonIconOff = playButtonIconOff

	local playButtonIconOn = playButton:CreateTexture(nil, "HIGHLIGHT")
	playButtonIconOn:SetTexture("Interface\\Common\\VoiceChat-On")
	playButtonIconOn:SetAllPoints(playButton)
	self.playButtonIconOn = playButtonIconOn

	return self
end

AceGUI:RegisterWidgetType("Eliote-LSMSound", Constructor, 1)