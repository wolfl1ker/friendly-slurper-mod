--[[
**************************
    CURENT VERSION: 1.8.4 (FS and BoL);
**************************
--]]
local assets=
{
    Asset("ATLAS", "images/inventoryimages/licking_eyebone.xml"), -- mod
    Asset("ANIM", "anim/licking_eyebone.zip"), -- mod
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

local function SpawnLicking(inst)
    trace("licking_eyebone - SpawnLicking")

    local pt = Vector3(inst.Transform:GetWorldPosition())
    trace("    near", pt)
        
    local spawn_pt = GetSpawnPoint(pt)
    if spawn_pt then
        trace("    at", spawn_pt)
        local licking = SpawnPrefab("licking")
        if licking then
            licking.Physics:Teleport(spawn_pt:Get())
            licking:FacePoint(pt.x, pt.y, pt.z)

            return licking
        end

    else
        -- this is not fatal, they can try again in a new location by picking up the bone again
        trace("licking_eyebone - SpawnLicking: Couldn't find a suitable spawn point for licking")
    end
end


local function StopRespawn(inst)
    trace("licking_eyebone - StopRespawn")
    if inst.respawntask then
        inst.respawntask:Cancel()
        inst.respawntask = nil
        inst.respawntime = nil
    end
end

local function RebindLicking(inst, licking)
    licking = licking or TheSim:FindFirstEntityWithTag("licking")
    if licking then

        inst.AnimState:PlayAnimation("idle_loop", true)
        inst.components.inventoryitem:ChangeImageName(inst.openEye)
        inst:ListenForEvent("death", function() inst:OnLickingDeath() end, licking)

        if licking.components.follower.leader ~= inst then
            licking.components.follower:SetLeader(inst)
        end
        return true
    end
end

local function RespawnLicking(inst)
    trace("licking_eyebone - RespawnLicking")

    StopRespawn(inst)

    local licking = TheSim:FindFirstEntityWithTag("licking")
    if not licking then
        licking = SpawnLicking(inst)
    end
    RebindLicking(inst, licking)
end

local function StartRespawn(inst, time)
    StopRespawn(inst)

    local respawntime = time or 0
    if respawntime then
        inst.respawntask = inst:DoTaskInTime(respawntime, function() RespawnLicking(inst) end)
        inst.respawntime = GetTime() + respawntime
        inst.AnimState:PlayAnimation("dead", true)
        inst.components.inventoryitem:ChangeImageName(inst.closedEye)
    end
end

local function OnLickingDeath(inst)
    StartRespawn(inst, TUNING.CHESTER_RESPAWN_TIME)
end

local function FixLicking(inst)
	inst.fixtask = nil
	--take an existing chester if there is one
	if not RebindLicking(inst) then
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
		inst.fixtask = inst:DoTaskInTime(1, function() FixLicking(inst) end)	
	end
end

local function OnSave(inst, data)
    trace("licking_eyebone - OnSave")
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
    inst.MiniMapEntity:SetIcon("licking_eyebone.tex")

    inst:AddTag("licking_eyebone")
    inst:AddTag("irreplaceable")
	inst:AddTag("nonpotatable")

    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("eyebone")
    inst.AnimState:SetBuild("licking_eyebone") -- mod
    inst.AnimState:PlayAnimation("idle_loop", true)

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)
    inst.components.inventoryitem.atlasname = "images/inventoryimages/licking_eyebone.xml" -- mod    
    inst.openEye = "licking_eyebone"
    inst.closedEye = "licking_eyebone" --_closed

    inst.components.inventoryitem:ChangeImageName(inst.openEye)    
    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus
	inst.components.inspectable:RecordViews()

    inst:AddComponent("leader")

    inst.OnLoad = OnLoad
    inst.OnSave = OnSave
    inst.OnLickingDeath = OnLickingDeath

	inst.fixtask = inst:DoTaskInTime(1, function() FixLicking(inst) end)

    return inst
end

return Prefab( "common/inventory/licking_eyebone", fn, assets) 
