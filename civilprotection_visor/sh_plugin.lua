PLUGIN.name = "New (old) display [Civil Protection]";
PLUGIN.author = "DrodA";
PLUGIN.desc = "Adds some shity dislay";

SCHEMA.displays = {};
SCHEMA.NextRandomLineTime = 24;

if (CLIENT) then
	surface.CreateFont( "VisorFont",
	{
		font = "BudgetLabel",
		size = 16,
		weight = 250,
		blursize = 0,
		scanlines = 0,
		antialias = false,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = true
	});

	function SCHEMA:HUDPaint()
		SCHEMA.randomDisplayLines =
		{
			L("DisplayLines_1"),
			L("DisplayLines_2"),
			L("DisplayLines_3"),
			L("DisplayLines_4"),
			L("DisplayLines_5"),
			L("DisplayLines_6"),
			L("DisplayLines_7"),
			L("DisplayLines_8"),
			L("DisplayLines_9"),
			L("DisplayLines_10"),
			L("DisplayLines_11"),
			L("DisplayLines_12"),
			L("DisplayLines_13"),
			L("DisplayLines_14"),
			L("DisplayLines_15")
		};

		local scrW, scrH = ScrW(), ScrH();

		local client = LocalPlayer();
		local isCombine = client:isCombine();

		if (isCombine and !IsValid(nut.gui.char)) then
			local x, y = 8, 20;
			local w, h = scrW * 0.5, scrH * 0.2;
			local color = color_white;

			for i = 1, #self.displays do
				local data = self.displays[i];

				if (data) then
					local y2 = y + (i * 22);

					if ((i * 22 + 24) > h) then table.remove(self.displays, 1) end;

					if (#data.realText != #data.text) then
						data.i = (data.i or 0) + 0.4;
						data.realText = data.text:sub(1, data.i);
					end;

					draw.SimpleText("<:: "..data.realText, "VisorFont", x + 8, y2 + 12, data.color);
				end;
			end;
		end;
	end;

	function SCHEMA:Tick()
		local curTime = CurTime();

		local client = LocalPlayer();

		if (IsValid(client) and client:isCombine()) then
			if (!self.nextRandomLine or curTime >= self.nextRandomLine) then
				local text = self.randomDisplayLines[math.random(1, #self.randomDisplayLines)];

				if (text && self.lastRandomDisplayLine != text) then
					self:addDisplay(text);

					self.lastRandomDisplayLine = text;
				end;

				self.nextRandomLine = curTime + SCHEMA.NextRandomLineTime;
			end;
		end;
	end;

	function SCHEMA:addDisplay(text, color)
		local client = LocalPlayer();

		if (client:isCombine()) then
			color = color or color_white;
			SCHEMA.displays[#SCHEMA.displays + 1] = {text = tostring(text), color = color, realText = ""};

			client:EmitSound("buttons/button16.wav", 30, 120);
		end;
	end;
end;