local ADDON_NAME, L = ...

local AceDialog = LibStub("AceConfigDialog-3.0")
local module = AddonChatSound:NewModule("BrokerAnythingBroker", "AceEvent-3.0")

local LDB = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject(ADDON_NAME, {
	type = "launcher",
	icon = "237377",
	label = ADDON_NAME,
})
local LDBIcon = LibStub("LibDBIcon-1.0")

function module:OnInitialize()
	local defaults = { profile = { minimap = { hide = false } } }
	self.db = AddonChatSound.db:RegisterNamespace("LDB", defaults)
	LDBIcon:Register(ADDON_NAME, LDB, self.db.profile.minimap)
end

function LDB.OnClick(self, button)
	AceDialog:Open(ADDON_NAME)
end

AddonChatSound.options.args.showMinimap = {
	type = "toggle",
	name = L["Show minimap button"],
	width = "double",
	set = function(info, val)
		self.db.profile.minimap.hide = not val
		if (val) then
			LDBIcon:Show(ADDON_NAME)
		else
			LDBIcon:Hide(ADDON_NAME)
		end
	end,
	get = function(info) return not module.db.profile.minimap.hide end
}