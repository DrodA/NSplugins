local plugin = PLUGIN

--[[-------------------------------------------------------------------------
EXAMPLE

plugin.reward_register(
	'reward_id',
	'reward_name',
	function(client, amount)
		print 'reward_callback'
	end
)
---------------------------------------------------------------------------]]

plugin.reward_register(
	'example_id',
	'Example Heal',
	function(client, amount)
		client:SetHealth(math.Clamp(client:Health() + amount, 1, 100))
	end
)

plugin.reward_register(
	'tokens',
	'Tokens',
	function(client, amount)
		client:getChar():giveMoney(amount, false)
	end
)
