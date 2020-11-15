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
			generalSound = { input = "None", output = "None" },
			tradeSound = { input = "None", output = "None" },
			localDefenseSound = { input = "None", output = "None" },
			newcomerSound = { input = "None", output = "None" }
		}
	}
	self.db = ChatSoundCustomizer.db:RegisterNamespace("ZoneChannel", defaults)
	ChatSoundCustomizer:RegisterEvent("CHAT_MSG_CHANNEL", "PlaySound")
end

function module:PlaySound(event, ...)
	local zoneChannelID = select(7, ...)
	local dbVar = zoneIdDbMap[zoneChannelID]
	if not dbVar then return end

	local sound
	if (ChatSoundCustomizer:IsOutput(...)) then
		sound = self.db.profile[dbVar] and self.db.profile[dbVar].output
	else
		sound = self.db.profile[dbVar] and self.db.profile[dbVar].input
	end

	if sound and sound ~= "None" then
		PlaySoundFile(AceGUIWidgetLSMlists.sound[sound], ChatSoundCustomizer.db.profile.channel or "Master")
		return true
	end
end

local function createConfigArgs(db)
	return {
		soundReceive = {
			type = "select",
			name = L["Sound for receiving messages"],
			width = "full",
			order = 1,
			dialogControl = "LSM30_Sound",
			values = AceGUIWidgetLSMlists.sound,
			set = function(info, val) module.db.profile[db].input = val end,
			get = function(info) return module.db.profile[db].input end,
		},
		soundSend = {
			type = "select",
			name = L["Sound for sending messages"],
			width = "full",
			order = 1,
			dialogControl = "LSM30_Sound",
			values = AceGUIWidgetLSMlists.sound,
			set = function(info, val) module.db.profile[db].output = val end,
			get = function(info) return module.db.profile[db].output end,
		},
	}
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
			args = createConfigArgs("generalSound")
		},
		trade = {
			type = "group",
			name = L["Trade"],
			inline = true,
			args = createConfigArgs("tradeSound")
		},
		localDefense = {
			type = "group",
			name = L["Local Defense"],
			inline = true,
			args = createConfigArgs("localDefenseSound")
		},
		newcomer = {
			type = "group",
			name = L["Newcomer"],
			inline = true,
			args = createConfigArgs("newcomerSound")
		},
	}
}