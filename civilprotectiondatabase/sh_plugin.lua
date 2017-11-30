local PLUGIN = PLUGIN

PLUGIN.name = "Civil Protection Database"
PLUGIN.author = "CW: Schwarz Kruppzo | NS: DrodA, AleXXX_007"
PLUGIN.desc = "Adds new branded flexible Civil Protection system."
PLUGIN.version = 3
PLUGIN.CivilProtection = {}

local fileTable =
{
	"sh_config.lua",
	"sh_commands.lua",
	"sh_chatregister.lua"
}

for k, v in pairs(fileTable) do nut.util.include(v) end

if (CLIENT) then return end

-- override SCHEMA function
function SCHEMA:OnCharCreated(client, character)
	local inventory = character:getInv()
	local cid = math.random(tonumber("1"..string.rep("0", PLUGIN.CivilProtection.CIDLength - 1)), tonumber(string.rep("9", PLUGIN.CivilProtection.CIDLength)))

	if (PLUGIN.CivilProtection.AllowedFactions[character:getFaction()]) then
		character:setData("cit_cid", cid)
		
		if (inventory) then
			inventory:add("cid", 1,
			{
				name = character:getName(),
				id = character:getData("cit_cid", 0)
			})
		end

		MsgC(Color(0, 255, 0), "[Data] new CID set for "..character:getName()..". CID: "..character:getData("cit_cid", 0).."\n")
	end
end

function PLUGIN:Think()
	local curTime = CurTime()

	for k, v in pairs(player.GetAll()) do
		local character = v:getChar()
		if !character then continue end

		if !v:isCombine() then
			if (!v.isolationTime or curTime >= v.isolationTime) then
				if (character:getData("cit_jail_type", "#N") ~= "#N") and (character:getData("cit_jail_time", 0) > 0) then
					character:setData("cit_jail_time",  character:getData("cit_jail_time", 0) - 1)
				end

				v.isolationTime = curTime + 1
			end
		else
			if (!v.isolationRemind or curTime >= v.isolationRemind) then
				if (character:getData("cit_jail_type", "#N") ~= "#N") and (character:getData("cit_jail_time", 0) <= 0) then
					v:addDisplay("Изоляция Заключенного #"..character:getData("cit_cid", 0).." завершена. Освободить Гражданина.", PLUGIN.CivilProtection.Colors.IsolationDisplay)
				end

				v.isolationRemind = curTime + 1
			end
		end
	end
end

function PLUGIN:SaveData()
	local Data = {}
		for k, v in ipairs(ents.FindByClass("nut_combinemonitor")) do
			Data[#Data + 1] =
			{
				pos = v:GetPos(),
				angles = v:GetAngles()
			}
		end

	self:setData(Data)
end

function PLUGIN:LoadData()
	for k, v in ipairs(self:getData() or {}) do
		local entity = ents.Create("nut_combinemonitor")
		entity:SetPos(v.pos)
		entity:SetAngles(v.angles)
		entity:Spawn()
	end
end