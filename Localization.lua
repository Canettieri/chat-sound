local _, L = ...

setmetatable(L, { __index = function(t, k) return k end })

L["CHAT_MSG_OFFICER"] = "Guild Officer"
L["CHAT_MSG_GUILD"] = "Guild"
L["CHAT_MSG_WHISPER"] = "Whisper"
L["CHAT_MSG_BN_WHISPER"] = "BN Whisper"
L["CHAT_MSG_PARTY"] = "Party"
L["CHAT_MSG_PARTY_LEADER"] = "Party Leader"
L["CHAT_MSG_COMMUNITIES_CHANNEL"] = "Communities"
L["CHAT_MSG_RAID"] = "Raid"
L["CHAT_MSG_RAID_LEADER"] = "Raid Leader"
L["CHAT_MSG_INSTANCE_CHAT"] = "Instance"
L["CHAT_MSG_INSTANCE_CHAT_LEADER"] = "Instance Leader"

--@localization(locale="enUS", format="lua_additive_table", same-key-is-true=true)@
if GetLocale() == "enUS" or GetLocale() == "enGB" then
	return
end

if GetLocale() == "ptBR" then
	--@localization(locale="ptBR", format="lua_additive_table")@
	--@debug@
	L["CHAT_MSG_OFFICER"] = "Oficial da Guilda"
	L["CHAT_MSG_GUILD"] = "Guilda"
	L["CHAT_MSG_WHISPER"] = "Sussurro"
	L["CHAT_MSG_BN_WHISPER"] = "Sussurro BN"
	L["CHAT_MSG_PARTY"] = "Grupo"
	L["CHAT_MSG_PARTY_LEADER"] = "Líder do Grupo"
	L["CHAT_MSG_COMMUNITIES_CHANNEL"] = "Comunidades"
	L["CHAT_MSG_RAID"] = "Raid"
	L["CHAT_MSG_RAID_LEADER"] = "Líder da Raid"
	L["CHAT_MSG_INSTANCE_CHAT"] = "Instância"
	L["CHAT_MSG_INSTANCE_CHAT_LEADER"] = "Líder da Instância"

	L["Channel"] = "Canal"
	L["Select a sound"] = "Selecione um som"
	--@end-debug@

	return
end

if GetLocale() == "frFR" then
	--@localization(locale="frFR", format="lua_additive_table")@
	return
end

if GetLocale() == "deDE" then
	--@localization(locale="deDE", format="lua_additive_table")@
	return
end

if GetLocale() == "itIT" then
	--@localization(locale="itIT", format="lua_additive_table")@
	return
end

if GetLocale() == "esES" then
	--@localization(locale="esES", format="lua_additive_table")@
	return
end

if GetLocale() == "esMX" then
	--@localization(locale="esMX", format="lua_additive_table")@
	return
end

if GetLocale() == "ruRU" then
	--@localization(locale="ruRU", format="lua_additive_table")@
	return
end






