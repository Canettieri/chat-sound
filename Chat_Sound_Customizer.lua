local ADDON_NAME, L = ...

local fullName

ChatSoundCustomizer = LibStub("AceAddon-3.0"):NewAddon(ADDON_NAME, "AceEvent-3.0")

ChatSoundCustomizer.eventsSoundTable = {
	-- Guild
	["CHAT_MSG_OFFICER"] = "CSC Sound 1",
	["CHAT_MSG_GUILD"] = "CSC Sound 1",

	-- Whisper
	["CHAT_MSG_WHISPER"] = "CSC Sound 8",
	["CHAT_MSG_BN_WHISPER"] = "CSC Sound 8",

	-- Party (group or /p)
	["CHAT_MSG_PARTY"] = "CSC Sound 3",
	["CHAT_MSG_PARTY_LEADER"] = "CSC Sound 3",

	-- Communities
	["CHAT_MSG_COMMUNITIES_CHANNEL"] = "CSC Sound 4",

	-- Raid and Instances
	["CHAT_MSG_RAID"] = "CSC Sound 5",
	["CHAT_MSG_RAID_LEADER"] = "CSC Sound 5",
	["CHAT_MSG_INSTANCE_CHAT"] = "CSC Sound 5",
	["CHAT_MSG_INSTANCE_CHAT_LEADER"] = "CSC Sound 5",
}

function ChatSoundCustomizer:OnInitialize()
	local defaults = { profile = { sounds = self.eventsSoundTable, channel = "Master" } }
	self.db = LibStub("AceDB-3.0"):New("ChatSoundCustomizerDB", defaults, "Default")
	self.options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	self.options.args.profile.order = -1

	for event, _ in pairs(ChatSoundCustomizer.eventsSoundTable) do
		self:RegisterEvent(event, "PlaySound")
	end

	local AceConfig = LibStub("AceConfig-3.0")
	AceConfig:RegisterOptionsTable(ADDON_NAME, self.options, { "csc", "chatsound" })

	local AceDialog = LibStub("AceConfigDialog-3.0")
	self.optionsFrame = AceDialog:AddToBlizOptions(ADDON_NAME)
end

function ChatSoundCustomizer:OnEnable()
	local myName, myRealm = UnitFullName("Player")
	fullName = myName .. "-" .. myRealm
end

function ChatSoundCustomizer:PlaySound(event, _, playerName, ...)
	if playerName == fullName then return end
	local sound = self.db.profile.sounds[event]
	if sound and sound ~= "None" then
		PlaySoundFile(AceGUIWidgetLSMlists.sound[sound], ChatSoundCustomizer.db.profile.channel or "Master")
	end
end