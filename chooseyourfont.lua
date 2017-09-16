local PLUGIN = PLUGIN;
PLUGIN.name = "Choose Your Font, Sir.";
PLUGIN.author = "AleXXX_007, DrodA"; // github.com/xAleXXX007x/Witcher-RolePlay
PLUGIN.desc = "Fix it, Alexerino | Request by NexXer";
PLUGIN.Fonts =
{
	[1] =
	{
		name = "El Standarterino",
		font = "Arial"
	},

	[2] =
	{
		name = "El differenterino",
		font = "Trebuchet24"
	}
};

if (CLIENT) then
	local PANEL = {};

	function PANEL:Init()
		local client = LocalPlayer();

		self:SetTitle("Choose Your Font, Sir");
		self:SetSize(300, 60);
		self:Center();
		self:MakePopup();
		self:SetDraggable(false);

		self.ListPanel = self:Add("DPanel");
		self.ListPanel:Dock(FILL);
		self.ListPanel.Settings = self.ListPanel:Add("DComboBox");
		self.ListPanel.Settings:Dock(TOP);

		for k, v in ipairs(PLUGIN.Fonts) do
			self.ListPanel.Settings:AddChoice(v.name, v.font);
		end;

		self.ListPanel.Settings.OnSelect = function(s, index, value, data)
			hook.Run("LoadFonts", data);
			client:ChatPrint("You are selected a "..data.." font");
		end;

		self.Paint = function(s, w, h)
			surface.SetDrawColor(Color(40, 40, 40, 150));
			surface.DrawRect(0, 0, w, h);

			surface.SetDrawColor(nut.config.get("color"));
			surface.DrawOutlinedRect(0, 0, w, h);
		end;
	end;
	vgui.Register("nutFontSel", PANEL, "DFrame");

	function PLUGIN:SetupQuickMenu(menu)
		menu:addButton("Fonts", function()
			if (nut.gui.fontsel and nut.gui.fontsel:IsVisible()) then
				nut.gui.fontsel:Close();
				nut.gui.fontsel = nil;
			end;

			nut.gui.fontsel = vgui.Create("nutFontSel");
		end);
	end;
end;
