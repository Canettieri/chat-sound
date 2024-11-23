local ADDON_NAME, L = ...

local module = ChatSoundCustomizer:NewModule("CustomChannelModule", "AceEvent-3.0")
module.priority = 150

function module:OnInitialize()
	local defaults = { profile = { channels = {} } }
	self.db = ChatSoundCustomizer.db:RegisterNamespace("CustomChannel", defaults)
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

function module:PlaySound(event, ...)
	local baseName = select(9, ...)
	local channelConfig = module.db.profile.channels[baseName]
	if not channelConfig then return end

	local sound
	if (ChatSoundCustomizer:IsOutput(select(2, ...))) then
		sound = channelConfig.output
	else
		sound = channelConfig.input
	end

	if sound and sound ~= "None" then
		ChatSoundCustomizer:PlaySoundThrottle(event, sound)
		return true
	end
end

function module:AddChannelOption(key, channelTable)
	if not key or not channelTable then return end
	ChatSoundCustomizer.options.args.customChannel.args[key] = {
		type = "group",
		name = channelTable.name or "",
		order = 1,
		args = {
			soundReceive = ChatSoundCustomizer:CreateSoundAceOption(
					L["Sound for receiving messages"],
					1,
					{ module, "db", "profile", "channels", key, "input" }
			),
			soundSend = ChatSoundCustomizer:CreateSoundAceOption(
					L["Sound for sending messages"],
					2,
					{ module, "db", "profile", "channels", key, "output" }
			),
		}
	}
end

local function CreateBaseOptions()
	return {
		type = "group",
		name = L["Custom Channel"],
		args = {
			add = {
				name = L["Add channel"],
				type = "input",
				order = 1,
				width = "full",
				get = false,
				set = function(info, value)
					if not value or value == "" or module.db.profile.channels[value] then
						return
					end

					local newTable = {
						name = value
					}
					module.db.profile.channels[value] = newTable
					module:UpdateOptions()
				end
			},
			remove = {
				name = L["Remove channel"],
				type = "select",
				order = 2,
				width = "full",
				values = function()
					local values = {}
					for k, v in pairs(module.db.profile.channels) do
						values[tostring(k)] = tostring(v.name)
					end
					return values
				end,
				get = false,
				set = function(info, value)
					module.db.profile.channels[value] = nil
					module:UpdateOptions()
				end
			},
		}
	}
end

function module:UpdateOptions()
	ChatSoundCustomizer.options.args.customChannel = CreateBaseOptions()
	for k, v in pairs(module.db.profile.channels) do
		module:AddChannelOption(k, v)
	end
end
