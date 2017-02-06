local SCHEMA = SCHEMA

function SCHEMA:isOverWatchFaction(faction) return faction == FACTION_OW || faction == FACTION_EOW end

SCHEMA.divisions = {"UNION", "MACE", "VICE", "GRID", "HELIX", "JUDGE"}

do
	local playerMeta = FindMetaTable("Player")

	function playerMeta:isOTA() return SCHEMA:isOverWatchFaction(self:Team()) end

	function playerMeta:getCombineDivision()
		local name = self:Name()

		for k,v in ipairs(SCHEMA.divisions) do
			local division = string.PatternSafe(v)

			if (name:find("[%D+]"..division.."[%D+]")) then
				return v
			end
		end

		return "(0x321CB)"
	end
end