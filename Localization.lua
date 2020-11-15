local _, L = ...

setmetatable(L, {
	__index = function(t, k) return k end,
	__newindex = function(t, k, v) rawset(t, k, v == true and k or v) end,
	__call = function(self, locale, tab)
		return (self[locale]:gsub('($%b{})', function(w) return tab[w:sub(3, -2)] or w end))
	end
})

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

L["Config UI"] = true
L["Open config UI"] = true
L["Chat"] = true
L["Chats"] = true
L["Channel"] = true
L["Multi Selection"] = true
L["Select a sound"] = true
L["Ignore List"] = true
L["Add to ignore list"] = true
L["Remove from ignore list"] = true
L["${button} to show the Config UI"] = true
L["Left-click"] = true
L["${button} to unmute CSC"] = true
L["${button} to temporarily mute CSC"] = true
L["Right-click"] = true
L["Temporarily Mute"] = true
L["Temporarily mute the addon, it will go back to normal after reload"] = true
L["Show minimap button"] = true
L["Newcomer"] = true
L["Guide"] = true
L["This sound will play when you are a GUIDE and a NEWCOMER says something in the Newcomer Chat"] = true
L["This sound will play when you are a NEWCOMER and a GUIDE says something in the Newcomer Chat"] = true
L["Zone Channels"] = true
L["General"] = true
L["Trade"] = true
L["Local Defense"] = true
L["Sound for receiving messages"] = true
L["Sound for sending messages"] = true

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

	L["Config UI"] = "Interface de Configuração"
	L["Open config UI"] = "Abrir configuração"
	L["Chat"] = "Chat"
	L["Chats"] = "Chats"
	L["Channel"] = "Canal"
	L["Multi Selection"] = "Seleção Múltipla"
	L["Select a sound"] = "Selecione um som"
	L["Ignore List"] = "Lista de ignorados"
	L["Add to ignore list"] = "Adicionar a lista de ignorados"
	L["Remove from ignore list"] = "Remover da lista de ignorados"
	L["${button} to show the Config UI"] = "${button} para mostrar a interface de configuração"
	L["Left-click"] = "Clique-esquerdo"
	L["${button} to unmute CSC"] = "${button} para desmutar o CSC"
	L["${button} to temporarily mute CSC"] = "${button} para mutar o CSC temporariamente"
	L["Right-click"] = "Clique-direito"
	L["Temporarily Mute"] = "Mutar temporariamente"
	L["Temporarily mute the addon, it will go back to normal after reload"] = "Muta temporariamente o addon, irá resetar ao recarregar o jogo"
	L["Show minimap button"] = "Exibir botão do minimapa"
	L["Newcomer"] = "Novato"
	L["Guide"] = "Guia"
	L["This sound will play when you are a GUIDE and a NEWCOMER says something in the Newcomer Chat"]
	= "Este som irá tocar quando você é um Guia e um Novato diz algo no chat de novatos"
	L["This sound will play when you are a NEWCOMER and a GUIDE says something in the Newcomer Chat"]
	= "Este som irá tocar quando você é um Novato e um Guia diz algo no chat de novatos"
	L["Zone Channels"] = "Canais de Área"
	L["General"] = "Geral"
	L["Trade"] = "Comércio"
	L["Local Defense"] = "Defesa Local"
	L["Sound for receiving messages"] = "Som para mensagens recebidas"
	L["Sound for sending messages"] = "Som para mensagens enviadas"
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






