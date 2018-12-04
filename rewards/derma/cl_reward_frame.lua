local plugin = PLUGIN
local font = 'nutSmallFont'

local color_button_delete = Color(255, 0, 0)
local color_input_background = Color(0, 0, 0, 120)
local color_input_highlight = Color(80, 80, 80)

local function add_reward(panel, data)
	local base_panel = panel:Add('DPanel')
	base_panel:Dock(TOP)
	base_panel:DockMargin(2, 2, 2, 2)

	base_panel.label = base_panel:Add('DLabel')
	base_panel.label:Dock(LEFT)
	base_panel.label:DockMargin(2, 2, 2, 2)
	base_panel.label:SetFont(font)
	base_panel.label:SetColor(color_white)
	base_panel.label:SetText(data.name..':')
	base_panel.label:SizeToContentsX()

	base_panel.input = base_panel:Add('DTextEntry')
	base_panel.input:Dock(LEFT)
	base_panel.input:DockMargin(2, 2, 2, 2)
	base_panel.input:SetNumeric(true)
	base_panel.input:SetText(panel.m_selected[data.id].value)
	base_panel.input:SetPlaceholderText('0 / 100')
	base_panel.input:SetUpdateOnType(true)
	base_panel.input:SetEnterAllowed(false)
	base_panel.input.OnLoseFocus = function(this)
		local value = math.Clamp(tonumber(tonumber(this:GetValue())) or 0, 0, 100)
		this:SetText(value)

		panel.m_selected[data.id].value = value
	end

	base_panel.input.OnValueChange = function(this, value)
		value = math.Clamp(tonumber(value) or 0, 0, 100)
	end

	base_panel.input.Paint = function(this, width, height)
		surface.SetDrawColor(color_input_background)
		surface.DrawRect(0, 0, width, height)

		this:DrawTextEntryText(color_white, color_input_highlight, color_white)
	end

	base_panel.delete = base_panel:Add('DButton')
	base_panel.delete:Dock(RIGHT)
	base_panel.delete:DockMargin(2, 2, 4, 2)
	base_panel.delete:SetFont(font)
	base_panel.delete:SetColor(color_button_delete)
	base_panel.delete:SetText('REMOVE')
	base_panel.delete:SizeToContentsX()
	base_panel.delete:SetDrawBackground(false)
	base_panel.delete.DoClick = function(this)
		panel.m_selected[data.id] = nil
		panel:SetTall(panel:GetTall() - base_panel:GetTall() - 4)

		base_panel:Remove()
	end

	panel:SetTall(panel:GetTall() + base_panel:GetTall() + 4)
end

local PANEL = {}

function PANEL:Init()
	if IsValid(nut.gui.reward) then nut.gui.reward:Remove() end
	nut.gui.reward = self

	local scrw, scrh = ScrW(), ScrH()
	self:SetSize(scrw * .261, scrh * .125)
	self:Center()
	self:MakePopup()
	self.m_item = {}
	self.m_selected = {}

	self.reward_types = self:Add('DButton')
	self.reward_types:Dock(TOP)
	self.reward_types:DockMargin(2, 2, 2, 2)
	self.reward_types:SetTextColor(color_white)
	self.reward_types:SetFont(font)
	self.reward_types:SetText('Rewards')
	self.reward_types.DoClick = function(this)
		local derma_menu = DermaMenu()

		for index, data in pairs(plugin.get_rewards()) do
			if self.m_selected[data.id] then continue end

			derma_menu:AddOption(data.name, function()
				self.m_selected[data.id] = {name = data.name, value = 0}

				add_reward(self, data)
			end)
		end

		derma_menu:Open()
	end

	local accept_button = self:Add('DButton')
	accept_button:Dock(BOTTOM)
	accept_button:DockMargin(2, 2, 2, 2)
	accept_button:SetTextColor(color_white)
	accept_button:SetFont(font)
	accept_button:SetText('ACCEPT')
	accept_button.DoClick = function(this)
		if next(self.m_selected) then
			netstream.Start('reward_set_item_data', self.m_item, self.m_selected)

			self:SetVisible(false)
			self:Remove()
		end
	end
end

function PANEL:set_item(item)
	self.m_item = item
end

vgui.Register('vgui_reward', PANEL, 'DFrame')

netstream.Hook('reward_frame_open', function(item)
	local base_panel = vgui.Create('vgui_reward')
	base_panel:set_item(item)
end)