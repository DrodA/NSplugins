local PLUGIN = PLUGIN

PLUGIN.CivilProtection.City 			= "C17"
PLUGIN.CivilProtection.InEmitSound 		= "npc/combine_soldier/vo/on2.wav"
PLUGIN.CivilProtection.OutEmitSound 	= "npc/combine_soldier/vo/off"..math.random(1, 2)..".wav"
PLUGIN.CivilProtection.CallBackTimer	= 2
PLUGIN.CivilProtection.CallDelay 		= 3
PLUGIN.CivilProtection.MaximumLoyality	= 100
PLUGIN.CivilProtection.MaximumPenalty 	= 100
PLUGIN.CivilProtection.CIDLength 		= 5
PLUGIN.CivilProtection.AllowedFactions 	=
{
	[FACTION_CITIZEN] = true,
	[FACTION_ADMIN] = true,
	[FACTION_CWU] = true
}

PLUGIN.CivilProtection.Colors =
{
	Headquarters = Color(100, 255, 50),
	RadioChat = Color(100, 255, 50),
	LocalDispatch = Color(192, 57, 43),
	IsolationDisplay = Color(0, 255, 0)
}

if (CLIENT) then
	hook.Add("BuildHelpMenu", "PLUGIN.CivilProtection.InfoModule", function(tabs)
		tabs["Civil Protection Database"] = function(node)
			local body = ""
			body = (body..[[
				<html>
					<head>
						<meta charset="utf-8">
						<style>
							body { background-color: #000000; }
							h1
							{
								font-family: Consolas;
							}

							p
							{
								font-family: Consolas;
							}

							info
							{
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
							<li>/getinfo <Имя персонажа> - узнать все данные персонажа;</li>
						<br>
							<li>/setloyality <Имя персонажа> <Причина> <Кол-во> - зачислить персонажу очки лояльности;</li>
						<br>
							<li>/setpenalty <Имя персонажа> <Причина> <Кол-во> - зачислить персонажу очки нарушений;</li>
						<br>
							<li>/setjail <Имя персонажа> <Причина> <Кол-во> - запросить изоляцию персонажа;</li>
						<br>
							<li>/infojail <Имя персонажа> - узнать данные заключенного (срок, причина и тд);</li>
						<br>
							<li>/releasejail <Имя персонажа> - подача рапорта об освобождении гражданина из под стражи;</li>
						<br>
							<li>/setstatus <Имя персонажа> <Статус> - изменение статуса персонажа (non-citizen, citizen, anticitizen);</li>
						<br>
							<li>/apartmentslist <Номер апартаментов> - узнать всех жильцов апартаментов;</li>
						<br>
							<li>/setapartments <Номер апартаментов> - задать гражданину жилье;</li>
						</ul>

						<center><h1>Дополнительная информация</h1></center></p>

						<info align="center">&nbsp;&nbsp;&nbsp;<b>Комлпект «CP's big boro»</b> - это целый набор систем для Гражданской Обороны,
						в которой имеется множество лаконичных и не очень настроек, которые сделают из ваших Юнитов полноценных боевых единиц,
						которые смогут не только махать дубинкой, да показывать свое ЧСВ и без того бедным гражданам,
						но и использовать все свои технологии максимально эффективно. Тепловизор? Ночное видение? Визоры, отделяющих своих от врагов?
						Это, и многое другое скрыто от ваших слюнявых морд в комплекте «CP's big boro» всего за 99.99$ (или просто реквестируйте свою хотелку автору NS плагина).<br>
						<br>
						Команда <b>/apply</b> - мелкий бонус для тех, кому не хватает легкой атмосферы CW.
						<br>

						<center><h1>Связь с автором</h1></center></p>

						<p><b>
						GitHub: https://github.com/DrodA<br>
						Steam: http://steamcommunity.com/id/MSoderberg<br>
						<br>
						</font></info>
					</body>
				</html>
			]])
			
			return body
		end
	end)
end