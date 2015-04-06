local ITEM = {}
ITEM.ID = "hat_bucket"
ITEM.Name = "Bucket"
ITEM.Desc = "A rusty bucket hat"
ITEM.StoreData = {price = 5000, CanBuy = true}
ITEM.Type = TYPE_SHOP_HAT
ITEM.Model = "models/props_junk/MetalBucket01a.mdl"

-- Item modifiers
ITEM.HatData = {
	["default"] = {Pos = Vector(5.2, -2, 0), Ang = Angle(0, 20, 90)}
}

Cure.Shop.RegisterItem(ITEM)

Cure.Shop.AddPaint(ITEM.ID, "Red bucket", TYPE_SHOP_PAINT_RED)

Cure.Shop.AddQuality(ITEM.ID, "Unusual Bucket", TYPE_SHOP_UNUSUAL, TYPE_SHOP_EFFECT_BURNING1)
Cure.Shop.AddQuality(ITEM.ID, "Legendary Bucket", TYPE_SHOP_LEGENDARY, TYPE_SHOP_EFFECT_BURNING2)
