local ADDON_NAME, L = ...

local AceDialog = LibStub("AceConfigDialog-3.0")

local module = ChatSoundCustomizer:NewModule("ConfigModule", "AceEvent-3.0")
module.priority = -1

local multiSelectedValues = {}
local chatColorMap = {}

function module:UPDATE_CHAT_COLOR(event, chatName, r, g, b)
	local color = chatColorMap[chatName]
	if color then
		color:SetRGB(r, g, b)
	else
		chatColorMap[chatName] = CreateColor(r, g, b)
	end
end

module:RegisterEvent("UPDATE_CHAT_COLOR")

function module:GetColorForEvent(event)
	local chatName = event:gsub("CHAT_MSG_(%w)", "%1")
	return chatName and chatColorMap[chatName]
end

function module:GetChatNameColored(event)
	local chatColor = self:GetColorForEvent(event)
	if (chatColor) then
		return chatColor:WrapTextInColorCode(L[event])
	end
	return L[event]
end

ChatSoundCustomizer.options = {
	type = "group",
	name = ChatSoundCustomizer.title,
	args = {
		ui = {
			type = "execute",
			name = L["Config UI"],
			desc = L["Open config UI"],
			guiHidden = true,
			func = function()
				AceDialog:Open(ADDON_NAME)
			end
		},
		chat = {
			type = "group",
			name = L["Chat"],
			args = {
				channel = {
					type = "select",
					name = L["Channel"],
					values = {
						["Master"] = "Master",
						["SFX"] = SOUND_VOLUME,
						["Music"] = MUSIC_VOLUME,
						["Ambience"] = AMBIENCE_VOLUME,
						["Dialog"] = DIALOG_VOLUME
					},
					get = function(info) return ChatSoundCustomizer.db.profile.channel end,
					set = function(info, val) ChatSoundCustomizer.db.profile.channel = val end
				},
				multi = {
					type = "group",
					inline = true,
					name = L["Multi Selection"],
					args = {
						select = {
							type = "multiselect",
							name = L["Chats"],
							order = 1,
							values = function()
								local values = {}
								for k, _ in pairs(ChatSoundCustomizer.eventsSoundTable) do
									values[k] = module:GetChatNameColored(k)
								end
								return values
							end,
							get = function(info, key) return multiSelectedValues[key] end,
							set = function(info, key, value) multiSelectedValues[key] = value end
						},
						sound = {
							type = "select",
							name = L["Select a sound"],
							order = 2,
							width = "full",
							dialogControl = "LSM30_Sound",
							values = AceGUIWidgetLSMlists.sound,
							set = function(info, val)
								for k, enabled in pairs(multiSelectedValues) do
									if enabled then
										ChatSoundCustomizer.db.profile.sounds[k] = val
									end
								end
							end,
							get = function(info)
								local selectedSound
								for k, enabled in pairs(multiSelectedValues) do
									if enabled then
										selectedSound = selectedSound or ChatSoundCustomizer.db.profile.sounds[k]
										if ChatSoundCustomizer.db.profile.sounds[k] ~= selectedSound then
											return
										end
									end
								end
								return selectedSound
							end,
							order = 3,
						}
					}
				}
			}
		}
	}
}

for k, _ in pairs(ChatSoundCustomizer.eventsSoundTable) do
	ChatSoundCustomizer.options.args.chat.args[k] = {
		type = "group",
		name = function() return module:GetChatNameColored(k) end,
		args = {
			sound = {
				type = "select",
				name = L["Select a sound"],
				width = "full",
				dialogControl = "LSM30_Sound",
				values = AceGUIWidgetLSMlists.sound,
				set = function(info, val) ChatSoundCustomizer.db.profile.sounds[k] = val end,
				get = function(info) return ChatSoundCustomizer.db.profile.sounds[k] end,
				order = 3,
			}
		}
	}
end
