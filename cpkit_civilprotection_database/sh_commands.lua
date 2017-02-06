local function _setData(client, target, loyality, amount)
	client:EmitSound("npc/combine_soldier/vo/on2.wav")
	local char = target:getChar()
	local cit_cid = char:getData("cit_cid", 0)

	timer.Simple(2, function()
		client:EmitSound("npc/combine_soldier/vo/off"..math.random(1, 2)..".wav")

		nut.chat.send(client, "headquarters", "Запрос на изменение данных Гражданина #"..cit_cid.." был подтвержден.", false, client)

		if (loyality == true) then
			char:setData("cit_loyality", math.Clamp(char:getData("cit_loyality", 0) + tonumber(amount), 0, 100))
			local lp = char:getData("cit_loyality", 0)
			if amount > 0 then
				nut.chat.send(client, "headquarters", "Очки лояльности Гражданину #"..cit_cid.." были начислены. Гражданин получил "..amount.." очков лояльности. Общее количество: "..lp, false, client)
			else
				nut.chat.send(client, "headquarters", "Очки лояльности Гражданина #"..cit_cid.." были урезаны. Гражданин потерял "..amount.." очков лояльности. Общее количество: "..lp, false, client)
			end
		else
			char:setData("cit_penalty", math.Clamp(char:getData("cit_penalty", 0) + tonumber(amount), 0, 100))
			local pp = char:getData("cit_penalty", 0)
			if amount > 0 then
				nut.chat.send(client, "headquarters", "Очки нарушений Гражданину #"..cit_cid.." были начислены. Гражданин получил "..amount.." очков нарушений. Общее количество: "..pp, false, client)
			else
				nut.chat.send(client, "headquarters", "Очки нарушений Гражданина #"..cit_cid.." были урезаны. Гражданин потерял "..amount.." очков нарушений. Общее количество: "..pp, false, client)
			end
		end
	end)
end

local function _setDataCP(client, target, loyality, amount)
	client:EmitSound("npc/combine_soldier/vo/on2.wav")
	local char = target:getChar()

	timer.Simple(2, function()
		client:EmitSound("npc/combine_soldier/vo/off"..math.random(1, 2)..".wav")

		if !client:isCombineRank(SCHEMA.eliteRanks) || target:isOTA() then
			nut.chat.send(client, "headquarters", "Запрос на изменение данных Юнита был отклонен.", false, client)

			return
		else
			nut.chat.send(client, "headquarters", "Запрос на изменение данных Юнита #"..target:getDigits().." был подтвержден.", false, client)
		end

		if (loyality == true) then
			char:setData("cit_loyality", math.Clamp(char:getData("cit_loyality", 0) + tonumber(amount), 0, 100))
			local lp = char:getData("cit_loyality", 0)
			nut.chat.send(client, "headquarters", "Очки поощрения Юниту #"..target:getDigits().." были начислены. Юнит получил "..amount.." очков поощрения. Общее количество: "..lp, false, client)
		else
			char:setData("cit_penalty", math.Clamp(char:getData("cit_penalty", 0) + tonumber(amount), 0, 100))
			local pp = char:getData("cit_penalty", 0)
			nut.chat.send(client, "headquarters", "Очки выговора Юниту #"..target:getDigits().." были начислены. Юнит получил "..amount.." очков выговора. Общее количество: "..pp, false, client)
		end
	end)
end

local function _CheckData(client, target)
	client:EmitSound("npc/combine_soldier/vo/on2.wav")
	local char = target:getChar()

	local lp = char:getData("cit_loyality", 0)
	local pp = char:getData("cit_penalty", 0)
	local civ_wp = char:getData("cit_working", 0)
	local jl_time = char:getData("cit_jail_time", 0)
	local jl_type = char:getData("cit_jail_type", "#N")
	local status = char:getData("cit_status", "NON-CITIZEN")
	local cit_cid = char:getData("cit_cid", 0)

	local wplevel = 0
	if civ_wp >= 220 then
		wplevel = 10
	elseif civ_wp >= 170 then
		wplevel = 9
	elseif civ_wp >= 130 then
		wplevel = 8
	elseif civ_wp >= 90 then
		wplevel = 7
	elseif civ_wp >= 60 then
		wplevel = 6
	elseif civ_wp >= 35 then
		wplevel = 5
	elseif civ_wp >= 20 then
		wplevel = 4
	elseif civ_wp >= 10 then
		wplevel = 3
	elseif civ_wp >= 5 then
		wplevel = 2
	elseif civ_wp >= 0 then
		wplevel = 1
	end

	local lp_level = 0
	if lp >= 100 then
		lp_level = 5
	elseif lp >= 60 then
		lp_level = 4
	elseif lp >= 30 then
		lp_level = 3
	elseif lp >= 10 then
		lp_level = 2
	elseif lp >= 0 then
		lp_level = 1
	end

	local text
	if status == "NON-CITIZEN" then
		text = "не подтвержден"
	elseif status == "CITIZEN" then
		text = "подтвержден"
	elseif status == "ANTICITIZEN" then
		text = "нарушитель"
	end

	timer.Simple(2, function()
		client:EmitSound("npc/combine_soldier/vo/off"..math.random(1, 2)..".wav")

		nut.chat.send(client, "headquarters", "Запрос на информацию Гражданина #"..cit_cid.." был подтвержден.", false, client)

		nut.chat.send(client, "headquarters", "Имя: "..target:Name(), false, client)
		nut.chat.send(client, "headquarters", "CID: #"..cit_cid, false, client)
		nut.chat.send(client, "headquarters", "Очки лояльности: "..lp.." (Уровень: "..lp_level..")", false, client)
		nut.chat.send(client, "headquarters", "Очки нарушений: "..pp, false, client)
		nut.chat.send(client, "headquarters", "Очки рабочего: "..civ_wp.." (Уровень: "..wplevel..")", false, client)
		nut.chat.send(client, "headquarters", "Статус: "..text, false, client)

		if jl_type != "#N" then
			nut.chat.send(client, "headquarters", "Гражданин содержится под стражей", false, client)
			nut.chat.send(client, "headquarters", "Причина задержания: "..jl_type, false, client)
			nut.chat.send(client, "headquarters", "Срок до освобождения: "..jl_time, false, client)
		end
	end)
end

local function _CheckDataCP(client, target)
	client:EmitSound("npc/combine_soldier/vo/on2.wav")
	local char = target:getChar()

	local lp = char:getData("cit_loyality", 0)
	local pp = char:getData("cit_penalty", 0)

	timer.Simple(2, function()
		client:EmitSound("npc/combine_soldier/vo/off"..math.random(1, 2)..".wav")

		if !client:isCombineRank(SCHEMA.eliteRanks) || target:isOTA() || !target:isCombine() then
			nut.chat.send(client, "headquarters", "Запрос на информацию Юнита был отклонен.", false, client)

			return
		else
			nut.chat.send(client, "headquarters", "Запрос на информацию Юнита #"..target:getDigits().." был подтвержден.", false, client)

			nut.chat.send(client, "headquarters", "Номер: #"..target:getDigits(), false, client)
			nut.chat.send(client, "headquarters", "Ранг: "..(target:getCombineRank() || "отсутствует"), false, client)
			nut.chat.send(client, "headquarters", "Отряд: "..target:getCombineDivision(), false, client)
			nut.chat.send(client, "headquarters", "Очки поощрения: "..lp, false, client)
			nut.chat.send(client, "headquarters", "Очки выговора: "..pp, false, client)
		end
	end)
end

nut.command.add("cpinfo", {
	syntax = "<string cid>",
	onRun = function(client, arguments)
		if ((nextUse or 0) < CurTime()) then
			if (!client:isCombine()) then
				return "@notCombine"
			end

			local getall = player.GetAll()
			for _, v in ipairs(getall) do
				local char = v:getChar()
				local data = char:getData("cit_cid", 0)

				if !v:isCombine() then
					local cid = tonumber(arguments[1])
					if (data == cid) then
						nut.chat.send(client, "request_radio", "Центр, запрашиваю данные Гражданина #"..data, false)
						_CheckData(client, v)

						return
					end
				end
			end
			nextUse = CurTime() + 3
		end
	end
})

nut.command.add("uninfo", {
	syntax = "<string digits>",
	onRun = function(client, arguments)
		if ((nextUse or 0) < CurTime()) then
			if (!client:isCombine()) then
				return "@notCombine"
			end 

			local target = nut.command.findPlayer(client, arguments[1])
			local reason = arguments[2]
			local amount = tonumber(arguments[3])
			if !target || target == client then return end
			if !target:isCombine() then return end
			local char = target:getChar()

			if IsValid(target) && char then
				nut.chat.send(client, "request_radio", "Центр, запрашиваю данные Юнита #"..target:getDigits(), false)

				_CheckDataCP(client, target)
			end
			nextUse = CurTime() + 3
		end
	end
})


nut.command.add("cppl", {
	syntax = "<string cid> <string reason> <string amount>",
	onRun = function(client, arguments)
		if ((nextUse or 0) < CurTime()) then
			if (!client:isCombine()) then
				return "@notCombine"
			end

			local getall = player.GetAll()
			for _, v in ipairs(getall) do
				local char = v:getChar()
				local data = char:getData("cit_cid", 0)
				local reason = arguments[2]
				local amount = tonumber(arguments[3])

				if !v:isCombine() then
					local cid = tonumber(arguments[1])
					if (data == cid) then
						if amount > 0 then
							nut.chat.send(client, "request_radio", "Центр, зачислите очки лояльности Гражданину #"..data..". Причина: "..reason..". Количество: "..amount, false)
						else
							nut.chat.send(client, "request_radio", "Центр, урежьте очки лояльности Гражданину #"..data..". Причина: "..reason..". Количество: "..amount, false)
						end

						_setData(client, v, true, amount)

						return
					end
				end
			end
			nextUse = CurTime() + 3
		end
	end
})

nut.command.add("cpupl", {
	syntax = "<string digits> <string reason> <string amount>",
	onRun = function(client, arguments)
		if ((nextUse or 0) < CurTime()) then
			if (!client:isCombine()) then
				return "@notCombine"
			end

			local target = nut.command.findPlayer(client, arguments[1])
			local reason = arguments[2]
			local amount = tonumber(arguments[3])
			if !target || target == client then return end
			if !target:isCombine() then return end
			local char = target:getChar()

			if IsValid(target) && char then
				if amount > 0 then
					nut.chat.send(client, "request_radio", "Центр, зачислите очки поощрения Юниту #"..target:getDigits()..". Причина: "..reason..". Количество: "..amount, false)
				else
					nut.chat.send(client, "request_radio", "Центр, урежьте очки поощрения Юниту #"..target:getDigits()..". Причина: "..reason..". Количество: "..amount, false)
				end

				_setDataCP(client, target, true, amount)
			end
			nextUse = CurTime() + 3
		end
	end
})

nut.command.add("cppv", {
	syntax = "<string cid> <string reason> <string amount>",
	onRun = function(client, arguments)
		if ((nextUse or 0) < CurTime()) then
			if (!client:isCombine()) then
				return "@notCombine"
			end

			local getall = player.GetAll()
			for _, v in ipairs(getall) do
				local char = v:getChar()
				local data = char:getData("cit_cid", 0)
				local reason = arguments[2]
				local amount = tonumber(arguments[3])

				if !v:isCombine() then
					local cid = tonumber(arguments[1])
					if (data == cid) then
						if amount > 0 then
							nut.chat.send(client, "request_radio", "Центр, зачислите очки нарушений Гражданину #"..data..". Причина: "..reason..". Количество: "..amount, false)
						else
							nut.chat.send(client, "request_radio", "Центр, урежьте очки нарушений Гражданину #"..data..". Причина: "..reason..". Количество: "..amount, false)
						end

						_setData(client, v, false, amount)

						return
					end
				end
			end
			nextUse = CurTime() + 3
		end
	end
})

nut.command.add("cpupv", {
	syntax = "<string digits> <string reason> <string amount>",
	onRun = function(client, arguments)
		if ((nextUse or 0) < CurTime()) then
			if (!client:isCombine()) then
				return "@notCombine"
			end

			local target = nut.command.findPlayer(client, arguments[1])
			local reason = arguments[2]
			local amount = tonumber(arguments[3])
			if !target || target == client then return end
			if !target:isCombine() then return end
			local char = target:getChar()

			if IsValid(target) && char then
				if amount > 0 then
					nut.chat.send(client, "request_radio", "Центр, зачислите очки выговора Юниту #"..target:getDigits()..". Причина: "..reason..". Количество: "..amount, false)
				else
					nut.chat.send(client, "request_radio", "Центр, урежьте очки выговора Юниту #"..target:getDigits()..". Причина: "..reason..". Количество: "..amount, false)
				end
				
				_setDataCP(client, target, false, amount)
			end
			nextUse = CurTime() + 3
		end
	end
})

nut.command.add("cpjail", {
	syntax = "<string cid> <string reason> <string amount>",
	onRun = function(client, arguments)
		if ((nextUse or 0) < CurTime()) then
			if (!client:isCombine()) then
				return "@notCombine"
			end

			local getall = player.GetAll()
			for _, v in ipairs(getall) do
				local char = v:getChar()
				local data = char:getData("cit_cid", 0)
				local reason = arguments[2]
				local amount = tonumber(arguments[3])

				if !v:isCombine() then
					local cid = tonumber(arguments[1])
					if (data == cid) then
						nut.chat.send(client, "request_radio", "Запрос изоляции Гражданина #"..data..". Причина: "..reason..". Время изоляции: "..amount.." минут(ы).", false)
						client:EmitSound("npc/combine_soldier/vo/on2.wav")
						timer.Simple(2, function()
							client:EmitSound("npc/combine_soldier/vo/off"..math.random(1, 2)..".wav")

							if char:getData("cit_jail_type", "#N") != "#N" then
								nut.chat.send(client, "headquarters", "Запрос отклонен. Гражданин #"..data.." находится под стражей.", false, client)

								return
							else
								nut.chat.send(client, "headquarters", "Запрос на изоляцию Гражданина #"..data.." подтвержден.", false, client)
								nut.chat.send(client, "headquarters", "Заключенный #"..data.." был помещен под стражу. Причина: "..reason..". Срок заключения: "..(amount).." минут(ы).", false, client)
							end

							char:setData("cit_jail_type", reason)
							char:setData("cit_jail_time", tonumber(amount) * 60)
						end)

						return
					end
				end
			end
			nextUse = CurTime() + 3
		end
	end
})

nut.command.add("cpjailinfo", {
	syntax = "<string cid>",
	onRun = function(client, arguments)
		if ((nextUse or 0) < CurTime()) then
			if (!client:isCombine()) then
				return "@notCombine"
			end

			local getall = player.GetAll()
			for _, v in ipairs(getall) do
				local char = v:getChar()
				local data = char:getData("cit_cid", 0)
				local reason = arguments[2]
				local amount = tonumber(arguments[3])
				local jailtime = char:getData("cit_jail_time", 0)
				local jailtype = char:getData("cit_jail_type", "#N")

				if !v:isCombine() then
					local cid = tonumber(arguments[1])
					if (data == cid) then
						nut.chat.send(client, "request_radio", "Центр, запрашиваю данные Заключенного #"..data, false)
						client:EmitSound("npc/combine_soldier/vo/on2.wav")
							timer.Simple(2, function()
								client:EmitSound("npc/combine_soldier/vo/off"..math.random(1, 2)..".wav")
								if jailtype != "#N" then
									nut.chat.send(client, "headquarters", "Запрос информации о заключенном подтвержден.", false, client)
									nut.chat.send(client, "headquarters", "Заключенный: #"..data..".", false, client)
									nut.chat.send(client, "headquarters", "Причина задержания: "..jailtype, false, client)
									nut.chat.send(client, "headquarters", "Срок (осталось): "..math.Round(tonumber(jailtime) / 60).." минут(ы/а).", false, client)
								else
									nut.chat.send(client, "headquarters", "Запрос информации о заключенном отказан. Гражданин не в изоляции.", false, client)
								end
							end)

						return
					end
				end
			end
			nextUse = CurTime() + 3
		end
	end
})

nut.command.add("cpunjail", {
	syntax = "<string cid>",
	onRun = function(client, arguments)
		if ((nextUse or 0) < CurTime()) then
			if (!client:isCombine()) then
				return "@notCombine"
			end

			local getall = player.GetAll()
			for _, v in ipairs(getall) do
				local char = v:getChar()
				local data = char:getData("cit_cid", 0)
				local reason = arguments[2]
				local amount = tonumber(arguments[3])

				if !v:isCombine() then
					local cid = tonumber(arguments[1])
					if (data == cid) then
						nut.chat.send(client, "request_radio", "Подаю рапорт об освобождении Гражданина #"..data, false)
						client:EmitSound("npc/combine_soldier/vo/on2.wav")
							timer.Simple(2, function()
								client:EmitSound("npc/combine_soldier/vo/off"..math.random(1, 2)..".wav")
								if char:getData("cit_jail_type", "#N") != "#N" then
									char:setData("cit_jail_time", 0)
									char:setData("cit_jail_type", "#N")
									nut.chat.send(client, "headquarters", "Запрос об освобождении заключенного подтвержден.", false, client)
								else
									nut.chat.send(client, "headquarters", "Запрос об освобождении заключенного отказан. Гражданин не в изоляции.", false, client)
								end
							end)
						return
					end
				end
			end
			nextUse = CurTime() + 3
		end
	end
})

nut.command.add("cpstatus", {
	syntax = "<string cid> <string status>",
	onRun = function(client, arguments)
		if ((nextUse or 0) < CurTime()) then
			if (!client:isCombine()) then
				return "@notCombine"
			end

			local getall = player.GetAll()
			for _, v in ipairs(getall) do
				local char = v:getChar()
				local data = char:getData("cit_cid", 0)
				local reason = string.upper(arguments[2])
				local amount = tonumber(arguments[3])
				local status = char:getData("cit_status","NON-CITIZEN")

				if !v:isCombine() then
					local cid = tonumber(arguments[1])
					if (data == cid) then
						nut.chat.send(client, "request_radio", "Запрашиваю смену статуса Гражданина #"..data.." на "..reason..".", false)
						client:EmitSound("npc/combine_soldier/vo/on2.wav")
							timer.Simple(2, function()
								client:EmitSound("npc/combine_soldier/vo/off"..math.random(1, 2)..".wav")
								if reason == "ANTICITIZEN" || reason == "NON-CITIZEN" || reason == "CITIZEN" then
									if reason == "ANTICITIZEN" then
										nut.chat.send(client, "headquarters", "Статус Гражданина #"..data.." изменен на "..reason..".", false, client)
										nut.chat.send(client, "dispatch", "Гражданин #"..data..". Вы обвиняетесь в тяжком несоответствии. Асоциальный статус подтвержден.", true)
										BroadcastLua("LocalPlayer():EmitSound('npc/overwatch/cityvoice/f_capitalmalcompliance_spkr.wav')")
										char:setData("cit_status", reason)

										return
									end

									nut.chat.send(client, "headquarters", "Статус Гражданина #"..data.." изменен на "..reason..".", false, client)
									char:setData("cit_status", reason)
								else
									nut.chat.send(client, "headquarters", "В изменении статуса отказано. Причина: Некорректный запрос.", false, client)
								end
							end)
						return
					end
				end
			end
			nextUse = CurTime() + 3
		end
	end
})

nut.command.add("visorstatus", {
	syntax = "<string status>",
	onRun = function(client, arguments)
		if ((nextUse or 0) < CurTime()) then
			if (!client:isCombine()) then
				return "@notCombine"
			end

			local status = string.upper(arguments[1])

			local getall = player.GetAll()
			for _, v in ipairs(getall) do
				if IsValid(v) && v:getChar() then
					if client:isCombineRank(SCHEMA.eliteRanks) then
						if status == "GREEN" then
							v:addDisplay("!ATT: Статус социальной стабильности обновлен. Код: Зеленый;", Color(0, 255, 0))
						elseif status == "YELLOW" then
							v:addDisplay("!ATT: Статус социальной стабильности обновлен. Код: Желтый;", Color(255, 255, 10))
						elseif status == "RED" then
							v:addDisplay("!ATT: Статус социальной стабильности обновлен. Код: Красный;", Color(255, 10, 0))
						else
							client:notify("Нет такого статуса")

							return
						end
					else
						client:notify("Только Высшее командование имеет возможность менять статус")

						return
					end
				end
			end
			nextUse = CurTime() + 3
		end
	end
})

nut.command.add("visornotify", {
	syntax = "<int code>",
	onRun = function(client, arguments)
		if ((nextUse or 0) < CurTime()) then
			if (!client:isCombine()) then
				return "@notCombine"
			end

			local code = arguments[1]

			local getall = player.GetAll()
			for _, v in ipairs(getall) do
				if IsValid(v) && v:getChar() then
					if v:isCombine() then
						if code == "10-8" then
							v:addDisplay("Юнит #"..client:getDigits().." выходит на связь. Код 10-8;", Color(20, 255, 20))
						elseif code == "10-7" then
							v:addDisplay("Юнит #"..client:getDigits().." покидает пост. Код 10-7;", Color(80, 150, 20))
						end
					end
				end
			end
			nextUse = CurTime() + 3
		end
	end
})

nut.command.add("visorbackup", {
	onRun = function(client, arguments)
		if ((nextUse or 0) < CurTime()) then
			if (!client:isCombine()) then
				return "@notCombine"
			end

			local getall = player.GetAll()
			for _, v in ipairs(getall) do
				if IsValid(v) && v:getChar() then
					if v:isCombine() then
						v:addDisplay("!ATT: Юнит #"..client:getDigits().." Запрашивает помощь;", Color(255, 10, 0))
						v:addDisplay("!ATT: Коориданты Юнита #"..client:getDigits()..": "..math.floor(client:GetPos()[1])..", "..math.floor(client:GetPos()[2])..", "..math.floor(client:GetPos()[3])..";", Color(255, 10, 0))
					end
				end
			end
			nextUse = CurTime() + 3
		end
	end
})