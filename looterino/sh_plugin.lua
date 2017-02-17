PLUGIN.name = "Le looterino"
PLUGIN.author = "DrodA"
PLUGIN.desc = "You leaves ur own itemerino when you riperino"

PLUGIN.staytime = 120

function PLUGIN:PlayerDeath( player, damage, attacker )
	local character = player:getChar():getInv()

	local strg = ents.Create("nut_itemstorage")
	strg:SetModel("models/props_junk/garbage_bag001a.mdl")
	strg:SetPos(player:GetPos() + Vector(0,0, 16))
	strg:SetAngles(player:GetAngles())
	strg:SetSolid(SOLID_VPHYSICS)
	strg:PhysicsInit(SOLID_VPHYSICS)
	strg.receivers = {}

	nut.item.newInv(0, "_itmstrg"..player:SteamID(), function(inventory)
		if IsValid(strg) then
			inventory:setSize(nut.config.get("invW"), nut.config.get("invH"))
			strg:setInventory(inventory)
		end
	end)

	local inv = character:getItems()
	local var = strg:getNetVar("id")
	for k, v in pairs(inv) do
		v:transfer(var)

		strg:Spawn()
	end

	if IsValid(strg) then
		timer.Simple(self.staytime, function()
			strg:Remove()
		end)
	end
end

netstream.Hook("_bOpen", function(entity, index)
	local inventory = nut.item.inventories[index]

	if (IsValid(entity) && inventory && inventory.slots) then
			nut.gui.inv1 = vgui.Create("nutInventory")
			nut.gui.inv1:ShowCloseButton(true)

			local inventory2 = LocalPlayer():getChar():getInv()

			if (inventory2) then
				nut.gui.inv1:setInventory(inventory2)
			end

			local panel = vgui.Create("nutInventory")
			panel:ShowCloseButton(true)
			panel:SetTitle("Bag inventory")
			panel:setInventory(inventory)
			panel:MoveLeftOf(nut.gui.inv1, 4)
			panel.OnClose = function(this)
				if (IsValid(nut.gui.inv1) && !IsValid(nut.gui.menu)) then
					nut.gui.inv1:Remove()
				end

				netstream.Start("invExit")
			end

			local oldClose = nut.gui.inv1.OnClose
			nut.gui.inv1.OnClose = function()
				if (IsValid(panel) && !IsValid(nut.gui.menu)) then
					panel:Remove()
				end

			netstream.Start("invExit")
			nut.gui.inv1.OnClose = oldClose
		end

		nut.gui["inv"..index] = panel
	end
end)
