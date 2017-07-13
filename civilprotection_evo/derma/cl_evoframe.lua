local PANEL = {};

function PANEL:Init()
	self:SetTextColor(Color(180, 180, 180, 255));
	self:SetWide(225);
	self:DockMargin(5, 2.5, 5, 2.5);

	self.MetroColor = color_white;
	self.ButtonColor = Color(47, 47, 47, 255);

	self.Paint = function(s, w, h)
		surface.SetDrawColor(self.ButtonColor);
		surface.DrawRect(0, 0, w, h);

		surface.SetDrawColor(self.MetroColor);
		surface.DrawRect(0, h - 2, w, 2);
	end;

	self.OnCursorEntered = function(s, w, h)
		self.ButtonColor = Color(38, 38, 38, 255);
	end;

	self.OnCursorExited = function(s, w, h)
		self.ButtonColor = Color(47, 47, 47, 255);
	end;
end;

function PANEL:SetMetroColor(color)
	self.MetroColor = color;
end;
vgui.Register("EVOButton", PANEL, "DButton");

local function AddButtons(self)
	self.dButtons = self:Add("DPanel");
	self.dButtons:Dock(BOTTOM);
	self.dButtons:SetTall(35);
	self.dButtons.Paint = function(s, w, h)
		surface.SetDrawColor(Color(40, 40, 40, 255));
		surface.DrawRect(0, 0, w, h);
	end;

	self.uLeftButton = self.dButtons:Add("EVOButton");
	self.uLeftButton:SetText(L("EVOFrameNames"));
	self.uLeftButton:Dock(LEFT);
	self.uLeftButton.DoClick = function(s) NUT_CVAR_NAMES:SetBool(!NUT_CVAR_NAMES:GetBool()) end;

	self.uLeftButton.Think = function(s)
		if NUT_CVAR_NAMES:GetBool() then
			s:SetMetroColor(Color(41, 128, 185, 255));
		else
			s:SetMetroColor(color_white);
		end;
	end;

	self.uMiddleButton = self.dButtons:Add("EVOButton");
	self.uMiddleButton:SetText(L("EVOFramePrimaryDetection"));
	self.uMiddleButton:Dock(FILL);
	self.uMiddleButton.DoClick = function(s) NUT_CVAR_HUD:SetBool(!NUT_CVAR_HUD:GetBool()) end;

	self.uMiddleButton.Think = function(s)
		if NUT_CVAR_HUD:GetBool() then
			s:SetMetroColor(Color(231, 76, 60, 255));
		else
			s:SetMetroColor(color_white);
		end;
	end;

	self.uRightButton = self.dButtons:Add("EVOButton");
	self.uRightButton:SetText(L("EVOFrameSecondaryDetection"));
	self.uRightButton:Dock(RIGHT);
	self.uRightButton.DoClick = function(s) NUT_CVAR_OUTLINES:SetBool(!NUT_CVAR_OUTLINES:GetBool()) end;

	self.uRightButton.Think = function(s)
		if NUT_CVAR_OUTLINES:GetBool() then
			s:SetMetroColor(Color(39, 174, 96));
		else
			s:SetMetroColor(color_white);
		end;
	end;
end;

concommand.Add("evo_settings", function()
	if !LocalPlayer():isCombine() then return end;

	local Frame = vgui.Create("DFrame");

	Frame:SetPos((surface.ScreenWidth()/2) - 350,(surface.ScreenHeight()/2) - 350);
	Frame:SetSize(700, 120);
	Frame:SetTitle("")
	Frame:SetBackgroundBlur(true);
	Frame:SetDraggable(true)
	Frame:MakePopup();
	Frame:Center();

	Frame.TopPanel = Frame:Add("DPanel");
	Frame.TopPanel:Dock(TOP);
	Frame.TopPanel:SetTall(85);
	Frame.TopPanel.Paint = function(s, w, h)
		surface.SetDrawColor(Color(40, 40, 40, 255));
		surface.DrawRect(0, 0, w, h);
	end;

	Frame.NameLabel = Frame.TopPanel:Add("DLabel");
	Frame.NameLabel:SetTextColor(color_white);
	Frame.NameLabel:SetFont("DermaLarge");
	Frame.NameLabel:SetText(L("EVOFrameNameLabel"));
	Frame.NameLabel:Dock(TOP);
	Frame.NameLabel:DockMargin(0, 10, 0, 0);
	Frame.NameLabel:SetContentAlignment(5)
	Frame.NameLabel:SizeToContents(true);

	AddButtons(Frame);

	Frame.Paint = function(s, w, h)
		surface.SetDrawColor(Color(40, 40, 40, 150));
		surface.DrawRect(0, 0, w, h);

		surface.SetDrawColor(Color(170, 170, 170, 255));
		surface.DrawOutlinedRect(0, 0, w, h);
	end;
end);