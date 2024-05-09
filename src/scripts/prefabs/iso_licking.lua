--[[
**************************
	CURENT VERSION: 1.8.4 (FS and BoL);
**************************
--]]

local assets = {
	Asset("ANIM", "anim/iso_licking_basic.zip"),
	Asset("SOUND", "sound/slurper.fsb"),
}

randNum = 0

local prefabs = 
{
	"iso_licking_eyebone",
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
			inst.components.talker:Say(STRINGS.ISO_LICKING_TALK_OPEN1)
		else
			inst.components.talker:Say(STRINGS.ISO_LICKING_TALK_OPEN2)
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
			inst.components.talker:Say(STRINGS.ISO_LICKING_TALK_CLOSE1)
		else
			inst.components.talker:Say(STRINGS.ISO_LICKING_TALK_CLOSE2)
		end
		end
    end
end 

local function OnStopFollowing(inst) 
	inst:RemoveTag("companion")
	if inst.components.talker then inst.components.talker:Say(STRINGS.ISO_LICKING_TALK_STOPFOLLOW) end
end

local function OnStartFollowing(inst) 
    inst:AddTag("companion")
	local isoeyebone = TheSim:FindFirstEntityWithTag("iso_licking_eyebone")
	inst.leader = isoeyebone

	if inst.components.talker then
	inst.SoundEmitter:PlaySound("dontstarve/creatures/slurper/jump")
	randNum = math.random()
	if randNum < 0.5 then
		inst.components.talker:Say(STRINGS.ISO_LICKING_TALK_FOLLOW1)
	else
		inst.components.talker:Say(STRINGS.ISO_LICKING_TALK_FOLLOW2)
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
		inst.components.talker:Say(STRINGS.ISO_LICKING_TALK_PANICFIRE) end
	end
	
	if inst:HasTag("iso_licking") and 
	data.attacker ~= nil and (data.attacker == inst.components.follower.leader or data.attacker:HasTag("player") or data.attacker:HasTag("lickings_tribe")) then
	--The player or the other Licking attacking us!
		if inst.components.talker then
		inst.SoundEmitter:PlaySound("dontstarve/creatures/slurper/jump")
		randNum = math.random()
		if randNum < 0.3 then
			inst.components.talker:Say(STRINGS.ISO_LICKING_TALK_DMGBYHERO1)
		else
			if randNum < 0.6 then
				inst.components.talker:Say(STRINGS.ISO_LICKING_TALK_DMGBYHERO2)
			else
				inst.components.talker:Say(STRINGS.ISO_LICKING_TALK_DMGBYHERO3)
			end
        end
		end
	attacker = nil
	end
	inst.components.combat:SetTarget(attacker)
	
end
	
local function Retarget(inst)
	--Too far, don't find a target
    local homePos = inst.components.knownlocations:GetLocation("home")
    local myPos = Vector3(inst.Transform:GetWorldPosition() )
    if (homePos and distsq(homePos, myPos) > 10*10) then
		if inst.components.talker then
		inst.SoundEmitter:PlaySound("dontstarve/creatures/slurper/jump")
		inst.components.talker:Say(STRINGS.ISO_LICKING_TALK_TOOFAR) end
        return
    end

	local newtarget = nil

    return newtarget
end

local function KeepTarget(inst, target)
    local homePos = inst.components.knownlocations:GetLocation("home")
    local myPos = Vector3(inst.Transform:GetWorldPosition() )
    if (homePos and distsq(homePos, myPos) > 10*10) then
    	--You've chased too far. Go home.
		if inst.components.talker then inst.components.talker:Say(STRINGS.ISO_LICKING_TALK_TOOFAR) end
        return false
    end

    return true
end

local function ontalk(inst, script)
	inst.SoundEmitter:PlaySound("dontstarve/creatures/slurper/rumble")
end

local function itemtest(inst, item, slot)
	return (item.components.edible and item.components.perishable) or item.prefab == "spoiled_food"
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("iso_licking.tex")

	inst:AddTag("companion")
    inst:AddTag("character")
    inst:AddTag("scarytoprey")
    inst:AddTag("iso_licking")
	inst:AddTag("lickings_tribe")
    inst:AddTag("notraptrigger")
	inst:AddTag("fridge")
	
	inst.entity:AddTransform()
	inst.Transform:SetFourFaced()
	local trans = inst.entity:AddTransform()
	
	local anim = inst.entity:AddAnimState()
	anim:SetBank("slurper")
	anim:SetBuild("isoking_basic")
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
	
	inst:AddComponent("locomotor")
    inst.components.locomotor:SetSlowMultiplier( 1 )
    inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.pathcaps = { ignorecreep = false }
    inst.components.locomotor.walkspeed = TUNING.ISO_LICKING_WALK_SPEED

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

	local brain = require "brains/iso_lickingbrain"
	inst:SetBrain(brain)
	inst:SetStateGraph("SGisolicking")

 	local light = inst.entity:AddLight()
	inst:AddComponent("lighttweener")
    inst.components.lighttweener:StartTween(light, 1, 0.5, 0.7, {237/255, 237/255, 209/255}, 0)
	light:Enable(true)
 
	inst:AddComponent("container")
    inst.components.container:SetNumSlots(#slotpos_3x3)
    inst.components.container.itemtestfn = itemtest
	
    inst.components.container.onopenfn = OnOpen
    inst.components.container.onclosefn = OnClose
    
    inst.components.container.widgetslotpos = slotpos_3x3
    inst.components.container.widgetanimbank = "ui_chest_3x3"
    inst.components.container.widgetanimbuild = "ui_chest_3x3"
    inst.components.container.widgetpos = Vector3(0,200,0)
    inst.components.container.side_align_tip = 160


--Дальше идут индивидуальные характеристики ISO-Slurper'a
	inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.ISO_LICKING_HEALTH)
    inst.components.health.canmurder = false

	inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "isoking_body"
    inst.components.combat:SetAttackPeriod(TUNING.ISO_LICKING_ATTACK_SPEED)
    inst.components.combat:SetRange(TUNING.ISO_LICKING_ATTACK_RANGE)
    inst.components.combat:SetKeepTargetFunction(KeepTarget)
    inst.components.combat:SetDefaultDamage(TUNING.ISO_LICKING_DAMAGE)
    inst.components.combat:SetRetargetFunction(3, Retarget)
	inst.components.combat.target = nil
    inst:ListenForEvent("attacked", OnAttacked)


--[[*************1.4 version Coming Soon*******************

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.canbepickedup = false --FALSE!!! ;D
	inst.components.inventoryitem.cangoincontainer = false
	inst.components.inventoryitem.nobounce = true

--*********************************************************
--]]

	return inst
end

return Prefab("cave/monsters/iso_licking", fn, assets, prefabs)