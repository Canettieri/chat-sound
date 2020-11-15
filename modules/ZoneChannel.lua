local ADDON_NAME, L = ...

local module = ChatSoundCustomizer:NewModule("ZoneChannelModule", "AceEvent-3.0")
local config = ChatSoundCustomizer:GetModule("ConfigModule")

module.priority = 200

local zoneIdDbMap = {
	[1] = "generalSound",
	[2] = "tradeSound",
	[22] = "localDefenseSound",
	[32] = "newcomerSound"
}

function module:OnInitialize()
	local defaults = {
		profile = {
			generalSound = "None",
			tradeSound = "None",
			localDefenseSound = "None",
			newcomerSound = "None"
		}
	}
	self.db = ChatSoundCustomizer.db:RegisterNamespace("ZoneChannel", defaults)
	ChatSoundCustomizer:RegisterEvent("CHAT_MSG_CHANNEL", "PlaySound")
end

function module:PlaySound(event, ...)
	local zoneChannelID = select(7, ...)
	local dbVar = zoneIdDbMap[zoneChannelID]
	if not dbVar then return end

	local sound = self.db.profile[dbVar]
	if sound and sound ~= "None" then
		PlaySoundFile(AceGUIWidgetLSMlists.sound[sound], ChatSoundCustomizer.db.profile.channel or "Master")
		return true
	end
end

ChatSoundCustomizer.options.args.chat.args.zonechannel = {
	type = "group",
	name = function()
		local color = config:GetColorForEvent("CHAT_MSG_CHANNEL")
		return color:WrapTextInColorCode(L["Zone Channels"])
	end,
	args = {
		general = {
			type = "group",
			name = L["General"],
			inline = true,
			args = {
				sound = {
					type = "select",
					name = L["Select a sound"],
					width = "full",
					order = 1,
					dialogControl = "LSM30_Sound",
					values = AceGUIWidgetLSMlists.sound,
					set = function(info, val) module.db.profile.generalSound = val end,
					get = function(info) return module.db.profile.generalSound end,
				},
			}
		},
		trade = {
			type = "group",
			name = L["Trade"],
			inline = true,
			args = {
				sound = {
					type = "select",
					name = L["Select a sound"],
					width = "full",
					order = 1,
					dialogControl = "LSM30_Sound",
					values = AceGUIWidgetLSMlists.sound,
					set = function(info, val) module.db.profile.tradeSound = val end,
					get = function(info) return module.db.profile.tradeSound end,
				},
			}
		},
		localDefense = {
			type = "group",
			name = L["Local Defense"],
			inline = true,
			args = {
				sound = {
					type = "select",
					name = L["Select a sound"],
					width = "full",
					order = 1,
					dialogControl = "LSM30_Sound",
					values = AceGUIWidgetLSMlists.sound,
					set = function(info, val) module.db.profile.localDefenseSound = val end,
					get = function(info) return module.db.profile.localDefenseSound end,
				},
			}
		},
		newcomer = {
			type = "group",
			name = L["Newcomer"],
			inline = true,
			args = {
				sound = {
					type = "select",
					name = L["Select a sound"],
					width = "full",
					order = 1,
					dialogControl = "LSM30_Sound",
					values = AceGUIWidgetLSMlists.sound,
					set = function(info, val) module.db.profile.newcomerSound = val end,
					get = function(info) return module.db.profile.newcomerSound end,
				},
			}
		},
	}
}