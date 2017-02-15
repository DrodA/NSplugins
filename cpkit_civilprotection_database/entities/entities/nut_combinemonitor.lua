ENT.Type = "anim"
ENT.PrintName = "Check monitor"
ENT.Author = "DrodA, AleXXX_007"
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

		self:setNetVar("monitor_activated", false)

		self.timeGen = CurTime()

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
		self:setNetVar("monitor_activated", false)
		self:EmitSound("buttons/blip1.wav")
		self:setNetVar("users", {})
		--MsgC("turn off\n")
	end

	function ENT:_turnOn(pl)	
		local char = pl:getChar()
		if char:getData("cit_cid", 0) then
			self:setNetVar("monitor_activated", true)
			self:EmitSound("buttons/blip1.wav")
			self.timeGen = CurTime() + 8 -- 8
			--MsgC("turn on\n")
		end
	end

	function ENT:Think()
		local i = self:getNetVar("users", {})
		if self:getNetVar("monitor_activated") then
			if i.status == "ANTICITIZEN" then
				if !nextmessage || CurTime() >= nextmessage then
					local getall = player.GetAll()
					for _, combine in ipairs(getall) do
						if combine:Alive() && combine:getChar() then
							if combine:isCombine() then
								combine:addDisplay("Всем постам. Нарушитель #"..i.cid.." замечен по координатам: "..math.floor(self:GetPos()[1])..", "..math.floor(self:GetPos()[2])..", "..math.floor(self:GetPos()[3])..".", Color(255, 0, 0))
							end
						end
					end
					nextmessage = CurTime() + 10
				end
			end

			if self.timeGen < CurTime() then
				self:_turnOff()
			end
		else
			self.activator = nil
		end
		self:NextThink(CurTime() + 1)
	end
	
	function ENT:_canTurnOn(pl)
		return (!self:getNetVar("monitor_activated") && !pl:isCombine())
	end

	-- (c) AleXXX_007 [x2]
	function ENT:_dataList(p)
		local ch = p:getChar()
		local data = self:getNetVar("users", {})

		data =
		{
			name = p:Name(),
			cid = ch:getData("cit_cid", 0),
			lp = ch:getData("cit_loyality", 0),
			pp = ch:getData("cit_penalty", 0),
			status = ch:getData("cit_status", "NON-CITIZEN"),
			work = ch:getData("cit_working", 0)
		}

		self:setNetVar("users", data)
	end

	function ENT:Use(pl)
		local data = self:getNetVar("users", {})
		if self:_canTurnOn(pl) then
			self.activator = pl
			self:_turnOn(pl)
			self:_dataList(pl)
			--PrintTable(data)

			return
		end
	end
else
	surface.CreateFont( "_CMB_FONT_1", {
		font = "Myriad Pro",
		size = 22,
		weight = 1000,
		antialias = true,
		underline = false,
		additive = true
	})
	surface.CreateFont( "_CMB_FONT_2", {
		font = "Consolas",
		size = 20,
		weight = 1000,
		antialias = true,
		underline = false,
		additive = true
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
	end

	local function bitkek( int )
		local str = ""
		for i = 0, int do
			str = str .. math.random(0,1)
		end
		return str
	end

	local offset = 25
	local material = Material("props/combine_monitor_access")
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
				render.Clear( 0, 50, 120, 255 )
				cam.Start2D()
					local glow_text = math.abs(math.sin(CurTime() * 3) * 255)
					local v = self:getNetVar("users", {})
					if (v.status != "ANTICITIZEN") then
						surface.SetTextColor(color_white)
						surface.SetFont("_CMB_FONT_1")
						surface.SetTextPos( 9, 6 )
						surface.DrawText("Информационный стенд")
						surface.SetTextPos( 64, 26 )
						surface.DrawText("Гражданина")
					end

					if !self:getNetVar("monitor_activated") then
						surface.SetTextColor(255, 255, 255, glow_text)
						surface.SetFont("_CMB_FONT_1")
						surface.SetTextPos( 9, 256 - 128 - 4)
						surface.DrawText("Ожидается ввод данных")
					else
						if v.status == "NON-CITIZEN" then
							text = "не подтвержден"
						elseif v.status == "CITIZEN" then
							text = "подтвержден"
						elseif v.status == "ANTICITIZEN" then
							text = ""
							render.Clear( 80, 0, 0, 255 )
						end

						if #v.name > 19 then
							v.name = string.sub(v.name, 1, 19 - 3) .. "..."
						end

						if (v.status != "ANTICITIZEN") then
							surface.SetTextColor(color_white)
							surface.SetFont("_CMB_FONT_2")
							surface.SetTextPos( 18, 55)
							surface.DrawText("Имя: "..v.name)
							surface.SetTextPos( 18, 80)
							surface.DrawText("Идентификатор: #"..v.cid)
							surface.SetTextPos( 18, 80 + offset)
							surface.DrawText("Лояльность: "..v.lp)
							surface.SetTextPos( 18, 80 + (offset * 2))
							surface.DrawText("Нарушения: "..v.pp)
							surface.SetTextPos( 18, 80 + (offset * 3))
							surface.DrawText("Труд: "..v.work)
							surface.SetTextPos( 18, 80 + (offset * 4))
							surface.DrawText("Статус: "..text)

							if v.status == "NON-CITIZEN" then
								surface.SetTextPos( 18, 80 + (offset * 5))
								surface.DrawText("Подтвердите свой статус")
								surface.SetTextPos( 68, 76 + (offset * 6))
								surface.DrawText("В отделе ГСР")
							end

							surface.SetDrawColor(0, 50, 160)
							surface.DrawRect(0, 52, 256, 2)
							surface.DrawRect(0, 80 + (offset * 5), 256, 2)
						else
							surface.SetTextColor( 255, 0, 0 )
							surface.SetFont("_CMB_FONT_4")
							surface.SetTextPos( 10, 50 )
							surface.DrawText("ERROR")

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
								surface.SetTextPos(88, 50)
								surface.DrawText(bitkek(4).."cmb_biba"..bitkek(1).."systems"..bitkek(2).."failure"..bitkek(3))
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
