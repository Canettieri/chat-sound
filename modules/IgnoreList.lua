local ADDON_NAME, L = ...

local module = ChatSoundCustomizer:NewModule("IgnoreListModule", "AceEvent-3.0")

local Completing = LibStub("AceGUI-3.0-Eliote-AutoCompleteEditBox")
Completing:Register("CSCOnlinePlayersAutoComplete", AUTOCOMPLETE_LIST_TEMPLATES.ONLINE)

function module:OnInitialize()
	local defaults = { profile = { ignoredNames = {} } }
	self.db = ChatSoundCustomizer.db:RegisterNamespace("IgnoreList", defaults)
end

function module:ShouldIgnoreEvent(event, _, playerName)
	return module.db.profile.ignoredNames[playerName]
			or module.db.profile.ignoredNames[(string.match(playerName, "(.*)-.*"))]
end

ChatSoundCustomizer.options.args.ignoreList = {
	type = "group",
	name = L["Ignore List"],
	args = {
		add = {
			name = L["Add to ignore list"],
			type = "input",
			order = 1,
			width = "full",
			dialogControl = "EditBoxCSCOnlinePlayersAutoComplete",
			get = false,
			set = function(info, value)
				if not value or value == "" then
					local name = GetUnitName("Target", true)
					value = name
				end

				if not value or value == "" then return end

				module.db.profile.ignoredNames[value] = value
			end
		},
		remove = {
			name = L["Remove from ignore list"],
			type = "select",
			order = 2,
			width = "full",
			values = function() return module.db.profile.ignoredNames end,
			get = false,
			set = function(info, value) module.db.profile.ignoredNames[value] = nil end
		},
	}
}