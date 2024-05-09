--[[
**************************
    CURENT VERSION: 1.8.4 (FS and BoL);
**************************
--]]
local assets=
{
	Asset("ANIM", "anim/armor_slurper.zip"),
	Asset("ATLAS", "images/inventoryimages/book_licking.xml"),
}
local temp1 = 1 --newdropping
local temp2 = 1 --newdroprate
local temp3 = 1 --newburnrate

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "armor_slurper", "swap_body")
    if owner.components.licking_trust then
        owner.components.licking_trust:SetCustomDrop(temp1, temp2, temp3)
    end
	if owner.components.talker then
		owner.components.talker:Say("Licking! Believe in me!")
	end
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
    if owner.components.licking_trust then
        owner.components.licking_trust:SetNormalDrop()
    end
	if owner.components.talker then
		owner.components.talker:Say("It's hard to wear it anymore.")
	end
end

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
    inst.AnimState:SetBank("armor_slurper")
    inst.AnimState:SetBuild("armor_slurper")
    inst.AnimState:PlayAnimation("anim")
    
    inst:AddTag("lickings_pelt")
	inst:AddTag("lickings_armor")
	inst:AddTag("lickings_items")
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/book_licking.xml"
    
    inst:AddComponent("dapperness")
    inst.components.dapperness.dapperness = TUNING.DAPPERNESS_SMALL

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
    
    return inst
end

return Prefab( "common/inventory/lickings_pelt", fn, assets) 
