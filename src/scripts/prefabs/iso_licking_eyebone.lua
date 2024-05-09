--[[
**************************
    CURENT VERSION: 1.8.4 (FS and BoL);
**************************
--]]
local assets=
{
    Asset("ATLAS", "images/inventoryimages/iso_licking_eyebone.xml"), -- mod
    Asset("ANIM", "anim/iso_licking_eyebone.zip"), -- mod
}

local SPAWN_DIST = 30

local trace = function() end

local function GetSpawnPoint(pt)

    local theta = math.random() * 2 * PI
    local radius = SPAWN_DIST

	local offset = FindWalkableOffset(pt, theta, radius, 12, true)
	if offset then
		return pt+offset
	end
end

local function SpawnIsoLicking(inst)
    trace("iso_licking_eyebone - SpawnIsoLicking")

    local pt = Vector3(inst.Transform:GetWorldPosition())
    trace("    near", pt)
        
    local spawn_pt = GetSpawnPoint(pt)
    if spawn_pt then
        trace("    at", spawn_pt)
        local iso_licking = SpawnPrefab("iso_licking")
        if iso_licking then
            iso_licking.Physics:Teleport(spawn_pt:Get())
            iso_licking:FacePoint(pt.x, pt.y, pt.z)

            return iso_licking
        end

    else
        -- this is not fatal, they can try again in a new location by picking up the bone again
        trace("iso_licking_eyebone - SpawnIsoLicking: Couldn't find a suitable spawn point for iso_licking")
    end
end


local function StopRespawn(inst)
    trace("iso_licking_eyebone - StopRespawn")
    if inst.respawntask then
        inst.respawntask:Cancel()
        inst.respawntask = nil
        inst.respawntime = nil
    end
end

local function RebindIsoLicking(inst, iso_licking)
    iso_licking = iso_licking or TheSim:FindFirstEntityWithTag("iso_licking")
    if iso_licking then

        inst.AnimState:PlayAnimation("idle_loop", true)
        inst.components.inventoryitem:ChangeImageName(inst.openEye)
        inst:ListenForEvent("death", function() inst:OnIsoLickingDeath() end, iso_licking)

        if iso_licking.components.follower.leader ~= inst then
            iso_licking.components.follower:SetLeader(inst)
        end
        return true
    end
end

local function RespawnIsoLicking(inst)
    trace("iso_licking_eyebone - RespawnIsoLicking")

    StopRespawn(inst)

    local iso_licking = TheSim:FindFirstEntityWithTag("iso_licking")
    if not iso_licking then
        iso_licking = SpawnIsoLicking(inst)
    end
    RebindIsoLicking(inst, iso_licking)
end

local function StartRespawn(inst, time)
    StopRespawn(inst)

    local respawntime = time or 0
    if respawntime then
        inst.respawntask = inst:DoTaskInTime(respawntime, function() RespawnIsoLicking(inst) end)
        inst.respawntime = GetTime() + respawntime
        inst.AnimState:PlayAnimation("dead", true)
        inst.components.inventoryitem:ChangeImageName(inst.closedEye)
    end
end

local function OnIsoLickingDeath(inst)
    StartRespawn(inst, TUNING.CHESTER_RESPAWN_TIME)
end

local function FixIsoLicking(inst)
	inst.fixtask = nil
	if not RebindIsoLicking(inst) then
        inst.AnimState:PlayAnimation("dead", true)
        inst.components.inventoryitem:ChangeImageName(inst.closedEye)
		
		if inst.components.inventoryitem.owner then
			local time_remaining = 0
			local time = GetTime()
			if inst.respawntime and inst.respawntime > time then
				time_remaining = inst.respawntime - time		
			end
			StartRespawn(inst, time_remaining)
		end
	end
end

local function OnPutInInventory(inst)
	if not inst.fixtask then
		inst.fixtask = inst:DoTaskInTime(1, function() FixIsoLicking(inst) end)	
	end
end

local function OnSave(inst, data)
    trace("iso_licking_eyebone - OnSave")
    local time = GetTime()
    if inst.respawntime and inst.respawntime > time then
        data.respawntimeremaining = inst.respawntime - time
    end
end


local function OnLoad(inst, data)
    if data and data.respawntimeremaining then
		inst.respawntime = data.respawntimeremaining + GetTime()
	end
end

local function GetStatus(inst)
    trace("smallbird - GetStatus")
    if inst.respawntask then
        return "WAITING"
    end
end


local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	
	inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("iso_licking_eyebone.tex")

    inst:AddTag("iso_licking_eyebone")
    inst:AddTag("irreplaceable")
	inst:AddTag("nonpotatable")

    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("eyebone")
    inst.AnimState:SetBuild("licking_isobone") -- mod
    inst.AnimState:PlayAnimation("idle_loop", true)

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)
    inst.components.inventoryitem.atlasname = "images/inventoryimages/iso_licking_eyebone.xml" -- mod    
    inst.openEye = "iso_licking_eyebone"
    inst.closedEye = "iso_licking_eyebone" --_closed

    inst.components.inventoryitem:ChangeImageName(inst.openEye)    
    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus
	inst.components.inspectable:RecordViews()

    inst:AddComponent("leader")

    inst.OnLoad = OnLoad
    inst.OnSave = OnSave
    inst.OnIsoLickingDeath = OnIsoLickingDeath

	inst.fixtask = inst:DoTaskInTime(1, function() FixIsoLicking(inst) end)

    return inst
end

return Prefab( "common/inventory/iso_licking_eyebone", fn, assets) 
