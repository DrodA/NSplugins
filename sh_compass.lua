local plugin = PLUGIN
plugin.name = "Compass"
plugin.author = "DrodA"
plugin.desc = "Adds Compass on your HUD"
plugin.compassText = {}

if (SERVER) then return end

plugin.compassText[0] = "N"
plugin.compassText[45] = "NW"
plugin.compassText[90] = "W"
plugin.compassText[135] = "SW"
plugin.compassText[180] = "S"
plugin.compassText[-180] = "S"
plugin.compassText[-135] = "SE"
plugin.compassText[-90] = "E"
plugin.compassText[-45] = "NE"

NUT_CVAR_COMPASS = CreateClientConVar("nut_compass", 1, true, true)

local color_background = Color(0, 0, 0, 180)
local offset = 39
function plugin:HUDPaint()
	local scrW, scrH = ScrW(), ScrH()

	local client = LocalPlayer()
	if !IsValid(client) or !client:Alive() then return end
	if (NUT_CVAR_COMPASS:GetBool() == false) then return end

	local w, h = scrW * .4, 30
	local x, y = (scrW * .5) - (w * .5), scrH - h

	draw.RoundedBox(8, x, y, w, h, color_background)

	local finalText = ""
	local yaw = math.floor(client:GetAngles().y)

	for i = yaw - offset, yaw + offset do
		local y = i
		if i > 180 then
			y = -360 + i
		elseif i < -180 then
			y = 360 + i
		end

		finalText = (self.compassText[y] and self.compassText[y]..finalText) or " "..finalText
	end

	draw.DrawText(finalText, "nutMediumFont", x, y, color_white)
end

function plugin:SetupQuickMenu(menu)
	local buttonCompass = menu:addCheck("Toggle compass", function(panel, state)
		RunConsoleCommand("nut_compass", state and "1" or "0")
	end, NUT_CVAR_COMPASS:GetBool())

	menu:addSpacer()
end
