local ADDON_NAME, L = ...

local module = ChatSoundCustomizer:NewModule("PlayerListModule", "AceEvent-3.0")
module.priority = 5

local Completing = LibStub("AceGUI-3.0-Eliote-AutoCompleteEditBox")
Completing:Register("CSCOnlinePlayersAutoComplete", AUTOCOMPLETE_LIST_TEMPLATES.ALL_CHARS)

function module:OnInitialize()
	local defaults = { profile = { players = {}, groups = {} } }
	self.db = ChatSoundCustomizer.db:RegisterNamespace("PlayerList", defaults)
	ChatSoundCustomizer:RegisterEvent("CHAT_MSG_CHANNEL", "PlaySound")
	self.db.RegisterCallback(self, "OnProfileChanged", "UpdateOptions")
	self.db.RegisterCallback(self, "OnProfileCopied", "UpdateOptions")
	self.db.RegisterCallback(self, "OnProfileReset", "UpdateOptions")
	self:UpdateOptions()
end

local function play(flag, sound)
	if sound and sound ~= "None" then
		ChatSoundCustomizer:PlaySoundThrottle(flag, sound)
		return true
	end
end

function module:PlaySound(event, _, playerName)
	local players = self.db.profile.players
	local playerConfig = players[playerName] or players[(string.match(playerName, "(.*)-.*"))]
	if playerConfig then
		if (ChatSoundCustomizer:IsOutput(playerName)) then
			return play(playerName, playerConfig.output)
		else
			return play(playerName, playerConfig.input)
		end
	end
	for k, group in pairs(self.db.profile.groups) do
		local hasPlayer = group.players[playerName] or group.players[(string.match(playerName, "(.*)-.*"))]
		if hasPlayer then
			if (ChatSoundCustomizer:IsOutput(playerName)) then
				return play(playerName, group.output)
			else
				return play(playerName, group.input)
			end
		end
	end
end

local function CreateBaseOptions()
	return {
		type = "group",
		name = L["Customized"],
		args = {
			add = {
				name = L["Add player"],
				type = "input",
				order = 1,
				width = "full",
				dialogControl = "EditBoxCSCOnlinePlayersAutoComplete",
				get = false,
				set = function(info, value)
					if not value or value == "" then
						local name = GetUnitName("Target", true)
						value = name
					end

					if not value or value == "" or module.db.profile.players[value] then
						return
					end

					local newTable = {
						name = value
					}
					module.db.profile.players[value] = newTable
					module:UpdateOptions()
				end
			},
			remove = {
				name = L["Remove player"],
				type = "select",
				order = 2,
				width = "full",
				values = function()
					local values = {}
					for k, v in pairs(module.db.profile.players) do
						values[tostring(k)] = tostring(v.name)
					end
					return values
				end,
				get = false,
				set = function(info, value)
					module.db.profile.players[value] = nil
					module:UpdateOptions()
				end
			},
			addGroup = {
				name = L["Create group"],
				type = "input",
				order = 3,
				width = "full",
				get = false,
				set = function(info, value)
					if not value or value == "" or module.db.profile.groups[value] then
						return
					end

					local newTable = {
						name = value,
						players = {}
					}
					module.db.profile.groups[value] = newTable
					module:UpdateOptions()
				end
			},
			removeGroup = {
				name = L["Remove group"],
				type = "select",
				order = 4,
				width = "full",
				values = function()
					local values = {}
					for k, group in pairs(module.db.profile.groups) do
						values[tostring(k)] = tostring(group.name)
					end
					return values
				end,
				get = false,
				set = function(info, value)
					module.db.profile.groups[value] = nil
					module:UpdateOptions()
				end
			},
		}
	}
end

function module:AddPlayer(key, playerTable)
	if not key or not playerTable then return end
	ChatSoundCustomizer.options.args.customized.args[key] = {
		type = "group",
		name = playerTable.name or "",
		order = 2,
		args = {
			soundReceive = ChatSoundCustomizer:CreateSoundAceOption(
					L["Sound for receiving messages"],
					1,
					{ module, "db", "profile", "players", key, "input" }
			),
			soundSend = ChatSoundCustomizer:CreateSoundAceOption(
					L["Sound for sending messages"],
					2,
					{ module, "db", "profile", "players", key, "output" }
			),
		}
	}
end

function module:AddGroup(key, groupTable)
	if not key or not groupTable then return end
	ChatSoundCustomizer.options.args.customized.args["group_" .. key] = {
		type = "group",
		name = "|cFF80deea" .. L["Group"] .. ": " .. tostring(groupTable.name),
		order = 1,
		args = {
			soundReceive = ChatSoundCustomizer:CreateSoundAceOption(
					L["Sound for receiving messages"],
					1,
					{ module, "db", "profile", "groups", key, "input" }
			),
			soundSend = ChatSoundCustomizer:CreateSoundAceOption(
					L["Sound for sending messages"],
					2,
					{ module, "db", "profile", "groups", key, "output" }
			),
			add = {
				name = L["Add player"],
				type = "input",
				order = 3,
				width = "full",
				dialogControl = "EditBoxCSCOnlinePlayersAutoComplete",
				get = false,
				set = function(info, value)
					if not value or value == "" then
						local name = GetUnitName("Target", true)
						value = name
					end
					if not value or value == "" or module.db.profile.groups[key].players[value] then
						return
					end
					module.db.profile.groups[key].players[value] = { name = value }
					module:UpdateOptions()
				end
			},
			remove = {
				name = L["Remove player"],
				type = "select",
				order = 4,
				width = "full",
				values = function()
					local values = {}
					for k, player in pairs(module.db.profile.groups[key].players) do
						values[tostring(k)] = tostring(player.name)
					end
					return values
				end,
				get = false,
				set = function(info, value)
					module.db.profile.groups[key].players[value] = nil
					module:UpdateOptions()
				end
			},
		}
	}
end

function module:UpdateOptions()
	ChatSoundCustomizer.options.args.customized = CreateBaseOptions()
	for k, v in pairs(module.db.profile.players) do
		module:AddPlayer(k, v)
	end
	for k, v in pairs(module.db.profile.groups) do
		module:AddGroup(k, v)
	end
end
