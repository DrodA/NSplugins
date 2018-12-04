local plugin = PLUGIN

ENT.Type = 'anim'
ENT.PrintName = 'Reward terminal'
ENT.Author = 'DrodA'
ENT.Category = 'HL2RP'
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.model = 'models/props_combine/breenconsole.mdl'
ENT.sound = {}
ENT.sound[true] = 'buttons/button18.wav'
ENT.sound[false] = 'buttons/button19.wav'

if (SERVER) then
	function ENT:Initialize()
		self:SetModel(self.model)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)

		local physics_object = self:GetPhysicsObject()
		if (IsValid(physics_object)) then
			physics_object:Sleep()
			physics_object:EnableMotion(false)
		end

		self.next_use = 0
		self:setNetVar('activated', false)
	end

	function ENT:SpawnFunction(client, trace)
		local entity = ents.Create(self.ClassName)
		entity:SetPos(trace.HitPos + trace.HitNormal)
		entity:Spawn()
		entity:Activate()

		return entity
	end

	function ENT:Use(activator)
		local curTime = CurTime()
		if (self.next_use < curTime) then
			self.next_use = curTime + 1

			if activator:isCombine() then
				return self:set_activity(!self:get_activity())
			end

			if self:get_activity() then
				local reward_card = {}
				for index, data in pairs(activator:getItems()) do
					local item_table = nut.item.instances[data.id]
					if (item_table and item_table.is_reward_card) then
						reward_card = item_table

						break
					end
				end

				if (next(reward_card) and next(reward_card:get_rewards())) then
					for k, v in pairs(plugin.get_rewards()) do
						local reward = reward_card:get_reward(k)
						if (reward and reward.value > 0) then
							v.callback(activator, reward.value)
						end
					end
					
					hook.Run('on_reward_received', activator)

					self:EmitSound('buttons/blip1.wav')
					reward_card:remove()
				end
			end
		end
	end
end

function ENT:get_activity()
	return self:getNetVar('activated')
end

function ENT:set_activity(bool)
	self:EmitSound(self.sound[bool])
	self:setNetVar('activated', bool)
end

if (CLIENT) then
	local glow_material = nut.util.getMaterial('sprites/glow04_noz')
	local color_activity = {}
	color_activity[true] = Color(0, 255, 0)
	color_activity[false] = Color(0, 175, 255)
	function ENT:DrawTranslucent()
		self:DrawModel()

		local position = self:GetPos()
		local color = color_activity[self:get_activity()]

		if (LocalPlayer():GetPos():Distance(position) < 1024) then
			render.SetMaterial(glow_material)
			render.DrawSprite(position + self:GetForward() * -12.5 + self:GetUp() * 43 + self:GetRight() * 2, 4, 4, color)
		end
	end
end
