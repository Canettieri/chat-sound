local MAJOR, MINOR = "AceGUI-3.0-Eliote-AutoCompleteEditBox", 2
local lib, oldminor = LibStub:NewLibrary(MAJOR, MINOR)
if not lib then
	return
end

local AceGUI = LibStub("AceGUI-3.0")

local function ShowButton(self)
	if not self.disablebutton then
		self.button:Show()
		self.editbox:SetTextInsets(0, 20, 3, 3)
	end
end

local function HideButton(self)
	self.button:Hide()
	self.editbox:SetTextInsets(0, 0, 3, 3)
end

--[[-----------------------------------------------------------------------------
Scripts
-------------------------------------------------------------------------------]]
local function Control_OnEnter(frame)
	frame.obj:Fire("OnEnter")
end

local function Control_OnLeave(frame)
	frame.obj:Fire("OnLeave")
end

local function Frame_OnShowFocus(frame)
	frame.obj.editbox:SetFocus()
	frame:SetScript("OnShow", nil)
end

local function EditBox_OnEscapePressed(frame)
	if not AutoCompleteEditBox_OnEscapePressed(frame) then
		AceGUI:ClearFocus()
	end
end

local function EditBox_OnEnterPressed(frame)
	if not AutoCompleteEditBox_OnEnterPressed(frame) then
		local self = frame.obj
		local value = frame:GetText()
		local cancel = self:Fire("OnEnterPressed", value)
		if not cancel then
			PlaySound(856) -- SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON
			HideButton(self)
		end
	end
end

local function EditBox_OnTextChanged(frame, userInput)
	AutoCompleteEditBox_OnTextChanged(frame, userInput);
	local self = frame.obj
	local value = frame:GetText()
	if tostring(value) ~= tostring(self.lasttext) then
		self:Fire("OnTextChanged", value)
		self.lasttext = value
		ShowButton(self)
	end
end

local function EditBox_OnFocusGained(frame)
	AceGUI:SetFocus(frame.obj)
end

local function EditBox_OnFocusLost(frame)
	AutoCompleteEditBox_OnEditFocusLost(frame)
end

local function EditBox_OnTabPressed(frame)
	if (not AutoCompleteEditBox_OnTabPressed(frame)) then
		--frame:HandleTabbing(frame, ???);
	end
end

local function Button_OnClick(frame)
	local editbox = frame.obj.editbox
	editbox:ClearFocus()
	EditBox_OnEnterPressed(editbox)
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
	["OnAcquire"] = function(self)
		-- height is controlled by SetLabel
		self:SetWidth(200)
		self:SetDisabled(false)
		self:SetLabel()
		self:SetText()
		self:DisableButton(false)
		self:SetMaxLetters(0)

		AutoCompleteEditBox_SetAutoCompleteSource(
				self.editbox,
				GetAutoCompleteResults,
				self.params.include,
				self.params.exclude
		)
		self.editbox.addHighlightedText = true
	end,

	["OnRelease"] = function(self)
		AutoCompleteEditBox_SetAutoCompleteSource(self.editbox, nil)
		self.editbox.addHighlightedText = nil
		self:ClearFocus()
	end,

	["SetDisabled"] = function(self, disabled)
		self.disabled = disabled
		if disabled then
			self.editbox:EnableMouse(false)
			self.editbox:ClearFocus()
			self.editbox:SetTextColor(0.5, 0.5, 0.5)
			self.label:SetTextColor(0.5, 0.5, 0.5)
		else
			self.editbox:EnableMouse(true)
			self.editbox:SetTextColor(1, 1, 1)
			self.label:SetTextColor(1, .82, 0)
		end
	end,

	["SetText"] = function(self, text)
		self.lasttext = text or ""
		self.editbox:SetText(text or "")
		self.editbox:SetCursorPosition(0)
		HideButton(self)
	end,

	["GetText"] = function(self, text)
		return self.editbox:GetText()
	end,

	["SetLabel"] = function(self, text)
		if text and text ~= "" then
			self.label:SetText(text)
			self.label:Show()
			self.editbox:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 7, -18)
			self:SetHeight(44)
			self.alignoffset = 30
		else
			self.label:SetText("")
			self.label:Hide()
			self.editbox:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 7, 0)
			self:SetHeight(26)
			self.alignoffset = 12
		end
	end,

	["DisableButton"] = function(self, disabled)
		self.disablebutton = disabled
		if disabled then
			HideButton(self)
		end
	end,

	["SetMaxLetters"] = function(self, num)
		self.editbox:SetMaxLetters(num or 0)
	end,

	["ClearFocus"] = function(self)
		self.editbox:ClearFocus()
		self.frame:SetScript("OnShow", nil)
	end,

	["SetFocus"] = function(self)
		self.editbox:SetFocus()
		if not self.frame:IsShown() then
			self.frame:SetScript("OnShow", Frame_OnShowFocus)
		end
	end,

	["HighlightText"] = function(self, from, to)
		self.editbox:HighlightText(from, to)
	end
}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]
local function Constructor(type, params)
	local num = AceGUI:GetNextWidgetNum(type)
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:Hide()

	local editbox = CreateFrame("EditBox", type .. "EditBox" .. num, frame, "InputBoxTemplate,AutoCompleteEditBoxTemplate")
	editbox:SetAutoFocus(false)
	editbox:SetFontObject(ChatFontNormal)
	editbox:SetScript("OnEnter", Control_OnEnter)
	editbox:SetScript("OnLeave", Control_OnLeave)
	editbox:SetScript("OnEscapePressed", EditBox_OnEscapePressed)
	editbox:SetScript("OnEnterPressed", EditBox_OnEnterPressed)
	editbox:SetScript("OnTextChanged", EditBox_OnTextChanged)
	editbox:SetScript("OnEditFocusGained", EditBox_OnFocusGained)
	editbox:SetScript("OnEditFocusLost", EditBox_OnFocusLost)
	editbox:SetScript("OnTabPressed", EditBox_OnTabPressed)
	editbox:SetTextInsets(0, 0, 3, 3)
	editbox:SetMaxLetters(256)
	editbox:SetPoint("BOTTOMLEFT", 6, 0)
	editbox:SetPoint("BOTTOMRIGHT")
	editbox:SetHeight(19)

	local label = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	label:SetPoint("TOPLEFT", 0, -2)
	label:SetPoint("TOPRIGHT", 0, -2)
	label:SetJustifyH("LEFT")
	label:SetHeight(18)

	local button = CreateFrame("Button", nil, editbox, "UIPanelButtonTemplate")
	button:SetWidth(40)
	button:SetHeight(20)
	button:SetPoint("RIGHT", -2, 0)
	button:SetText(OKAY)
	button:SetScript("OnClick", Button_OnClick)
	button:Hide()

	local widget = {
		alignoffset = 30,
		editbox = editbox,
		label = label,
		button = button,
		frame = frame,
		type = type,
		params = params,
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end
	editbox.obj, button.obj = widget, widget

	return AceGUI:RegisterAsWidget(widget)
end

function lib:Register(typename, params_taborin, params_nilorex)
	local params
	if type(params_taborin) == 'table' and type(params_nilorex) == 'nil' then
		assert(type(params_taborin.include) == 'number', "autocomplete table must have numerical '.include' field")
		assert(type(params_taborin.exclude) == 'number', "autocomplete table must have numerical '.exclude' field")
		params = params_taborin
	elseif type(params_taborin) == 'number' and type(params_nilorex) == 'number' then
		params = { include = params_taborin, exclude = params_nilorex }
	end
	assert(params, "usage:  Register('typename', autocomplete_params_table_or_include [,exclude])")

	-- Would have been nice to do a typename->params lookup instead of a closure,
	-- but AceGUI:Create does not pass anything to the constructors (such as the type).
	local type = "EditBox" .. typename
	AceGUI:RegisterWidgetType(type, function()
		return Constructor(type, params)
	end, MINOR)
end
