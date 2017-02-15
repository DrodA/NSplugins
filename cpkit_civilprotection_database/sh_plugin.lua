PLUGIN.name = "Data module [hl2rp] | simplified version"
PLUGIN.author = "CW: kurozael, Schwarz Kruppzo | NS: Robby, DrodA, AleXXX_007"
PLUGIN.desc = "Adds new (old) branded flexible Civil Protection system."

nut.util.include("sh_commands.lua")
nut.util.include("sh_bonus_meta.lua")

local headquarters_color = Color(100, 255, 50)
local RADIO_CHATCOLOR = Color(100, 255, 50)

local config_container = {
	City = "C17-I"
}

/*
nut.chat.register("Cityinfo", {
	font = "nutRadioFont",
	onCanSay =  function(speaker, text)
		return (speaker:IsAdmin() || speaker:isCombine())
	end,
	onCanHear = 1000000,
	onChatAdd = function(speaker, text)
		if speaker:isCombine() then chat.AddText(headquarters_color, "Информационная система "..config_container.City..": "..text) return end

		chat.AddText(headquarters_color, "Информационная система "..config_container.City..": <:: "..text.." ::>")
	end,
	prefix = {"/info"}
})
*/

nut.chat.register("headquarters", {
	font = "nutRadioFont",
	onCanSay =  function(speaker, text)
		return speaker:isCombine()
	end,
	onCanHear = function(speaker, listener)
		return (speaker:isCombine() && listener:isCombine())
	end,
	onChatAdd = function(speaker, text)
		chat.AddText(RADIO_CHATCOLOR, "Центр "..config_container.City..": "..text)
	end,
})

nut.chat.register("request_radio", {
	font = "nutRadioFont",
	onCanSay =  function(speaker, text)
		return speaker:isCombine()
	end,
	onCanHear = function(speaker, listener)
		local dist = speaker:GetPos():Distance(listener:GetPos())
		local speakRange = nut.config.get("chatRange", 280)

		if (dist <= speakRange) || (speaker:isCombine() && speaker:isCombine()) then
			return true
		end

		return false
	end,
	onChatAdd = function(speaker, text)
		chat.AddText(RADIO_CHATCOLOR, speaker:Name().." Передает в рацию: "..text)
	end,
})

nut.chat.register("local_dispatch", {
	color = Color(192, 57, 43),
	onCanSay = function(client)
		if (!client:isCombine()) then
			client:notifyLocalized("notAllowed")

			return false
		end
	end,
	
	onChatAdd = function(speaker, text)
		chat.AddText(Color(192, 57, 43), L("icFormat", "Dispatch", text))
	end,
})

function PLUGIN:PostPlayerLoadout(c)
	local combine = c:isCombine()
	local _char = c:getChar()
	if _char && !_char:getData("status", "#N") then
		if !combine then
			_char:setData("cit_cid", 0)
			_char:setData("cit_loyality", 0)
			_char:setData("cit_penalty", 0)
			_char:setData("cit_working", 0)
			_char:setData("cit_jail_time", 0)
			_char:setData("cit_jail_type", "#N")
			_char:setData("cit_status", "NON-CITIZEN")
		else
			_char:setData("cit_loyality", 0)
			_char:setData("cit_penalty", 0)
		end
	end
	--nut.chat.send(c, "Cityinfo", "Гражданин "..c:Nick()..", Альянс приветствует вас в "..config_container.City..".", false, c)
end

if SERVER then
	function PLUGIN:Think()
		local getall = player.GetAll()
		local getall_comb = player.GetAll()

		for _, v in ipairs(getall) do
			local char = v:getChar()
			if !char then return end

			if (char:getData("cit_cid") == 0 || !char:getData("cit_cid") && !v:isCombine()) then
				char:setData("cit_cid", math.random(10000, 99999))
				MsgC(Color(0, 255, 0), "[DATA] New CID sets for "..v:Name()..". CID: "..char:getData("cit_cid", 0).."\n")
			end

			if !v.isolationTimer || CurTime() >= v.isolationTimer then
				if !v:isCombine() then
					if char:getData("cit_jail_type", "#N") != "#N" &&  char:getData("cit_jail_time", 0) > 0 then	
						char:setData("cit_jail_time",  char:getData("cit_jail_time", 0) - 1)
					end
				end
				v.isolationTimer = CurTime() + 1
			end

			if !v.isolationRemind || CurTime() >= v.isolationRemind then
				if !v:isCombine() then
					if char:getData("cit_jail_type", "#N") != "#N" &&  char:getData("cit_jail_time", 0) == 0 then	
						for _, combine in ipairs(getall_comb) do
							if combine:Alive() && combine:getChar() then
								if combine:isCombine() then
									combine:addDisplay("Изоляция Заключенного #"..v:getChar():getData("cit_cid", 0).." завершена, освободить Гражданина.", Color(0, 255, 0))
								end
							end
						end
					end
				end
				v.isolationRemind = CurTime() + 40
			end
		end
	end
end

nut.command.add("apply", {
	onRun = function(client)
		if client:isCombine() then return end
		local char = client:getChar()

		if char then
			nut.chat.send(client, "ic", client:Name()..", #"..char:getData("cit_cid", 0))
		end
	end
})

function PLUGIN:SaveData()
	local data = {}
		for k, v in ipairs(ents.FindByClass("nut_combinemonitor")) do
			data[#data + 1] =
			{
				pos = v:GetPos(),
				angles = v:GetAngles(),
			}
		end

	self:setData(data)
end

function PLUGIN:LoadData()
	for k, v in ipairs(self:getData() or {}) do
		local entity = ents.Create("nut_combinemonitor")
		entity:SetPos(v.pos)
		entity:SetAngles(v.angles)
		entity:Spawn()
	end
end

hook.Add("BuildHelpMenu", "moduleCPsystem", function(tabs)
	tabs["Civil Protection Database"] = function(node)
		local body = ""
		body = (body..[[
			<html>
			 <head>
			  <meta charset="utf-8">
			  <title>font-family</title>
			  <style>
  				body { background-color: #000000; }
			   h1 {
			    font-family: Consolas;
			   } 
			   p {
			    font-family: Consolas;
			   }
			   info {
			   		font-family: Terminal;
				}
			  </style>
			 </head> 
			 <body> 
			 <font color="#008000">
			  <center><h1>Система базы данных Гражданской Обороны</h1></center>
			  <p><b>&nbsp;&nbsp;&nbsp;Система базы данных Гражданской Обороны</b> (Далее - БД ГО) - это система модульных данных, 
				представляющих из себя наиболее удобное и практическое решение для ведения отчетности
				среди гражданского населения и, непосредственно, самой Гражданской Обороны.<br>
				&nbsp;&nbsp;&nbsp;Данная система является своего рода помощником и, как таковой, неплохой начинкой к сборке (Уникально, красиво, технологично).<br>
				&nbsp;&nbsp;&nbsp;Методом использования системы является «Команда-запрос», которая вызвается Юнитом Гражданской Обороны при той, или иной ситуации.<br>
				<br>
				<center><h1>Описание существующих команд</h1></center>
				<center><h1>База Гражданской Обороны</h1></center>
				<ul>
				<li>/cpinfo <Имя персонажа> - узнать все данные персонажа;</li>
				  <br>
				<li>/cpuinfo <Имя персонажа> - узнать все данные Юнита;</li>
				  <br>
				  <li>/cppl <Имя персонажа> <Причина> <Кол-во> - зачислить персонажу очки лояльности;</li>
				  <br>
				  <li>/cpupl <Имя персонажа> <Причина> <Кол-во> - зачислить Юниту очки поощрения;</li>
				  <br>
				  <li>/cppv <Имя персонажа> <Причина> <Кол-во> - зачислить персонажу очки нарушений;</li>
				  <br>
				  <li>/cpupv <Имя персонажа> <Причина> <Кол-во> - зачислить Юниту очки выговора;</li>
				  <br>
				  <li>/cpjail <Имя персонажа> <Причина> <Кол-во> - запросить изоляцию персонажа;</li>
				  <br>
				  <li>/cpjailinfo <Имя персонажа> - узнать данные заключенного (срок, причина и тд);</li>
				  <br>
				  <li>/cpunjail <Имя персонажа> - подача рапорта об освобождении гражданина из под стражи;</li>
				  <br>
				  <li>/cpstatus <Имя персонажа> <Статус> - изменение статуса персонажа (non-citizen, citizen, anticitizen);</li>
				  <br>
				</ul>
				<center><h1>Визор Гражданской Обороны</h1></center>
				<ul>
				<li>/visorstatus <Статус> - задать общий статус среди Гражданской Обороны (green, yellow, red). Только для высшего командования;</li>
				<br>
				<li>/visornotify <Код> - объявить о своем уходе/приходе на пост (10-8, 10-7);</li>
				<br>
				<li>/visorbackup - статичный запрос о помощи;</li>
				<br>
				</ul>
				<center><h1>Дополнительная информация</h1></center></p>
				<info align="center">&nbsp;&nbsp;&nbsp;<b>Комплект «CP's big boro»</b> - это целый набор систем для Гражданской Обороны,
				в которой имеется множество лаконичных и не очень настроек, которые сделают из ваших Юнитов полноценных боевых единиц,
				которые смогут не только махать дубинкой, да показывать свое ЧСВ и без того бедным гражданам,
				но и использовать все свои технологии максимально эффективно. Тепловизор? Ночное видение? Визоры, отделяющих своих от врагов?
				Это, и многое другое скрыто от ваших слюнявых морд в комплекте «CP's big boro» всего за 99.99$ (или просто реквестируйте свою хотелку автору NS плагина).<br>
				<br>
				Команда <b>/apply</b> - мелкий бонус для тех, кому не хватает легкой атмосферы CW.
				<br>
				<center>БД ГО входит в комплект «CP's big boro», но идет отдельно от него.</center>
				</font></info>
			 </body>
			</html>
		]])
		
		return body
	end
end)
