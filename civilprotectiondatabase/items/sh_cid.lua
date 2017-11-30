ITEM.name = "Идентификационная карта"
ITEM.desc = "Пластиковая карта с данными Гражданина."
ITEM.model = "models/gibs/metal_gib4.mdl"

ITEM.functions.Assign =
{
	onRun = function(item)
		local trace = {}
		trace.start = item.player:EyePos()
		trace.endpos = trace.start + item.player:GetAimVector() * 96
		trace.filter = item.player

		local entity = util.TraceLine(trace).Entity

		if (IsValid(entity) and entity:IsPlayer() and !entity:isCombine()) then
			local character = entity:getChar()
			local Inventory = character:getInv()
			
			Inventory:add("cid", 1,
			{
				name = character:getName(),
				id = character:getData("cit_cid", 0)
			})
				
			return true
		end

		return false
	end,

	onCanRun = function(item)
		return (!IsValid(item.entity) and item.player:isCombine() or item.player:Team() == FACTION_CWU)
	end
}

function ITEM:getDesc()
	local description = self.desc

	if (self:getData("name", "no one") ~= "no one") and (self:getData("id", "00000") ~= "00000") then
		description = description.."\nКарта присвоена для:\n[*]Имя – "..self:getData("name", "no one").."\n[*]Номер – #"..self:getData("id", "00000")
	else
		description = description.."\nКарта никому не принадлежит"
	end

	if (self:getData("cwu")) then
		description = description.."\n\nКарта имеет штамп Гражданского Союза Рабочих"
	end

	return description
end