local ADDON_NAME, L = ...
local LSM = LibStub("LibSharedMedia-3.0")
local module = ChatSoundCustomizer:NewModule("SoundPacksModule")
module.priority = -1

local packs = {}
local options = {
	type = "group",
	name = L["Sound packs"],
	args = {
		description = {
			type = "description",
			name = L["Enable the extra sound packs you want to use. Changes take effect after reloading the UI. Disabling a pack keeps your sound selections saved, but its sounds will be unavailable until enabled again."],
			order = 0
		},
		reload = {
			type = "execute",
			name = L["Reload UI"],
			order = -1,
			func = function() ReloadUI() end
		}
	}
}
ChatSoundCustomizer.options.args.soundPacks = options

function ChatSoundCustomizer:RegisterSoundPack(id, title, sounds)
	packs[id] = sounds
	options.args[id] = {
		type = "toggle",
		name = title,
		width = "full",
		order = 1,
		get = function() return module.db.global.enabled[id] ~= false end,
		set = function(_, enabled) module.db.global.enabled[id] = enabled end
	}
end

function module:OnInitialize()
	self.db = ChatSoundCustomizer.db:RegisterNamespace("SoundPacks", { global = { enabled = {} } })
	for id, sounds in pairs(packs) do
		if self.db.global.enabled[id] ~= false then
			local path = "Interface\\AddOns\\" .. ADDON_NAME .. "\\sound-packs\\" .. id .. "\\sounds\\"
			for name, file in pairs(sounds) do
				LSM:Register(LSM.MediaType.SOUND, name, path .. file)
			end
		end
	end
end
