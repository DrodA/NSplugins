local PLUGIN = PLUGIN;

PLUGIN.name = "Emote Moods";
PLUGIN.author = "OA: Spencer Sharkey, NS: DrodA";
PLUGIN.desc = "With this plugin, characters can set their mood to a preset from predefined values. [Beware! Bugs!]";
PLUGIN.PersonalityTypes =
{
	"Default",
	"Relaxed",
	"Headstrong",
	"Frustrated"
};

PLUGIN.LookupTable = {};
PLUGIN.LookupTable[ "Relaxed" ] =
{ 
	["idle"] = "LineIdle01",
	["walk"] = "walk_all_Moderate"
};

PLUGIN.LookupTable[ "Headstrong" ] =
{ 
	["idle"] = "idle_subtle"
};

PLUGIN.LookupTable[ "Frustrated" ] =
{ 
	["idle"] = "LineIdle02",
	["walk"] = "pace_all",
};

function PLUGIN:GetPlayerMood(client)
	if (client:getNetVar("emoteMood") ~= "") then
		return client:getNetVar("emoteMood");
	end;

	return false;
end;

local weaponWhiteList =
{
	["nut_keys"] = true,
	["nut_hands"] = true
};

hook.Add("CalcMainActivity", "OverrideNSCrapHooks", function(client, velocity)
	if (PLUGIN:GetPlayerMood(client) and PLUGIN:GetPlayerMood(client) ~= "Default" and weaponWhiteList[client:GetActiveWeapon():GetClass()]) then
		local getMood = PLUGIN:GetPlayerMood(client);
		local moodTable = PLUGIN.LookupTable[getMood];
		local getClientModel = client:GetModel();

		client.CalcSeqOverride = -1;

		if (!GAMEMODE:HandlePlayerDriving(client) and !GAMEMODE:HandlePlayerJumping(client) and !GAMEMODE:HandlePlayerDucking(client, velocity) and !GAMEMODE:HandlePlayerSwimming(client)) then
			if (velocity:Length2D() < 0.5) then
				client.CalcSeqOverride = moodTable["idle"];
			elseif (velocity:Length2D() >= 0.5 and !client:isRunning()) then
				if (moodTable["walk"] ~= nil) then
					client.CalcSeqOverride = moodTable["walk"]
				end;
			end;
		end;

		if (client.CalcSeqOverride ~= -1) then
			client.CalcSeqOverride = client:LookupSequence(client.CalcSeqOverride);

			return client.CalcIdeal, client.CalcSeqOverride;
		end;
	end;
end);

nut.command.add("setmood",
{
	syntax = "<string moodType>",
	onRun = function(client, arguments)
		if client:isCombine() or client:isFemale() then return end;

		if (table.HasValue(PLUGIN.PersonalityTypes, arguments[1])) then
			client:setNetVar("emoteMood", arguments[1]);
		else
			client:notify("That is not a valid mood!");
		end;
	end;
});

if (CLIENT) then
	hook.Add("BuildHelpMenu", "MoodsBasicHelp", function(tabs)
		tabs["Moods"] = function(node)
			local body = "<h1>Gesture list</h1>"

			for k, v in pairs(PLUGIN.PersonalityTypes) do
				body = (body..[[<b>%s</b><br>]]):format(v);
			end;

			return body;
		end;
	end);
end;