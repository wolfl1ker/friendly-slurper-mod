--[[
**************************
	CURENT VERSION: 1.8.4 (FS and BoL);
**************************
--]]
local assets =
{
	Asset("ANIM", "anim/licking_help.zip"),
	Asset("ATLAS", "images/inventoryimages/licking_help.xml"),
}

local SPAWN_DIST = 35
local trace = function() end
local NUMBEROFHELPERS = TUNING.GH_LH_NUMBEROFHELPERS
local LostTrust = TUNING.GH_LH_COST
local MinTrustToCast = TUNING.GH_LH_MINTOCAST
local CoolDown = TUNING.GH_LH_COOLDOWN
local timer = 0
local randNum = 0
local helpersnumber = 0

--Spawning Functions.
local function GetSpawnPoint(pt)

    local theta = math.random() * 2 * PI
    local radius = SPAWN_DIST

	local offset = FindWalkableOffset(pt, theta, radius, 12, true)
	if offset then
		return pt+offset
	end
end

local function SpawnHelpers(inst, helpersnumber)
	if helpersnumber > 0 then
		trace("licking_eyebone - SpawnHelpers")
	
		local pt = Vector3(inst.Transform:GetWorldPosition())
		trace("    near", pt)
			
		local spawn_pt = GetSpawnPoint(pt)
		if spawn_pt then
			trace("    at", spawn_pt)
			local licking_helper = SpawnPrefab("licking_helper")
			if licking_helper then
				licking_helper.Physics:Teleport(spawn_pt:Get())
				licking_helper:FacePoint(pt.x, pt.y, pt.z)
				licking_helper.components.follower.leader = GetPlayer();
				helpersnumber = helpersnumber - 1
				return SpawnHelpers(inst, helpersnumber)
			end
	
		else
			trace("licking_eyebone - SpawnHelpers: Couldn't find a suitable spawn point for licking_helper")
		end
	else
		return false
	end
end

local function readingLH (inst,reader)
	if GetTime() > timer + CoolDown then
		if reader.components.licking_trust and reader.components.licking_trust.current > MinTrustToCast then
			if reader.components.talker then
				randNum = math.random()
				if randNum < 0.5 then
					reader.components.talker:Say(STRINGS.CASTING_LICKINGHELP1)
				else
					if randNum < 0.75 and randNum > 0.5 then
						reader.components.talker:Say(STRINGS.CASTING_LICKINGHELP2)
					else
						reader.components.talker:Say(STRINGS.CASTING_LICKINGHELP3)
					end
				end
			end			
			reader.components.licking_trust:DoDelta(-LostTrust)
			helpersnumber = NUMBEROFHELPERS
			SpawnHelpers(inst, helpersnumber)
			timer = GetTime()
		else
			if reader.components.talker then
				randNum = math.random()
				if randNum < 0.3 then
					reader.components.talker:Say(STRINGS.CASTER_NO_MANA1)
				else
					if randNum < 0.6 then
						reader.components.talker:Say(STRINGS.CASTER_NO_MANA2)
					else
						reader.components.talker:Say(STRINGS.CASTER_NO_MANA3)
					end
				end
			end
		end
	else
		if reader.components.talker then
			randNum = math.random()
			if randNum < 0.3 then
				reader.components.talker:Say(STRINGS.CASTER_COOLDOWN1)
			else
				if randNum < 0.6 then
					reader.components.talker:Say(STRINGS.CASTER_COOLDOWN2)
				else
					reader.components.talker:Say(STRINGS.CASTER_COOLDOWN3)
				end
			end
		end
	end
	return true
end

local function fnLH()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()

	inst:AddTag("licking_help")
	inst:AddTag("ghosto_book")
	inst:AddTag("unique-book")
	
	anim:SetBank("book_maxwell")
	anim:SetBuild("licking_help")
	anim:PlayAnimation("idle")
	
    MakeInventoryPhysics(inst)
	inst:AddComponent("inspectable")
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/licking_help.xml"
	
	MakeSmallPropagator(inst)

	inst:AddComponent("book")
	inst.components.book.onread = readingLH
	return inst
end 
	return Prefab("common/inventory/licking_help", fnLH, assets)