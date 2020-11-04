local MAJOR, MINOR = "AceGUI-3.0-Eliote-AutoCompleteEditBox", 1
local lib, oldminor = LibStub:NewLibrary(MAJOR, MINOR)
if not lib then return end

local AceGUI = LibStub("AceGUI-3.0")

local originalEvents = {}

local function OnEnterPressed(editbox)
	if not AutoCompleteEditBox_OnEnterPressed(editbox) then
		return originalEvents.OnEnterPressed(editbox)
	end
end

local function OnTextChanged(editbox, changedByUser)
	if not AutoCompleteEditBox_OnTextChanged(editbox, changedByUser) then
		return originalEvents.OnTextChanged(editbox)
	end
end

local function OnArrowPressed(editbox, key)
	if not AutoCompleteEditBox_OnArrowPressed(editbox, key) then
		return originalEvents.OnArrowPressed(editbox, key)
	end
end

local function OnTabPressed(editbox)
	if not AutoCompleteEditBox_OnTabPressed(editbox) then
		return originalEvents.OnTabPressed(editbox)
	end
end

local function OnEscapePressed(editbox)
	if not AutoCompleteEditBox_OnEscapePressed(editbox) then
		return originalEvents.OnEscapePressed(editbox)
	end
end

local function OnEditFocusLost(editbox)
	AutoComplete_HideIfAttachedTo(editbox)
	EditBox_ClearHighlight(editbox)
end


local function Constructor(params)
	local widget = AceGUI:Create("EditBox")

	originalEvents.OnEnterPressed = widget.editbox:GetScript("OnEnterPressed")
	widget.editbox:SetScript("OnEnterPressed", OnEnterPressed)

	originalEvents.OnTextChanged = widget.editbox:GetScript("OnTextChanged")
	widget.editbox:SetScript("OnTextChanged", OnTextChanged)

	originalEvents.OnArrowPressed = widget.editbox:GetScript("OnArrowPressed")
	widget.editbox:SetScript("OnArrowPressed", OnArrowPressed)

	originalEvents.OnTabPressed = widget.editbox:GetScript("OnTabPressed")
	widget.editbox:SetScript("OnTabPressed", OnTabPressed)

	originalEvents.OnEscapePressed = widget.editbox:GetScript("OnEscapePressed")
	widget.editbox:SetScript("OnEscapePressed", OnEscapePressed)

	widget.editbox:SetScript("OnChar", AutoCompleteEditBox_OnChar)
	widget.editbox:SetScript("OnEditFocusLost", OnEditFocusLost)

	widget.OnAcquire = function(self)
		self.editbox.addHighlightedText = true
		AutoCompleteEditBox_SetAutoCompleteSource(
				self.editbox,
				GetAutoCompleteResults,
				params.include,
				params.exclude
		)
	end

	widget.OnRelease = function(self)
		AutoCompleteEditBox_SetAutoCompleteSource(self.editbox, nil)
		widget.editbox.addHighlightedText = nil
	end

	return widget
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
	AceGUI:RegisterWidgetType("EditBox" .. typename, function() return Constructor(params) end, MINOR)
end
