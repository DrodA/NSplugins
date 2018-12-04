local plugin = PLUGIN
plugin.name = 'Rewards'
plugin.author = 'DrodA, Hiku'
plugin.desc = 'Adds flexible reward system'
plugin.version = 1.0
plugin.rewards = {}

plugin.allowed_factions = {}
plugin.allowed_factions[FACTION_CP] = true

function plugin.get_rewards()
	return plugin.rewards
end

function plugin.reward_register(reward_id, reward_name, reward_callback)
	plugin.rewards[reward_id] =
	{
		id = reward_id,
		name = reward_name,
		callback = reward_callback
	}
end

nut.util.include('sv_plugin.lua', 'server')
nut.util.include('sh_rewards.lua', 'shared')