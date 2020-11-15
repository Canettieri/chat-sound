local ADDON_NAME, L = ...

local module = ChatSoundCustomizer:NewModule("NewcomerModule", "AceEvent-3.0")
local config = ChatSoundCustomizer:GetModule("ConfigModule")

function module:OnInitialize()
	local defaults = { profile = { newcomerSound = "None", guideSound = "None" } }
	self.db = ChatSoundCustomizer.db:RegisterNamespace("Newcomer", defaults)

	self:RegisterEvent("CHAT_MSG_CHANNEL", "PlaySound")
end

local function play(sound)
	if sound and sound ~= "None" then
		PlaySoundFile(AceGUIWidgetLSMlists.sound[sound], ChatSoundCustomizer.db.profile.channel or "Master")
	end
end

function module:PlaySound(event, ...)
	if ChatSoundCustomizer:ShouldIgnoreEvent(...) then return end

	local flag = select(6, ...)
	if (flag == "NEWCOMER" and IsActivePlayerMentor()) then
		play(self.db.profile.newcomerSound)
	elseif (flag == "GUIDE" and C_PlayerMentorship.IsActivePlayerConsideredNewcomer()) then
		play(self.db.profile.guideSound)
	end
end


ChatSoundCustomizer.options.args.chat.args.newcomer = {
	type = "group",
	name = function()
		local color = config:GetColorForEvent("CHAT_MSG_CHANNEL")
		return NPEV2_CHAT_USER_TAG_NEWCOMER .. " " .. color:WrapTextInColorCode(L["Newcomer"]) .. " / " .. NPEV2_CHAT_USER_TAG_GUIDE
	end,
	args = {
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
				description = {
					type = "description",
					name = L["This sound will play when you are a GUIDE and a NEWCOMER says something in the Newcomer Chat"],
					order = 2
				}
			}
		},
		guide = {
			type = "group",
			name = L["Guide"],
			inline = true,
			args = {
				sound = {
					type = "select",
					name = L["Select a sound"],
					width = "full",
					order = 1,
					dialogControl = "LSM30_Sound",
					values = AceGUIWidgetLSMlists.sound,
					set = function(info, val) module.db.profile.guideSound = val end,
					get = function(info) return module.db.profile.guideSound end,
				},
				description = {
					type = "description",
					name = L["This sound will play when you are a NEWCOMER and a GUIDE says something in the Newcomer Chat"],
					order = 2
				}
			}
		},
	}
}