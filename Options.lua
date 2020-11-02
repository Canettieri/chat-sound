local ADDON_NAME, L = ...

local AceDialog = LibStub("AceConfigDialog-3.0")

AddonChatSound.options = {
	type = "group",
	name = ADDON_NAME,
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
		events = {
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
					get = function(info) return AddonChatSound.db.profile.channel end,
					set = function(info, val) AddonChatSound.db.profile.channel = val end
				}
			}
		}
	}
}

for k, _ in pairs(AddonChatSound.eventsSoundTable) do
	AddonChatSound.options.args.events.args[k] = {
		type = "group",
		name = L[k],
		args = {
			sound = {
				type = "select",
				name = L["Select a sound"],
				width = "full",
				dialogControl = "LSM30_Sound",
				values = AceGUIWidgetLSMlists.sound,
				set = function(info, val) AddonChatSound.db.profile.sounds[k] = val end,
				get = function(info) return AddonChatSound.db.profile.sounds[k] end,
				order = 3,
			}
		}
	}
end
