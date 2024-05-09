--[[
**************************
    CURENT VERSION: 1.8.4 (FS and BoL);
**************************
--]]
local assets=
{
    Asset("ATLAS", "images/inventoryimages/tpg_licking_eyebone.xml"), -- mod
    Asset("ANIM", "anim/tpg_licking_eyebone.zip"), -- mod
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

local function SpawnTpgLicking(inst)
    trace("tpg_licking_eyebone - SpawnTpgLicking")

    local pt = Vector3(inst.Transform:GetWorldPosition())
    trace("    near", pt)
        
    local spawn_pt = GetSpawnPoint(pt)
    if spawn_pt then
        trace("    at", spawn_pt)
        local tpg_licking = SpawnPrefab("tpg_licking")
        if tpg_licking then
            tpg_licking.Physics:Teleport(spawn_pt:Get())
            tpg_licking:FacePoint(pt.x, pt.y, pt.z)

            return tpg_licking
        end

    else
        -- this is not fatal, they can try again in a new location by picking up the bone again
        trace("tpg_licking_eyebone - SpawnTpgLicking: Couldn't find a suitable spawn point for tpg_licking")
    end
end


local function StopRespawn(inst)
    trace("tpg_licking_eyebone - StopRespawn")
    if inst.respawntask then
        inst.respawntask:Cancel()
        inst.respawntask = nil
        inst.respawntime = nil
    end
end

local function RebindTpgLicking(inst, tpg_licking)
    tpg_licking = tpg_licking or TheSim:FindFirstEntityWithTag("tpg_licking")
    if tpg_licking then

        inst.AnimState:PlayAnimation("idle_loop", true)
        inst.components.inventoryitem:ChangeImageName(inst.openEye)
        inst:ListenForEvent("death", function() inst:OnTpgLickingDeath() end, tpg_licking)

        if tpg_licking.components.follower.leader ~= inst then
            tpg_licking.components.follower:SetLeader(inst)
        end
        return true
    end
end

local function RespawnTpgLicking(inst)
    trace("tpg_licking_eyebone - RespawnTpgLicking")

    StopRespawn(inst)

    local tpg_licking = TheSim:FindFirstEntityWithTag("tpg_licking")
    if not tpg_licking then
        tpg_licking = SpawnTpgLicking(inst)
    end
    RebindTpgLicking(inst, tpg_licking)
end

local function StartRespawn(inst, time)
    StopRespawn(inst)

    local respawntime = time or 0
    if respawntime then
        inst.respawntask = inst:DoTaskInTime(respawntime, function() RespawnTpgLicking(inst) end)
        inst.respawntime = GetTime() + respawntime
        inst.AnimState:PlayAnimation("dead", true)
        inst.components.inventoryitem:ChangeImageName(inst.closedEye)
    end
end

local function OnTpgLickingDeath(inst)
    StartRespawn(inst, TUNING.CHESTER_RESPAWN_TIME)
end

local function FixTpgLicking(inst)
	inst.fixtask = nil
	if not RebindTpgLicking(inst) then
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
		inst.fixtask = inst:DoTaskInTime(1, function() FixTpgLicking(inst) end)	
	end
end

local function OnSave(inst, data)
    trace("tpg_licking_eyebone - OnSave")
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
    inst.MiniMapEntity:SetIcon("tpg_licking_eyebone.tex")

    inst:AddTag("tpg_licking_eyebone")
    inst:AddTag("irreplaceable")
	inst:AddTag("nonpotatable")

    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("eyebone")
    inst.AnimState:SetBuild("licking_tpgbone") -- mod
    inst.AnimState:PlayAnimation("idle_loop", true)

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)
    inst.components.inventoryitem.atlasname = "images/inventoryimages/tpg_licking_eyebone.xml" -- mod    
    inst.openEye = "tpg_licking_eyebone"
    inst.closedEye = "tpg_licking_eyebone" --_closed

    inst.components.inventoryitem:ChangeImageName(inst.openEye)    
    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus
	inst.components.inspectable:RecordViews()

    inst:AddComponent("leader")

    inst.OnLoad = OnLoad
    inst.OnSave = OnSave
    inst.OnTpgLickingDeath = OnTpgLickingDeath

	inst.fixtask = inst:DoTaskInTime(1, function() FixTpgLicking(inst) end)

    return inst
end

return Prefab( "common/inventory/tpg_licking_eyebone", fn, assets) 
