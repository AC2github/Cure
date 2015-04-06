local ITEM = {}
ITEM.ID = "hat_trafficcone_3"
ITEM.Name = "Trafficcone"
ITEM.Desc = "Manage traffic with this thing on"
ITEM.StoreData = {price = 5000, CanBuy = true}
ITEM.Type = TYPE_SHOP_HAT
ITEM.Model = "models/props_junk/TrafficCone001a.mdl"

-- Item modifiers
ITEM.HatData = {
	["default"] = {Pos = Vector(18,0,0), Ang = Angle(0,0,-90), Scale = 1}
}

Cure.Shop.RegisterItem(ITEM)

