--[[
**************************
	CURENT VERSION: 1.8.4 (FS and BoL);
**************************
--]]
local assets = {
	Asset("ANIM", "anim/licking_basic.zip"),
	Asset("SOUND", "sound/slurper.fsb"),
}

randNum = 0

local prefabs = 
{
	"licking_eyebone",
	"die_fx",
}

local SLEEP_NEAR_LEADER_DISTANCE = TUNING.LICKING_SLEEP_NEAR_LEADER_DISTANCE
local WAKE_TO_FOLLOW_DISTANCE = TUNING.LICKING_WAKE_TO_FOLLOW_DISTANCE

local freq = 750

local function ShouldWakeUp(inst)
    return DefaultWakeTest(inst) or not inst.components.follower:IsNearLeader(WAKE_TO_FOLLOW_DISTANCE)
end

local function ShouldSleep(inst)
    return DefaultSleepTest(inst) and not inst.sg:HasStateTag("open") and inst.components.follower:IsNearLeader(SLEEP_NEAR_LEADER_DISTANCE)
end

local function ShouldKeepTarget(inst, target)
    return false 
end

local function OnOpen(inst)
    if not inst.components.health:IsDead() then
        inst.sg:GoToState("open")
		if inst.components.talker then
		inst.SoundEmitter:PlaySound("dontstarve/creatures/slurper/jump")
		randNum = math.random()
		if randNum < 0.5 then
			inst.components.talker:Say(STRINGS.LICKING_TALK_OPEN1)
		else
			inst.components.talker:Say(STRINGS.LICKING_TALK_OPEN2)
		end
		end
    end
end 

local function OnClose(inst) 
    if not inst.components.health:IsDead() then
        inst.sg:GoToState("close")
		if inst.components.talker then
		inst.SoundEmitter:PlaySound("dontstarve/creatures/slurper/jump")
		randNum = math.random()
		if randNum < 0.5 then
			inst.components.talker:Say(STRINGS.LICKING_TALK_CLOSE1)
		else
			inst.components.talker:Say(STRINGS.LICKING_TALK_CLOSE2)
		end
		end
    end
end 

local function OnStopFollowing(inst) 
    inst:RemoveTag("companion")
	if inst.components.talker then inst.components.talker:Say(STRINGS.LICKING_TALK_STOPFOLLOW) end
end

local function OnStartFollowing(inst) 
    inst:AddTag("companion")
	local eyebone = TheSim:FindFirstEntityWithTag("licking_eyebone")
	inst.leader = eyebone

	if inst.components.talker then
	inst.SoundEmitter:PlaySound("dontstarve/creatures/slurper/jump")
	randNum = math.random()
	if randNum < 0.5 then
		inst.components.talker:Say(STRINGS.LICKING_TALK_FOLLOW1)
	else
		inst.components.talker:Say(STRINGS.LICKING_TALK_FOLLOW2)
    end
	end
end

local slotpos_3x3 = {}

for y = 2, 0, -1 do
    for x = 0, 2 do
        table.insert(slotpos_3x3, Vector3(80*x-80*2+80, 80*y-80*2+80,0))
    end
end

local function OnAttacked(inst, data)
	local attacker = nil

--Taking Fire Damage	
	if inst.components.health.takingfiredamage then
		if inst.components.talker then inst.SoundEmitter:PlaySound("dontstarve/creatures/slurper/jump")
		inst.components.talker:Say(STRINGS.LICKING_TALK_PANICFIRE) end
	end
	
	if inst:HasTag("licking") and 
	data.attacker ~= nil and (data.attacker == inst.components.follower.leader or data.attacker:HasTag("player") or data.attacker:HasTag("lickings_tribe")) then
	--The player or the other Licking attacking us!
		if inst.components.talker then
		inst.SoundEmitter:PlaySound("dontstarve/creatures/slurper/jump")
		randNum = math.random()
		if randNum < 0.3 then
			inst.components.talker:Say(STRINGS.LICKING_TALK_DMGBYHERO1)
		else
			if randNum < 0.6 then
				inst.components.talker:Say(STRINGS.LICKING_TALK_DMGBYHERO2)
			else
				inst.components.talker:Say(STRINGS.LICKING_TALK_DMGBYHERO3)
			end
        end
		end
	attacker = nil
	else
	attacker = data.attacker
	if inst.components.talker then
	inst.SoundEmitter:PlaySound("dontstarve/creatures/slurper/jump")
		randNum = math.random()
		if randNum < 0.25 then
			inst.components.talker:Say(STRINGS.LICKING_TALK_FIGHT1)
		else
			if randNum < 0.5 then
				inst.components.talker:Say(STRINGS.LICKING_TALK_FIGHT2)
			else
				if randNum < 0.75 then
					inst.components.talker:Say(STRINGS.LICKING_TALK_FIGHT3)
				else
					inst.components.talker:Say(STRINGS.LICKING_TALK_FIGHT4)
				end
			end
        end
	end
	end

	inst.components.combat:SetTarget(attacker)
	
end

local function Retarget(inst)
	--Too far, don't find a target
    local homePos = inst.components.knownlocations:GetLocation("home")
    local myPos = Vector3(inst.Transform:GetWorldPosition() )
    if (homePos and distsq(homePos, myPos) > 10*10) then
		if inst.components.talker then inst.SoundEmitter:PlaySound("dontstarve/creatures/slurper/jump")
		inst.components.talker:Say(STRINGS.LICKING_TALK_TOOFAR) end
        return
    end
	
local newtarget = nil

if not Profile:GetValue("following") then
		newtarget = FindEntity(inst, 20, function(guy)
			return  guy.components.combat and 
			inst.components.combat:CanTarget(guy) and
			(guy.components.combat.target == GetPlayer() or GetPlayer().components.combat.target == guy)
		end)
	
	if newtarget then
		if newtarget:HasTag("lickings_tribe") then
			newtarget = nil
		else
			if inst.components.talker then
			inst.SoundEmitter:PlaySound("dontstarve/creatures/slurper/jump")
			randNum = math.random()
			if randNum < 0.6 then
				if randNum < 0.3 then
					inst.components.talker:Say(STRINGS.LICKING_TALK_PROTECT1)
				else
					inst.components.talker:Say(STRINGS.LICKING_TALK_PROTECT2)
				end
			else
				inst.components.talker:Say(STRINGS.LICKING_TALK_PROTECT3)
			end
			end
		end
	end
end

    return newtarget
end

local function KeepTarget(inst, target)
    local homePos = inst.components.knownlocations:GetLocation("home")
    local myPos = Vector3(inst.Transform:GetWorldPosition() )
    if (homePos and distsq(homePos, myPos) > 10*10) then
    	--You've chased too far. Go home.
		if inst.components.talker then inst.components.talker:Say(STRINGS.LICKING_TALK_TOOFAR) end
        return false
    end

    return true
end

local function ontalk(inst, script)
	inst.SoundEmitter:PlaySound("dontstarve/creatures/slurper/rumble")
end

local function GetTeleportaPoint(pt)
    local theta = math.random() * 2 * PI
    local radius = 30

	local offset = FindWalkableOffset(pt, theta, radius, 12, true)
	if offset then
		return pt+offset
	end
end

local function ReTelepotaToMe(inst)
	-- HERE we will look if our owner is too far from us.
	--print("Hi, this is ReTelepotaToMe function!")
	
	local eyebone = TheSim:FindFirstEntityWithTag("licking_eyebone")
	local myPos = Vector3(inst.Transform:GetWorldPosition())
	local homePos = Vector3(eyebone.Transform:GetWorldPosition())

	if (homePos and distsq(homePos, myPos) > 35*35) then
		-- we are very far from eyebone.
		if not (GetPlayer().components.driver.driving) then
			-- Player are on GROUND (ISLAND) so we can Teleporta us to Player
			local spawn_pt = GetTeleportaPoint(homePos)
    		if spawn_pt then
            	inst.Physics:Teleport(spawn_pt:Get())
            	inst:FacePoint(homePos.x, homePos.y, homePos.z)
        	end
        end
	end
	
	-- repeat one time per 20 seconds
	inst:DoTaskInTime(20, function() ReTelepotaToMe(inst) end)
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("licking.tex")

	inst:AddTag("companion")
    inst:AddTag("character")
    inst:AddTag("scarytoprey")
    inst:AddTag("licking")
	inst:AddTag("lickings_tribe")
    inst:AddTag("notraptrigger")
	
	inst.entity:AddTransform()
	inst.Transform:SetFourFaced()
	local trans = inst.entity:AddTransform()
	
	local anim = inst.entity:AddAnimState()
	anim:SetBank("slurper")
	anim:SetBuild("licking_basic")
	anim:PlayAnimation("idle_loop", true) --idle_loop
	
	local sound = inst.entity:AddSoundEmitter()	
	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize( 2, 1.25 )
	
	inst:AddComponent("inspectable")
	inst.components.inspectable:RecordViews()
	
	MakeCharacterPhysics(inst, 10, 0.5)
    MakeMediumBurnableCharacter(inst)
    MakeMediumFreezableCharacter(inst)
	
	inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
	
	inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.LICKING_HEALTH)
    inst.components.health.canmurder = false
	
	inst:AddComponent("locomotor")
    inst.components.locomotor:SetSlowMultiplier( 1 )
    inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.pathcaps = { ignorecreep = false }
    inst.components.locomotor.walkspeed = TUNING.LICKING_WALK_SPEED

    inst:AddComponent("follower")
    inst:ListenForEvent("stopfollowing", OnStopFollowing)
    inst:ListenForEvent("startfollowing", OnStartFollowing)

    inst:AddComponent("knownlocations")

    inst.cansleep = true
	inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(3)
    inst.components.sleeper.testperiod = GetRandomWithVariance(6, 2)
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWakeUp)

	local brain = require "brains/lickingbrain"
	inst:SetBrain(brain)
	inst:SetStateGraph("SGlicking")

	inst:AddComponent("container")
    inst.components.container:SetNumSlots(#slotpos_3x3)
    
    inst.components.container.onopenfn = OnOpen
    inst.components.container.onclosefn = OnClose
    
    inst.components.container.widgetslotpos = slotpos_3x3
    inst.components.container.widgetanimbank = "ui_chest_3x3"
    inst.components.container.widgetanimbuild = "ui_chest_3x3"
    inst.components.container.widgetpos = Vector3(0,200,0)
    inst.components.container.side_align_tip = 160

	local light = inst.entity:AddLight()
	inst:AddComponent("lighttweener")
    inst.components.lighttweener:StartTween(light, 1, 0.5, 0.7, {237/255, 237/255, 209/255}, 0)
	light:Enable(true)

	inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "licking_body"
	
    inst.components.combat:SetAttackPeriod(TUNING.LICKING_ATTACK_SPEED)
    inst.components.combat:SetRange(TUNING.LICKING_ATTACK_RANGE)
    inst.components.combat:SetKeepTargetFunction(KeepTarget)
    inst.components.combat:SetDefaultDamage(TUNING.LICKING_DAMAGE)
    inst.components.combat:SetRetargetFunction(2, Retarget)
    inst:ListenForEvent("attacked", OnAttacked)


--[[*************1.4 version Coming Soon*******************

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.canbepickedup = false --FALSE!!! ;D
	inst.components.inventoryitem.cangoincontainer = false
	inst.components.inventoryitem.nobounce = true
	
--]]
--*******************************************************
	inst:DoTaskInTime(20, function() ReTelepotaToMe(inst) end)

	return inst
end

return Prefab("cave/monsters/licking", fn, assets, prefabs)