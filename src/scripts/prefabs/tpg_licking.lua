--[[
**************************
	CURENT VERSION: 1.8.4 (FS and BoL);
**************************
--]]
local assets = {
	Asset("ANIM", "anim/tpg_licking_basic.zip"),
	Asset("SOUND", "sound/slurper.fsb"),
}

randNum = 0

local prefabs = 
{
	"beardhair",
	"tpg_licking_eyebone",
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

local function OnStopFollowing(inst) 
    inst:RemoveTag("companion")
	if inst.components.talker then inst.components.talker:Say(STRINGS.TPG_LICKING_TALK_STOPFOLLOW) end
end

local function OnStartFollowing(inst) 
    inst:AddTag("companion")
	local tpgeyebone = TheSim:FindFirstEntityWithTag("tpg_licking_eyebone")
	inst.leader = tpgeyebone

	if inst.components.talker then
	inst.SoundEmitter:PlaySound("dontstarve/creatures/slurper/jump")
	randNum = math.random()
	if randNum < 0.5 then
		inst.components.talker:Say(STRINGS.TPG_LICKING_TALK_FOLLOW1)
	else
		inst.components.talker:Say(STRINGS.TPG_LICKING_TALK_FOLLOW2)
    end
	end
end

local function OnAttacked(inst, data)
	local attacker = nil

--Taking Fire Damage	
	if inst.components.health.takingfiredamage then
		if inst.components.talker then inst.SoundEmitter:PlaySound("dontstarve/creatures/slurper/jump")
		inst.components.talker:Say(STRINGS.TPG_LICKING_TALK_PANICFIRE) end
	end
	
	if inst:HasTag("tpg_licking") and 
	data.attacker ~= nil and (data.attacker == inst.components.follower.leader or data.attacker:HasTag("player") or data.attacker:HasTag("lickings_tribe")) then
	--The player or the other Licking attacking us!
		if inst.components.talker then
		inst.SoundEmitter:PlaySound("dontstarve/creatures/slurper/jump")
		randNum = math.random()
		if randNum < 0.3 then
			inst.components.talker:Say(STRINGS.TPG_LICKING_TALK_DMGBYHERO1)
		else
			if randNum < 0.6 then
				inst.components.talker:Say(STRINGS.TPG_LICKING_TALK_DMGBYHERO2)
			else
				inst.components.talker:Say(STRINGS.TPG_LICKING_TALK_DMGBYHERO3)
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
			inst.components.talker:Say(STRINGS.TPG_LICKING_TALK_FIGHT1)
		else
			if randNum < 0.5 then
				inst.components.talker:Say(STRINGS.TPG_LICKING_TALK_FIGHT2)
			else
				if randNum < 0.75 then
					inst.components.talker:Say(STRINGS.TPG_LICKING_TALK_FIGHT3)
				else
					inst.components.talker:Say(STRINGS.TPG_LICKING_TALK_FIGHT4)
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
		inst.components.talker:Say(STRINGS.TPG_LICKING_TALK_TOOFAR) end
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
					inst.components.talker:Say(STRINGS.TPG_LICKING_TALK_PROTECT1)
				else
					inst.components.talker:Say(STRINGS.TPG_LICKING_TALK_PROTECT2)
				end
			else
				inst.components.talker:Say(STRINGS.TPG_LICKING_TALK_PROTECT3)
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
		if inst.components.talker then inst.components.talker:Say(STRINGS.TPG_LICKING_TALK_TOOFAR) end
        return false
    end

    return true
end

local function ontalk(inst, script)
	inst.SoundEmitter:PlaySound("dontstarve/creatures/slurper/rumble")
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("tpg_licking.tex")

	inst:AddTag("companion")
    inst:AddTag("character")
    inst:AddTag("scarytoprey")
    inst:AddTag("tpg_licking")
	inst:AddTag("lickings_tribe")
    inst:AddTag("notraptrigger")
	
	inst.entity:AddTransform()
	inst.Transform:SetFourFaced()
	local trans = inst.entity:AddTransform()
	
	local anim = inst.entity:AddAnimState()
	anim:SetBank("slurper")
	anim:SetBuild("tpgking_basic")
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
    inst.components.locomotor.walkspeed = TUNING.TPG_LICKING_WALK_SPEED

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

	local brain = require "brains/tpg_lickingbrain"
	inst:SetBrain(brain)
	inst:SetStateGraph("SGtpglicking")

 	local light = inst.entity:AddLight()
	inst:AddComponent("lighttweener")
    inst.components.lighttweener:StartTween(light, 1, 0.5, 0.7, {237/255, 237/255, 209/255}, 0)
	light:Enable(true)

--Unique stats of TPG-Slurper'
	inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.TPG_LICKING_HEALTH)
    inst.components.health.canmurder = false

	inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "tpgking_body"
    inst.components.combat:SetAttackPeriod(TUNING.TPG_LICKING_ATTACK_SPEED)
    inst.components.combat:SetRange(TUNING.TPG_LICKING_ATTACK_RANGE)
    inst.components.combat:SetKeepTargetFunction(KeepTarget)
    inst.components.combat:SetDefaultDamage(TUNING.TPG_LICKING_DAMAGE)
    inst.components.combat:SetRetargetFunction(2, Retarget)
	inst.components.combat.target = nil
    inst:ListenForEvent("attacked", OnAttacked)

-------------------Beard---------------------
	inst:AddComponent("beard")
    inst.components.beard.onreset = function()
		inst.components.talker:Say(STRINGS.TPG_LICKING_TALK_SHAVE)
		inst.AnimState:ClearOverrideSymbol("beard")
    end
    inst.components.beard.prize = "beardhair"
	
	local beard_days = {3, 6, 9, 12, 15, 18, 21}
	local beard_bits = {1, 2, 3, 4, 5, 6, 7}
	
inst.components.beard:AddCallback(beard_days[1], function() inst.components.beard.bits = beard_bits[1] end)
inst.components.beard:AddCallback(beard_days[2], function() inst.components.beard.bits = beard_bits[2] end)    
inst.components.beard:AddCallback(beard_days[3], function() inst.components.beard.bits = beard_bits[3] end)
inst.components.beard:AddCallback(beard_days[4], function() inst.components.beard.bits = beard_bits[4] end)
inst.components.beard:AddCallback(beard_days[5], function() inst.components.beard.bits = beard_bits[5] end)
inst.components.beard:AddCallback(beard_days[6], function() inst.components.beard.bits = beard_bits[6] end)
inst.components.beard:AddCallback(beard_days[7], function() inst.components.beard.bits = beard_bits[7] end)
-----------------End of Beard------------------

	return inst
end

return Prefab("cave/monsters/tpg_licking", fn, assets, prefabs)