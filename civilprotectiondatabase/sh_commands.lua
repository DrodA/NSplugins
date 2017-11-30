local PLUGIN = PLUGIN

local callBackTime = PLUGIN.CivilProtection.CallBackTimer
local inEmitSound = PLUGIN.CivilProtection.InEmitSound
local outEmitSound = PLUGIN.CivilProtection.OutEmitSound
local callDelay = PLUGIN.CivilProtection.CallDelay

-- do we need this?
local function timerSimple(callback)
	local timer = timer

	timer.Simple(callBackTime, callback)
end

local function DatabaseSetData(client, target, loyality, amount)
	local character = target:getChar()
	local characterID = character:getData("cit_cid", 0)
	local characterLoyal = character:getData("cit_loyality", 0)
	local characterPenal = character:getData("cit_penalty", 0)

	client:EmitSound(inEmitSound)
	timerSimple(function()
		client:EmitSound(outEmitSound)
		nut.chat.send(client, "headquarters", "Запрос на изменение данных Гражданина #"..characterID.." был подтвержден.", false, client)

		if (loyality) then
			character:setData("cit_loyality", math.Clamp(characterLoyal + tonumber(amount), 0, PLUGIN.CivilProtection.MaximumLoyality))
			nut.chat.send(client, "headquarters", ((amount > 0) and "Зачислены очки лояльности Гражданину #"..characterID..". Гражданин получил "..amount.." очков лояльности. Общее количество: "..characterLoyal) or "Урезаны очки лояльности Гражданину #"..characterID..". Гражданин потерял "..amount.." очков лояльности. Общее количество: "..characterLoyal, false, client)
		else
			character:setData("cit_penalty", math.Clamp(characterPenal + tonumber(amount), 0, PLUGIN.CivilProtection.MaximumPenalty))
			nut.chat.send(client, "headquarters", ((amount > 0) and "Зачислены очки нарушений Гражданину #"..characterID..". Гражданин получил "..amount.." очков нарушений. Общее количество: "..characterPenal) or "Урезаны очки нарушений Гражданину #"..characterID..". Гражданин потерял "..amount.." очков нарушений. Общее количество: "..characterPenal, false, client)
		end
	end)
end

local function DatabaseGetData(client, target)
	local character = target:getChar()

	client:EmitSound(inEmitSound)

	timerSimple(function()
		client:EmitSound(outEmitSound)

		local characterData =
		{
			loyality = {id = "Лояльность: ", value = character:getData("cit_loyality", 0)},
			penalty = {id = "Нарушения: ", value = character:getData("cit_penalty", 0)},
			status = {id = "Статус: ", value = character:getData("cit_status", "NON-CITIZEN")},
			cid = {id = "Идентификатор: #", value = character:getData("cit_cid", 0)}
		}

		-- fuck off, switch/case
		if (characterData.loyality.value >= 100) then
			characterData.loyality.value = "5 уровень"
		elseif (characterData.loyality.value >= 60) then
			characterData.loyality.value = "4 уровень"
		elseif (characterData.loyality.value >= 30) then
			characterData.loyality.value = "3 уровень"
		elseif (characterData.loyality.value >= 10) then
			characterData.loyality.value = "2 уровень"
		elseif (characterData.loyality.value >= 0) then
			characterData.loyality.value = "1 уровень"
		end

		if (characterData.status.value == "NON-CITIZEN") then
			characterData.status.value = "Не подтвержден"
		elseif (characterData.status.value == "CITIZEN") then
			characterData.status.value = "Подтвержден"
		elseif (characterData.status.value == "ANTICITIZEN") then
			characterData.status.value = "Нарушитель"
		end

		nut.chat.send(client, "headquarters", "Запрос на информацию Гражданина #"..characterData.cid.value.." был подтвержден.", false, client)

		for k, v in SortedPairs(characterData) do
			nut.chat.send(client, "headquarters", v.id..v.value, false, client)
		end

		if (character:getData("cit_jail_type", "#N") ~= "#N") then
			nut.chat.send(client, "headquarters", "Гражданин содержится под стражей", false, client)
			nut.chat.send(client, "headquarters", "Причина задержания: "..character:getData("cit_jail_type", "#N"), false, client)
			nut.chat.send(client, "headquarters", "Срок до освобождения: "..character:getData("cit_jail_time", 0), false, client)
		end
	end)
end

nut.command.add("getinfo",
{
	syntax = "<string cid>",
	onRun = function(client, arguments)
		if ((client.Delay or 0) < CurTime()) then
			for k, v in pairs(player.GetAll()) do
				if !v:getChar() then continue end
				if (client == v) then continue end

				local character = v:getChar()
				local characterID = character:getData("cit_cid", 0)
				local argumentID = tonumber(arguments[1])

				if (characterID == 0) then return end

				if (argumentID == characterID) then
					nut.chat.send(client, "requestRadio", "Центр, запрашиваю данные Гражданина #"..characterID, false)
					DatabaseGetData(client, v)
				end
			end

			client.Delay = CurTime() + callDelay
		end
	end,
	onCheckAccess = function(client)
		return client:isCombine()
	end
})

nut.command.add("setstatus",
{
	syntax = "<string cid> <string status>",
	onRun = function(client, arguments)
		if ((client.Delay or 0) < CurTime()) then
			for k, v in pairs(player.GetAll()) do
				local character = v:getChar()
				local characterID = character:getData("cit_cid", 0)
				local characterStatus = character:getData("cit_status","NON-CITIZEN")

				local argumentID = tonumber(arguments[1])
				local argumentStatus = tostring(arguments[2])

				if (argumentID == characterID) then
					client:EmitSound(inEmitSound)
					nut.chat.send(client, "requestRadio", "Центр, запрашиваю смену статуса Гражданина #"..characterID.." на "..argumentStatus..".", false)

					timerSimple(function()
						client:EmitSound(outEmitSound)

						if (argumentStatus == "ANTICITIZEN" or argumentStatus == "CITIZEN") then
							if (argumentStatus == "ANTICITIZEN") then
								nut.chat.send(client, "headquarters", "Статус Гражданина #"..characterID.." изменен на "..argumentStatus..".", false, client)
								nut.chat.send(client, "dispatch", "Гражданин #"..characterID..". Вы обвиняетесь в тяжком несоответствии. Асоциальный статус подтвержден.", true)
								
								BroadcastLua("v:EmitSound('npc/overwatch/cityvoice/f_capitalmalcompliance_spkr.wav')")
								
								character:setData("cit_loyality", 0)
								character:setData("cit_penalty", 100)
							end

							nut.chat.send(client, "headquarters", "Статус Гражданина #"..characterID.." изменен на "..argumentStatus..".", false, client)
							character:setData("cit_status", argumentStatus)
						else
							nut.chat.send(client, "headquarters", "В изменении статуса отказано. Причина: Некорректный запрос.", false, client)
						end
					end)
				end
			end

			client.Delay = CurTime() + callDelay
		end
	end,
	onCheckAccess = function(client)
		return client:isCombine()
	end
})

nut.command.add("apply",
{
	onRun = function(client)
		local character = client:getChar()

		if (character) then
			nut.chat.send(client, "ic", character:getName()..", #"..character:getData("cit_cid", 0))
		end
	end,
	onCheckAccess = function(client)
		return !client:isCombine()
	end
})