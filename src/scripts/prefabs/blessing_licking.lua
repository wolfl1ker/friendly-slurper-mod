--[[
**************************
	CURENT VERSION: 1.8.4 (FS and BoL);
**************************
--]]
local assets =
{
	Asset("ANIM", "anim/blessing_licking.zip"),
	Asset("ATLAS", "images/inventoryimages/blessing_licking.xml"),
}

local function readingBL (inst,reader)
	if (reader.components.licking_trust and reader.components.sanity) then
        reader.components.sanity:DoDelta(TUNING.GH_BL_DELTA_SANITY)
		reader.components.licking_trust:DoDelta(TUNING.GH_BL_DELTA_LTRUST)
    end
	return true
end

local function fnBL()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()

	inst:AddTag("blessing_licking")
	inst:AddTag("ghosto_book")
	inst:AddTag("unique-book")
	
	anim:SetBank("book_maxwell")
	anim:SetBuild("blsd_licking")
	anim:PlayAnimation("idle")
	
    MakeInventoryPhysics(inst)
	inst:AddComponent("inspectable")
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/blessing_licking.xml"
	
	MakeSmallPropagator(inst)

	inst:AddComponent("book")
	inst.components.book.onread = readingBL
	return inst
end 
	return Prefab("common/inventory/blessing_licking", fnBL, assets)

	