-- prevent loading this module on classic
if not C_PlayerMentorship or not IsActivePlayerMentor then return end

local ADDON_NAME, L = ...

local module = ChatSoundCustomizer:NewModule("NewcomerModule", "AceEvent-3.0")
local config = ChatSoundCustomizer:GetModule("ConfigModule")

module.priority = 100

function module:OnInitialize()
	local defaults = { profile = { newcomerSound = "None", guideSound = "None" } }
	self.db = ChatSoundCustomizer.db:RegisterNamespace("Newcomer", defaults)
	ChatSoundCustomizer:RegisterEvent("CHAT_MSG_CHANNEL", "PlaySound")
end

local function play(flag, sound)
	if sound and sound ~= "None" then
		ChatSoundCustomizer:PlaySoundThrottle(flag, sound)
		return true
	end
end

function module:PlaySound(event, ...)
	local flag = select(6, ...)
	if (flag == "NEWCOMER" and IsActivePlayerMentor()) then
		return play(flag, self.db.profile.newcomerSound)
	elseif (flag == "GUIDE" and C_PlayerMentorship.IsActivePlayerConsideredNewcomer()) then
		return play(flag, self.db.profile.guideSound)
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
				sound = ChatSoundCustomizer:CreateSoundAceOption(
						L["Select a sound"],
						1,
						{ module, "db", "profile", "newcomerSound" }
				),
				description = {
					type = "description",
					name = L["This sound will play when you are a GUIDE and a NEWCOMER says something in the Newcomer Chat"],
					order = 2
				}
			},
			order = 1
		},
		guide = {
			type = "group",
			name = L["Guide"],
			inline = true,
			args = {
				sound = ChatSoundCustomizer:CreateSoundAceOption(
						L["Select a sound"],
						1,
						{ module, "db", "profile", "guideSound" }
				),
				description = {
					type = "description",
					name = L["This sound will play when you are a NEWCOMER and a GUIDE says something in the Newcomer Chat"],
					order = 2
				}
			},
			order = 2
		},
	}
}