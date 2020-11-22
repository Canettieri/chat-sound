local AceGUI = LibStub("AceGUI-3.0")
local LSM = LibStub("LibSharedMedia-3.0")

--[[ Static data ]]--
local BUTTON_HEIGHT = 18
local MAX_ITEMS = 25

local buttonsPool = {}

local backdrop = {
	bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	edgeSize = 32,
	tileSize = 32,
	tile = true,
	insets = { left = 10, right = 11, top = 11, bottom = 10 },
}

local widgetType = "Eliote-LSM-Dropdown-Pullout"
local defaultWidth = 200
local minHeight = 32

-- exported, AceGUI callback
local function OnAcquire(self)
	self.frame:SetParent(UIParent)
end

-- exported, AceGUI callback
local function OnRelease(self)
	self:Clear()
	self.frame:ClearAllPoints()
	self.frame:Hide()
end

local function GetButton(self, index)
	if not buttonsPool[index] then
		buttonsPool[index] = CreateFrame("Button", nil, self.itemFrame)
	end
	return buttonsPool[index]
end

local function OnClick(this, button)
	local self = this.obj
	self:Fire("OnValueChanged", this:GetID())
	self:Close()
end

local function OnSpeakerClick(this, button)
	local self = this.button
	local sound = self.obj.list[self:GetID()]
	PlaySoundFile(LSM:Fetch("sound", sound), "Master")
end

local function CreateItem(self, index, dataOffset)
	local button = GetButton(self, index)

	local id = index + dataOffset
	local itemName = self.list[id]

	button:SetParent(self.itemFrame)
	button:SetID(id)
	button.obj = self

	button:SetHeight(BUTTON_HEIGHT)
	button:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
	button:SetScript("OnClick", OnClick)

	local check = button.check or button:CreateTexture("OVERLAY")
	check:SetWidth(16)
	check:SetHeight(16)
	check:SetPoint("LEFT", button, "LEFT", 1, -1)
	check:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
	check:Hide()
	button.check = check
	if self.userdata.obj.value == id then check:Show() end

	local playButton = button.playButton or CreateFrame("Button", nil, button)
	playButton:SetWidth(16)
	playButton:SetHeight(16)
	playButton:SetPoint("RIGHT", button, "RIGHT", -1, 0)
	playButton.button = button
	playButton:SetScript("OnClick", OnSpeakerClick)
	button.playButton = playButton

	local playButtonIconOff = button.playButtonIconOff or playButton:CreateTexture(nil, "BACKGROUND")
	playButtonIconOff:SetTexture("Interface\\Common\\VoiceChat-Speaker")
	playButtonIconOff:SetAllPoints(playButton)
	button.playButtonIconOff = playButtonIconOff

	local playButtonIconOn = button.playButtonIconOn or playButton:CreateTexture(nil, "HIGHLIGHT")
	playButtonIconOn:SetTexture("Interface\\Common\\VoiceChat-On")
	playButtonIconOn:SetAllPoints(playButton)
	button.playButtonIconOn = playButtonIconOn

	local text = button.text or button:CreateFontString(nil, "OVERLAY", "GameFontWhite")
	text:SetPoint("TOPLEFT", check, "TOPRIGHT", 1, 0)
	text:SetPoint("BOTTOMRIGHT", playButton, "BOTTOMLEFT", -2, 0)
	text:SetJustifyH("LEFT")
	text:SetText(itemName)
	button.text = text

	if (index == 1) then
		button:SetPoint("TOP", self.itemFrame, "TOP")
		button:SetPoint("LEFT", self.itemFrame, "LEFT", 4)
		button:SetPoint("RIGHT", self.itemFrame, "RIGHT", 4)
		button:SetHeight(BUTTON_HEIGHT)
	else
		local above = GetButton(self, index - 1)
		button:SetPoint("TOP", above, "BOTTOM")
		button:SetPoint("LEFT", self.itemFrame, "LEFT", 4)
		button:SetPoint("RIGHT", self.itemFrame, "RIGHT", 4)
		button:SetHeight(BUTTON_HEIGHT)
	end

	button:Show()

	return button
end

local function GetMaxItems(list)
	return min(MAX_ITEMS, #list)
end

local function SetData(self, offset)
	for i = 1, GetMaxItems(self.list) do
		CreateItem(self, i, offset)
	end
end

local function GetIndexFromOffset(offset)
	return floor((offset / BUTTON_HEIGHT) + 0.5)
end

-- exported
local function Open(self, point, relFrame, relPoint, x, y)
	local list = self.list
	local frame = self.frame

	local maxItems = GetMaxItems(list)

	SetData(self, FauxScrollFrame_GetOffset(self.scrollFrame))

	frame:SetPoint(point, relFrame, relPoint, x, y)
	frame:SetHeight(max(minHeight, GetButton(self, 1):GetHeight() * maxItems + 14 + 12))
	frame:SetFrameStrata("TOOLTIP")
	frame:Show()

	FauxScrollFrame_Update(self.scrollFrame, #list, maxItems, BUTTON_HEIGHT)

	self:Fire("OnOpen")
end

-- exported
local function Close(self)
	self.frame:Hide()
	self:Fire("OnClose")
end

-- exported
local function Clear(self)
	for _, button in pairs(buttonsPool) do
		button:SetParent(nil)
		button:Hide()
	end
end

-- exported
local function SetHideOnLeave(self, val)
	self.hideOnLeave = val
end

local function OnVerticalScroll(self, offset)
	local offsetIndex = GetIndexFromOffset(offset)
	SetData(self.obj, offsetIndex)
	self.offset = offsetIndex
end

local function Constructor()
	local count = AceGUI:GetNextWidgetNum(widgetType)
	local frame = CreateFrame("Frame", nil, UIParent, BackdropTemplateMixin and "BackdropTemplate")
	local self = {}
	self.count = count
	self.type = widgetType
	self.frame = frame
	frame.obj = self

	self.OnAcquire = OnAcquire
	self.OnRelease = OnRelease
	self.Open = Open
	self.Close = Close
	self.Clear = Clear
	self.SetHideOnLeave = SetHideOnLeave

	self.items = {}

	frame:SetBackdrop(backdrop)
	frame:SetBackdropColor(0, 0, 0, 0.95)
	frame:SetFrameStrata("FULLSCREEN_DIALOG")
	frame:SetClampedToScreen(true)
	frame:SetWidth(defaultWidth)
	frame:SetHeight(minHeight)

	local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "FauxScrollFrameTemplate")
	self.scrollFrame = scrollFrame
	scrollFrame.obj = self
	scrollFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 6, -14)
	scrollFrame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -36, 12)
	scrollFrame:EnableMouseWheel(true)
	scrollFrame:SetScript("OnVerticalScroll", OnVerticalScroll)
	scrollFrame:SetToplevel(true)
	scrollFrame:SetFrameStrata("FULLSCREEN_DIALOG")

	local itemFrame = CreateFrame("Frame", nil, frame)
	self.itemFrame = itemFrame
	itemFrame.obj = self
	itemFrame:SetPoint("TOPLEFT", scrollFrame, "TOPLEFT", 12, 0)
	itemFrame:SetPoint("BOTTOMRIGHT", scrollFrame, "BOTTOMRIGHT", 0, 0)
	itemFrame:SetToplevel(true)
	itemFrame:SetFrameStrata("FULLSCREEN_DIALOG")

	scrollFrame:Show()
	itemFrame:Show()

	AceGUI:RegisterAsWidget(self)
	return self
end

AceGUI:RegisterWidgetType("Eliote-LSM-Dropdown-Pullout", Constructor, 1)