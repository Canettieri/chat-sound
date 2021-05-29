local ADDON_NAME, L = ...

local AceDialog = LibStub("AceConfigDialog-3.0")
local module = ChatSoundCustomizer:NewModule("LDBModule", "AceEvent-3.0")
module.priority = -1

local icons = {
	[false] = [[Interface\AddOns\Chat_Sound_Customizer\Icons\Inv_misc_horn_04]], -- "237377"
	[true] = "135975"
}
local isTemporarilyMuted = false

local LDB = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject(ADDON_NAME, {
	type = "launcher",
	icon = icons[false],
	label = ChatSoundCustomizer.title,
})
local LDBIcon = LibStub("LibDBIcon-1.0")

function module:OnInitialize()
	local defaults = { profile = { minimap = { hide = false } } }
	self.db = ChatSoundCustomizer.db:RegisterNamespace("LDB", defaults)
	LDBIcon:Register(ADDON_NAME, LDB, self.db.profile.minimap)
end

function module:ShouldIgnoreEvent()
	return isTemporarilyMuted or self.db.profile.mute
end

function module:SetMute(mute)
	isTemporarilyMuted = mute
	LDB.icon = icons[mute]
end

local IS_MAINLINE = WOW_PROJECT_MAINLINE == WOW_PROJECT_ID
local ICON_MOUSE_LEFT = IS_MAINLINE and "|A:newplayertutorial-icon-mouse-leftbutton:0:0|a " or ""
local ICON_MOUSE_RIGHT = IS_MAINLINE and "|A:newplayertutorial-icon-mouse-rightbutton:0:0|a " or ""
function LDB.OnTooltipShow(ttp)
	ttp:AddLine("|cFFFFFFFF" .. ChatSoundCustomizer.title)
	ttp:AddLine(" ")
	ttp:AddLine(ICON_MOUSE_LEFT .. L("${button} to show the Config UI", { button = "|cFFFFF244" .. L["Left-click"] .. "|r" }))
	if (isTemporarilyMuted) then
		ttp:AddLine(ICON_MOUSE_RIGHT .. L("${button} to unmute CSC", { button = "|cFFFFF244" .. L["Right-click"] .. "|r" }))
	else
		ttp:AddLine(ICON_MOUSE_RIGHT .. L("${button} to temporarily mute CSC", { button = "|cFFFFF244" .. L["Right-click"] .. "|r" }))
	end
end

function LDB.OnClick(self, button)
	if (button == "LeftButton") then
		AceDialog:Open(ADDON_NAME)
	elseif button == "RightButton" then
		module:SetMute(not isTemporarilyMuted)
	end
end

ChatSoundCustomizer.options.args.temporarilyMute = {
	type = "toggle",
	name = L["Temporarily Mute"],
	desc = L["Temporarily mute the addon, it will go back to normal after reload"],
	set = function(info, val) module:SetMute(val) end,
	get = function(info) return isTemporarilyMuted end
}

ChatSoundCustomizer.options.args.showMinimap = {
	type = "toggle",
	name = L["Show minimap button"],
	width = "double",
	set = function(info, val)
		module.db.profile.minimap.hide = not val
		if (val) then
			LDBIcon:Show(ADDON_NAME)
		else
			LDBIcon:Hide(ADDON_NAME)
		end
	end,
	get = function(info) return not module.db.profile.minimap.hide end
}