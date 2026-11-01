-- Run from the addon directory with Lua 5.3+ or Fengari.
local packIds = {
	CSC_EffectPack01 = 61,
	CSC_NotificationPack01 = 48,
	CSC_NotificationPack02 = 27,
	CSC_StarCraftPack = 12
}

local function session(saved)
	local registered, modules = {}, {}
	local media = { MediaType = { SOUND = "sound" } }
	function media:Register(_, name, path)
		assert(not registered[name], "Duplicate sound: " .. name)
		registered[name] = path
	end
	local addon = { options = { args = {} }, db = {} }
	function addon:NewModule(name)
		local module = {}
		modules[name] = module
		return module
	end
	function addon.db:RegisterNamespace(name, defaults)
		assert(name == "SoundPacks")
		saved = saved or defaults
		return saved
	end
	local reloads = 0
	local env = setmetatable({
		ChatSoundCustomizer = addon,
		LibStub = function(name)
			assert(name == "LibSharedMedia-3.0")
			return media
		end,
		ReloadUI = function() reloads = reloads + 1 end
	}, { __index = _G })
	local namespace = setmetatable({}, { __index = function(_, key) return key end })
	local function load(path)
		assert(loadfile(path, "t", env))("Chat_Sound_Customizer", namespace)
	end
	load("SoundPacks.lua")
	for id in pairs(packIds) do
		load("sound-packs/" .. id .. "/Sounds.lua")
		assert(rawget(namespace, "sounds") == nil, "Pack leaked temporary data")
	end
	modules.SoundPacksModule:OnInitialize()
	return {
		saved = saved,
		registered = registered,
		options = addon.options.args.soundPacks.args,
		reloads = function() return reloads end
	}
end

local function count(sounds)
	local n = 0
	for _ in pairs(sounds) do n = n + 1 end
	return n
end

local first = session()
assert(count(first.registered) == 148, "Packs must start enabled")
for id in pairs(packIds) do assert(first.options[id].get() == true) end
first.options.CSC_StarCraftPack.set(nil, false)
assert(count(first.registered) == 148, "Changes must wait for reload")
assert(first.options.CSC_StarCraftPack.get() == false)
first.options.reload.func()
assert(first.reloads() == 1)

local second = session(first.saved)
assert(count(second.registered) == 136, "Disabled StarCraft should not be registered")
assert(second.registered["CSC StarCraft 01"] == nil)
second.options.CSC_StarCraftPack.set(nil, true)
assert(count(second.registered) == 136, "Enabling must wait for reload")
local third = session(second.saved)
assert(count(third.registered) == 148, "Enabled pack missing after reload")
assert(third.registered["CSC StarCraft 01"] ==
	"Interface\\AddOns\\Chat_Sound_Customizer\\sound-packs\\CSC_StarCraftPack\\sounds\\CSC_SC01.mp3")

for id, expected in pairs(packIds) do
	local enabled = {}
	for other in pairs(packIds) do enabled[other] = other == id end
	local current = session({ global = { enabled = enabled } })
	assert(count(current.registered) == expected, "Incorrect pack size: " .. id)
end
local all = { global = { enabled = {} } }
for id in pairs(packIds) do all.global.enabled[id] = true end
assert(count(session(all).registered) == 148, "All packs should register 148 unique sounds")
print("PASS: enabled defaults, saved toggles, reload, independent packs, paths and 148 sounds")
