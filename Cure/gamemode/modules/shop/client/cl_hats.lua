
-- Keep track of hats
local hats = {}

-- Add a hat
function Cure.Shop.CreateHat(player, itemid, color, effect)
	-- Remove old hat
	if (hats[player]) then
		hats[player].hat:Remove()
		hats[player] = nil
	end

	-- Remove
	if (itemid == "remove") then return end

	-- Keep track of stuff
	hats[player] = {}

	-- Get data
	local item = Cure.Shop.GetItem(itemid)

	-- Just remove
	if (item == nil) then return end

	if (item) and (item.Type == TYPE_SHOP_HAT) then
		-- General setup
		hats[player].player = player
		hats[player].hat = ClientsideModel(item.Model, RENDERGROUP_OPAQUE)

		-- Parent and owner
		hats[player].hat:SetParent(LocalPlayer())
		hats[player].hat:SetOwner(player)

		-- Know how to draw
		hats[player].hat.ID = itemid

		-- Add color
		if (color) then
			hats[player].hat.Color = color or nil
		end

		-- Particles, this will be fun
		if (effect) then
			ParticleEffectAttach(effect, PATTACH_ABSORIGIN, hats[player].hat, 0)
		end
	end
end

-- Define vars outside function, saves a few fps
local head
local pos, ang
local hatpos, hatang, hatscale

-- This hook
hook.Add("PostDrawOpaqueRenderables", "Hats", function()
	-- Our draw table
	for k, v in pairs(hats) do
		-- Don't draw our own hat
		if (v.hat:GetOwner() == LocalPlayer()) then continue end

		-- Get stuff
		head = v.player:LookupBone("ValveBiped.Bip01_Head1")
		pos, ang = v.player:GetBonePosition(head)
		hatpos = Cure.Shop.GetHatData(v.player, v.hat.ID)
		hatang = hatpos
		hatscale = hatpos

		-- Draw
		if (pos) and (ang) then
			-- Set Pos
			v.hat:SetPos(pos + (ang:Forward() * hatpos.Pos.x) + (ang:Right() * hatpos.Pos.y) + (ang:Up() * hatpos.Pos.z))

			-- Angles
			ang:RotateAroundAxis(ang:Forward(), hatang.Ang.p)
			ang:RotateAroundAxis(ang:Up(), hatang.Ang.y)
			ang:RotateAroundAxis(ang:Right(), hatang.Ang.r)
			v.hat:SetAngles(ang)

			-- Colors
			if (v.hat.Color) then
				render.SuppressEngineLighting(true)
				render.SetColorModulation(v.hat.Color.r / 255, v.hat.Color.g / 255, v.hat.Color.b / 255)
				render.SetBlend(v.hat.Color.a / 255)
			end

			-- Draw model
			v.hat:DrawModel()
			
			-- Scale if needed
			if (hatscale.Scale) then
				v.hat:SetModelScale(hatscale.Scale, 0)
			end
		end
	end
end)


