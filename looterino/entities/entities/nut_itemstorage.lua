ENT.Type = "anim"
ENT.PrintName = "Item Storage"
ENT.Author = "DrodA"
ENT.Category = "NutScript"
ENT.Spawnable = false

if (SERVER) then
	function ENT:Initialize()
		//self:SetModel("models/Items/item_item_crate.mdl")
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self.receivers = {}

		local physObj = self:GetPhysicsObject()

		if (IsValid(physObj)) then
			physObj:EnableMotion(true)
			physObj:Wake()
		end
	end

	function ENT:setInventory(inventory)
		if (inventory) then
			self:setNetVar("id", inventory:getID())

			inventory.onAuthorizeTransfer = function(inventory, client, oldInventory, item)
				if (IsValid(client) and IsValid(self) and self.receivers[client]) then
					return true
				end
			end

			inventory.getReceiver = function(inventory)
				local receivers = {}

				for k, v in pairs(self.receivers) do
					if (IsValid(k)) then
						receivers[#receivers + 1] = k
					end
				end

				return #receivers > 0 and receivers or nil
			end
		end
	end

	function ENT:Use(activator)
		local inventory = self:getInv()

		if (inventory and (activator.nutNextOpen or 0) < CurTime()) then
			if (activator:getChar()) then
				activator:setAction("Opening...", 1, function()
					if (activator:GetPos():Distance(self:GetPos()) <= 100) then
						self.receivers[activator] = true
						activator.nutBagEntity = self
						
						inventory:sync(activator)
						netstream.Start(activator, "_bOpen", self, inventory:getID())
					end
				end)
			end

			activator.nutNextOpen = CurTime() + 1.5
		end
	end

	function ENT:getInv()
		return nut.item.inventories[self:getNetVar("id", 0)]
	end
end
