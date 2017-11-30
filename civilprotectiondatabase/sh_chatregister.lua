local PLUGIN = PLUGIN

nut.chat.register("headquarters",
{
	font = "nutRadioFont",
	onCanSay =  function(speaker, text) return speaker:isCombine() end,
	onCanHear = function(speaker, listener) return (speaker:isCombine() and listener:isCombine()) end,
	onChatAdd = function(speaker, text) chat.AddText(PLUGIN.CivilProtection.Colors.RadioChat, "Центр "..PLUGIN.CivilProtection.City..": "..text) end
})

nut.chat.register("requestRadio",
{
	font = "nutRadioFont",
	onCanSay =  function(speaker, text) return speaker:isCombine() end,
	onCanHear = function(speaker, listener)
		local distantion = speaker:GetPos():Distance(listener:GetPos())
		local speakRange = nut.config.get("chatRange", 280)
		
		if (distantion <= speakRange) or (speaker:isCombine() and listener:isCombine()) then
			return true
		end

		return false
	end,

	onChatAdd = function(speaker, text) chat.AddText(PLUGIN.CivilProtection.Colors.RadioChat, speaker:Name().." Передает в рацию: "..text) end
})