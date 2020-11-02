local sound = {
-- Guild
	["CHAT_MSG_OFFICER"] = "Interface\\AddOns\\Chat_Sound\\audios\\sound1.mp3", MASTER,
	["CHAT_MSG_GUILD"] = "Interface\\AddOns\\Chat_Sound\\audios\\sound1.mp3", MASTER,

-- Whisper
	["CHAT_MSG_WHISPER"] = "Interface\\AddOns\\Chat_Sound\\audios\\sound8.mp3", MASTER,
	["CHAT_MSG_BN_WHISPER"] = "Interface\\AddOns\\Chat_Sound\\audios\\sound8.mp3", MASTER,
	
-- Party (group or /p)
	["CHAT_MSG_PARTY"] = "Interface\\AddOns\\Chat_Sound\\audios\\sound3.mp3", MASTER,
	["CHAT_MSG_PARTY_LEADER"] = "Interface\\AddOns\\Chat_Sound\\audios\\sound3.mp3", MASTER,
	
-- Communities
	["CHAT_MSG_COMMUNITIES_CHANNEL"] = "Interface\\AddOns\\Chat_Sound\\audios\\sound4.mp3", MASTER,
	
-- Raid and Instances
	["CHAT_MSG_RAID"] = "Interface\\AddOns\\Chat_Sound\\audios\\sound5.mp3", MASTER,
	["CHAT_MSG_RAID_LEADER"] = "Interface\\AddOns\\Chat_Sound\\audios\\sound5.mp3", MASTER,
    ["CHAT_MSG_INSTANCE_CHAT"] = "Interface\\AddOns\\Chat_Sound\\audios\\sound5.mp3", MASTER,
	["CHAT_MSG_INSTANCE_CHAT_LEADER"] = "Interface\\AddOns\\Chat_Sound\\audios\\sound5.mp3", MASTER,
}

local f = CreateFrame("Frame")
	f:RegisterEvent("CHAT_MSG_RAID_LEADER")
	f:RegisterEvent("CHAT_MSG_RAID")
	f:RegisterEvent("CHAT_MSG_PARTY")
	f:RegisterEvent("CHAT_MSG_WHISPER")
	f:RegisterEvent("CHAT_MSG_OFFICER")
	f:RegisterEvent("CHAT_MSG_GUILD")
	f:RegisterEvent("CHAT_MSG_PARTY_LEADER")
	f:RegisterEvent("CHAT_MSG_BN_WHISPER")
	f:RegisterEvent("CHAT_MSG_INSTANCE_CHAT")
	f:RegisterEvent("CHAT_MSG_INSTANCE_CHAT_LEADER")
	f:RegisterEvent("CHAT_MSG_COMMUNITIES_CHANNEL")
	f:SetScript("OnEvent", function(self, event)
		PlaySoundFile(sound[event])
end)
