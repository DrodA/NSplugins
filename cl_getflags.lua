PLUGIN.name = "FlagFinder"; // lul
PLUGIN.author = "DrodA";
PLUGIN.desc = "Find All Players With Flag(s)";

nut.command.add("findallflags", 
{
	adminOnly = true,
	onRun = function(client, arguments)
		for k, v in pairs(player.GetAll()) do
			if IsValid(v) then
				if (v:getChar():getFlags() == "") then continue end;
				client:ChatPrint(v:Name().." — "..v:getChar():getFlags());
			end;
		end;
	end;
});