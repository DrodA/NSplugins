local plugin = PLUGIN

function plugin:SaveData()
	local save_data = {}

	for index, data in ipairs(ents.FindByClass('nut_reward_terminal')) do
		save_data[#save_data + 1] =
		{
			position = data:GetPos(),
			angles = data:GetAngles(),
			activity = data:get_activity()
		}
	end

	self:setData(save_data)
end

function plugin:LoadData()
	for index, data in ipairs(self:getData() or {}) do
		local entity = ents.Create('nut_reward_terminal')
		entity:SetPos(data.position)
		entity:SetAngles(data.angles)
		entity:Spawn()
		entity:set_activity(data.activity)
	end
end

netstream.Hook('reward_set_item_data', function(client, item_data, reward_data)
	if !plugin.allowed_factions[client:Team()] then return end
	
	nut.item.instances[item_data.id]:set_rewards(reward_data)
end)