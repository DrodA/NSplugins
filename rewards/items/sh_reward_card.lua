local plugin = PLUGIN

ITEM.name = 'Reward card'
ITEM.desc = 'Looks like a fancy plastic card'
ITEM.model = 'models/gibs/metal_gib4.mdl'
ITEM.is_reward_card = true

ITEM.functions.dataSet =
{
	name = 'Set data',
	tip = 'Set data',
	icon = 'icon16/add.png',
	onRun = function(item)
		netstream.Start(item.player, 'reward_frame_open', item)

		return false
	end,
	onCanRun = function(item)
		return !IsValid(item.entity) and (plugin.allowed_factions[item.player:Team()] or false)
	end
}

function ITEM:get_rewards()
	return self:getData('rewards', {})
end

function ITEM:get_reward(identifier)
	return self:get_rewards()[identifier]
end

function ITEM:set_rewards(data)
	hook.Run('on_set_item_rewards', self, data)
	
	return self:setData('rewards', data)
end

function ITEM:getDesc()
	local description = self.desc

	if next(self:get_rewards()) and !IsValid(self.entity) then
		description = description..'\n\nThis card has a next rewards:'

		for k, v in pairs(self:get_rewards()) do
			-- if v.value == 0 then continue end

			description = description..'\n'..v.name..': '..v.value..' / 100'
		end
	end

	return description
end