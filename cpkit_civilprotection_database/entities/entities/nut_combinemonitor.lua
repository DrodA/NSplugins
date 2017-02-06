ENT.Type = "anim"
ENT.PrintName = "Check monitor"
ENT.Author = "DrodA"
ENT.Category = "HL2RP [DATA] | Monitors"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.Model = "models/props_combine/combine_smallmonitor001.mdl"

if SERVER then
	function ENT:Initialize()
		self:SetModel(self.Model)
		self:SetMoveType(MOVETYPE_VPHYSICS);
		self:PhysicsInit(SOLID_VPHYSICS);
		self:SetUseType(SIMPLE_USE);
		self:SetHealth(1);
		self:SetSolid(SOLID_VPHYSICS);

		self:SetNetVar("monitor_activated", false)
		self:SetNetVar("monitor_activator", "#N")
		self:SetNetVar("monitor_activator_status", "NON-CITIZEN")
		self:SetNetVar("monitor_activator_CID", 0)
		self:SetNetVar("monitor_activator_loyality", 0)
		self:SetNetVar("monitor_activator_penalty", 0)
		self:SetNetVar("monitor_activator_working", 0)

		self.timeGen = CurTime()
		self.timeHold = CurTime()

		local physicsObject = self:GetPhysicsObject()
		if (IsValid(physicsObject)) then
			physicsObject:Sleep()
			physicsObject:EnableMotion(false)
		end
	end

	function ENT:SpawnFunction(client, trace)
		local entity = ents.Create(self.ClassName)
		entity:SetPos(trace.HitPos)
		entity:SetAngles(trace.HitNormal:Angle())
		entity:Spawn()
		entity:Activate()

		return entity
	end

	function ENT:_turnOff()
		self:SetNetVar("monitor_activated", false)
		self:EmitSound("buttons/blip1.wav")
		self.timeHold = CurTime() + 1
		--MsgC("turn off\n")
	end

	function ENT:_turnOn(pl)	
		local char = pl:getChar()
		if char:getData("cit_cid", 0) then
			self:SetNetVar("monitor_activated", true)
			self:EmitSound("buttons/blip1.wav")
			self.timeGen = CurTime() + 8 -- 8
			--MsgC("turn on\n")
		end
	end

	function ENT:Think()
		if self:GetNetVar("monitor_activated") then
				if self:GetNetVar("monitor_activator_status") == "ANTICITIZEN" then
					if !nextmessage || CurTime() >= nextmessage then
						local getall = player.GetAll()
						for _, combine in ipairs(getall) do
							if combine:Alive() && combine:getChar() then
								if combine:isCombine() then
									combine:addDisplay("Всем постам. Нарушитель #"..self:GetNetVar("monitor_activator_CID", 0).." замечен по координатам: "..math.floor(self:GetPos()[1])..", "..math.floor(self:GetPos()[2])..", "..math.floor(self:GetPos()[3])..".", Color(255, 0, 0))
								end
							end
						end
						nextmessage = CurTime() + 10
					end
				end

			if self.timeGen < CurTime() then
				self:_turnOff()
				self:SetNetVar("monitor_activator", "#N")
				self:SetNetVar("monitor_activator_CID", 0)
				self:SetNetVar("monitor_activator_loyality", 0)
				self:SetNetVar("monitor_activator_penalty", 0)
				self:SetNetVar("monitor_activator_status", "NON-CITIZEN")
				self:SetNetVar("monitor_activator_working", 0)
			end
		else
			self.activator = nil
		end
		self:NextThink(CurTime() + 1)
	end
	
	function ENT:_canTurnOn(pl)
		return (!self:GetNetVar("monitor_activated") && !pl:isCombine())
	end

	function ENT:Use(pl)
		if self:_canTurnOn(pl) then
			self.activator = pl
			self:_turnOn(pl)
			self:SetNetVar("monitor_activator", tostring(pl:Name()))
			self:SetNetVar("monitor_activator_CID", tonumber(pl:getChar():getData("cit_cid", 0)))
			self:SetNetVar("monitor_activator_loyality", tonumber(pl:getChar():getData("cit_loyality", 0)))
			self:SetNetVar("monitor_activator_penalty", tonumber(pl:getChar():getData("cit_penalty", 0)))
			self:SetNetVar("monitor_activator_status", tostring(pl:getChar():getData("cit_status", "NON-CITIZEN")))
			self:SetNetVar("monitor_activator_working", tonumber(pl:getChar():getData("cit_working", 0)))

			return
		end
	end
else
	local glow = CreateMaterial( "_CMB_SMALLMONITOR_GLOW4", "UnlitGeneric", {
		["$basetexture"] = "sprites/glow06",
		["$additive"] = "1",
		["$selfilium"] = "1",
		["$vertexcolor"] = "1",
		["$vertexalpha"] = "1",
	})
	local errorc = CreateMaterial( "_CMB_ERROR", "Modulate", {
		["$basetexture"] = "props/combine_monitor_access_off",
		["$ignorez"] = "1",
		["$vertexcolor"] = "1",
		["$vertexalpha"] = "1",
		["$translucent"] = "1",
	})

	surface.CreateFont( "_CMB_FONT_1", {
		font = "Myriad Pro",
		size = 22,
		weight = 1000,
		antialias = true,
		underline = false,
	})
	surface.CreateFont( "_CMB_FONT_2", {
		font = "Consolas",
		size = 20,
		weight = 1000,
		antialias = true,
		underline = false,
	})
	surface.CreateFont( "_CMB_FONT_4", {
		font = "System",
		size = 72,
		weight = 1000,
		antialias = true,
		underline = false,
	})
	surface.CreateFont( "_CMB_FONT_5", {
		font = "System",
		size = 9,
		weight = 500,
		antialias = false,
		underline = false,
	})

	function ENT:Initialize()
		self.RT = GetRenderTarget("_CMB_SMALLMONITOR_ENT"..self:EntIndex()..CurTime(), 256, 256, false)
		self.RTMat = CreateMaterial( "_CMB_SMALLMONITOR_ENT_RTMAT" .. self:EntIndex() .. CurTime(), "UnlitTwoTexture", {
			["$selfilium"] = "1",
			["$texture2"] = "dev/dev_scanline",
			["Proxies"] = 
			{

				["TextureScroll"] =
				{
					["texturescrollvar"] = "$texture2transform",
					["texturescrollrate"] = "3",
					["texturescrollangle"] = "90"
				}
			}
		} )
		self.error = true
		self.errorFlash = CurTime()
	end

	local function bitkek( int )
		local str = ""
		for i = 0, int do
			str = str .. math.random(0,1)
		end
		return str
	end

	function ENT:DrawTranslucent()
		local mypos = self:GetPos()
		local dist = LocalPlayer():GetPos():Distance(mypos)
		if dist < 1000 then
			self:DrawModel()

			local pos = self:GetPos()
			local ang = self:GetAngles()

			ang:RotateAroundAxis(ang:Forward(), 90)
			ang:RotateAroundAxis(ang:Right(), -90)

			pos = pos + self:GetForward() * 13 + self:GetUp() * 19 + self:GetRight() * 6.8

			render.PushRenderTarget( self.RT )
				render.Clear( 0, 0, 80, 255 )
				cam.Start2D()
					surface.SetDrawColor( 255, 255, 255, 255 )
					surface.SetMaterial(Material("props/combine_monitor_access"))
					surface.DrawTexturedRect( 0, 0, 256, 256 )

					local glow_text = math.abs(math.sin(CurTime() * 3) * 255)
					surface.SetTextColor( 0, 0, 128 )
					surface.SetFont("_CMB_FONT_1")
					surface.SetTextPos( 9, 8 )
					surface.DrawText("Информационный стенд")
					surface.SetTextPos( 66, 26 )
					surface.DrawText("Гражданина")

					if !self:GetNetVar("monitor_activated") then
						surface.SetTextColor( 0, 0, 128, glow_text )
						surface.SetFont("_CMB_FONT_1")
						surface.SetTextPos( 9, 256 - 128 + 8)
						surface.DrawText("Ожидается ввод данных")
					else
						local activator = self:GetNetVar("monitor_activator", "#N")
						local activator_cid = self:GetNetVar("monitor_activator_CID", 0)
						local activator_lp = self:GetNetVar("monitor_activator_loyality", 0)
						local activator_pp = self:GetNetVar("monitor_activator_penalty", 0)
						local activator_work = self:GetNetVar("monitor_activator_working", 0)

						local text
						local activator_status = self:GetNetVar("monitor_activator_status", "NON-CITIZEN")
						if activator_status == "NON-CITIZEN" then
							text = "не подтвержден"
						elseif activator_status == "CITIZEN" then
							text = "подтвержден"
						elseif activator_status == "ANTICITIZEN" then
							text = "нарушитель"
							render.Clear( 80, 0, 0, 255 )
						end

						if (activator_status != "ANTICITIZEN") then
							surface.SetTextColor( 0, 0, 128 )
							surface.SetFont("_CMB_FONT_2")
							surface.SetTextPos( 9, 50)
							surface.DrawText("Name: "..activator)
							surface.SetTextPos( 9, 75)
							surface.DrawText("CID: #"..activator_cid)
							surface.SetTextPos( 9, 75 + 25)
							surface.DrawText("Loyality: "..activator_lp)
							surface.SetTextPos( 9, 75 + (25 * 2))
							surface.DrawText("Penalty: "..activator_pp)
							surface.SetTextPos( 9, 75 + (25 * 3))
							surface.DrawText("Working: "..activator_work)
							surface.SetTextPos( 9, 75 + (25 * 4))
							surface.DrawText("Status: "..text)

							surface.SetDrawColor(0, 0, 128)
							surface.DrawRect(0, 50, 256, 2)
							surface.DrawRect(0, 75 + (25 * 5), 256, 2)

							if activator_status == "NON-CITIZEN" then
								surface.SetTextPos( 14, 75 + (25 * 5))
								surface.DrawText("Подтвердите свой статус")
								surface.SetTextPos( 64, 75 + (25 * 6))
								surface.DrawText("В отделе ГСР")
							end
						else
							surface.SetTextColor( 255, 0, 0 )
							surface.SetFont("_CMB_FONT_4")
							surface.SetTextPos( 10, 50 )
							surface.DrawText("ERROR")

							if CurTime() >= self.errorFlash then
								self.error = !self.error
								self.errorFlash = CurTime() + 0.4
							end

							if LocalPlayer():GetPos():Distance(self:GetPos()) < 300 then
								surface.SetTextColor( 255, 0, 0 )
								surface.SetFont("_CMB_FONT_5")
								surface.SetTextPos(20, 140)
								surface.DrawText("1E"..bitkek(13))
								surface.SetTextPos(20, 155)
								surface.DrawText(bitkek(6).."cmb_ACCESS")
								surface.SetTextPos(20, 180)
								surface.DrawText(bitkek(2)..util.CRC(self:EntIndex())..bitkek(2).."CP_cmb"..bitkek(4))
								surface.SetTextPos(20, 220)
								surface.DrawText(bitkek(8).."cmb_droda was here"..bitkek(4))
							end
						end
					end
				cam.End2D()
			render.PopRenderTarget()

			self.RTMat:SetTexture( "$basetexture", self.RT )
			cam.Start3D2D(pos, ang, 0.064)
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.SetMaterial( self.RTMat )
				surface.DrawTexturedRect( 0, 0, 256, 256 )
			cam.End3D2D()
		end
	end
end