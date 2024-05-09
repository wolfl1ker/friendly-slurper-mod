--[[
**************************
	CURENT VERSION: 1.8.4 (FS and BoL);
**************************
--]]
local assets = 
{
	Asset("SOUND", "sound/slurper.fsb"),
}

local prefabs = 
{
	"licking_help",
	"die_fx",
}

local randNum = 0
local timer = GetTime() + 30
local SLEEP_NEAR_LEADER_DISTANCE = TUNING.SLEEP_NEAR_LEADER_DISTANCE
local WAKE_TO_FOLLOW_DISTANCE = TUNING.WAKE_TO_FOLLOW_DISTANCE

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
    inst.leader = GetPlayer() -- Он не перестает следовать за игроком ни при каких условиях.
	--inst:RemoveTag("companion")
	inst.components.talker:Say(STRINGS.LICKING_HELPER_TALK_STOPFOLLOW)
end

local function OnStartFollowing(inst) 
    inst:AddTag("companion")
	inst.leader = GetPlayer()

	inst.SoundEmitter:PlaySound("dontstarve/creatures/slurper/jump")
	randNum = math.random()
	if randNum < 0.5 then
		inst.components.talker:Say(STRINGS.LICKING_HELPER_TALK_FOLLOW1)
	else
		inst.components.talker:Say(STRINGS.LICKING_HELPER_TALK_FOLLOW2)
    end
end

local function OnAttacked(inst, data)
	local attacker = nil
	
	if inst.components.health.takingfiredamage then
		inst.SoundEmitter:PlaySound("dontstarve/creatures/slurper/jump")
		inst.components.talker:Say(STRINGS.LICKING_HELPER_TALK_PANICFIRE)
	end
	
	if inst:HasTag("licking_helper") and data.attacker ~= nil and (data.attacker == inst.components.follower.leader or data.attacker:HasTag("player") or data.attacker:HasTag("lickings_tribe")) then
		inst.SoundEmitter:PlaySound("dontstarve/creatures/slurper/jump")
		randNum = math.random()
		if randNum < 0.3 then
			inst.components.talker:Say(STRINGS.LICKING_HELPER_TALK_DMGBYHERO1)
		else
			if randNum < 0.6 then
				inst.components.talker:Say(STRINGS.LICKING_HELPER_TALK_DMGBYHERO2)
			else
				inst.components.talker:Say(STRINGS.LICKING_HELPER_TALK_DMGBYHERO3)
			end
        end
	attacker = nil
	else
	attacker = data.attacker
	inst.SoundEmitter:PlaySound("dontstarve/creatures/slurper/jump")
		randNum = math.random()
		if randNum < 0.25 then
			inst.components.talker:Say(STRINGS.LICKING_HELPER_TALK_FIGHT1)
		else
			if randNum < 0.5 then
				inst.components.talker:Say(STRINGS.LICKING_HELPER_TALK_FIGHT2)
			else
				if randNum < 0.75 then
					inst.components.talker:Say(STRINGS.LICKING_HELPER_TALK_FIGHT3)
				else
					inst.components.talker:Say(STRINGS.LICKING_HELPER_TALK_FIGHT4)
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
		inst.SoundEmitter:PlaySound("dontstarve/creatures/slurper/jump")
		inst.components.talker:Say(STRINGS.LICKING_HELPER_TALK_TOOFAR)
        return
    end

	local newtarget = nil
	
	local newtarget = FindEntity(inst, 20, function(guy)
		return  guy.components.combat and 
        inst.components.combat:CanTarget(guy) and
        (guy.components.combat.target == GetPlayer() or GetPlayer().components.combat.target == guy)
	end)
	
	if newtarget then
		if newtarget:HasTag("lickings_tribe") then
			return nil
		else
			inst.SoundEmitter:PlaySound("dontstarve/creatures/slurper/jump")
			randNum = math.random()
			if randNum < 0.6 then
				if randNum < 0.3 then
					inst.components.talker:Say(STRINGS.LICKING_HELPER_TALK_PROTECT1)
				else
					inst.components.talker:Say(STRINGS.LICKING_HELPER_TALK_PROTECT2)
				end
			else
				inst.components.talker:Say(STRINGS.LICKING_HELPER_TALK_PROTECT3)
			end
		end
	end
	
	if newtarget ~= nil then
		timer = timer + 15 -- Его время жизни увеличивается ТОЛЬКО, если он нашел себе кого атаковать. Ну как берсеркер.
    end
	
	return newtarget
end

local function KeepTarget(inst, target)
    local homePos = inst.components.knownlocations:GetLocation("home")
    local myPos = Vector3(inst.Transform:GetWorldPosition() )
    if (homePos and distsq(homePos, myPos) > 10*10) then
    	--You've chased too far. Go home.
		inst.components.talker:Say(STRINGS.LICKING_HELPER_TALK_TOOFAR)
        return false
    end

    return true
end

local function ontalk(inst, script)
	inst.SoundEmitter:PlaySound("dontstarve/creatures/slurper/jump")
end

local function DeathTimeOver(inst)
	if( timer < GetTime() ) then
		inst.components.health:DoDelta(-900)
	else
		inst:DoTaskInTime(10, function() DeathTimeOver(inst) end)
	end
end

local function fn()
	local inst = CreateEntity()
	
    inst:AddTag("licking_helper")
	inst:AddTag("lickings_tribe")
	inst:AddTag("warguard_legion")
	
	inst:AddTag("companion")
    inst:AddTag("character")
    inst:AddTag("scarytoprey")
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
    inst.components.health:SetMaxHealth(TUNING.GH_HELPER_HP)
    inst.components.health.canmurder = false
	
	inst:AddComponent("locomotor")
    inst.components.locomotor:SetSlowMultiplier( 1 )
    inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.pathcaps = { ignorecreep = false }
    inst.components.locomotor.walkspeed = TUNING.GH_HELPER_WALKSPEED

    inst:AddComponent("follower")
    inst:ListenForEvent("stopfollowing", OnStopFollowing)
    inst:ListenForEvent("startfollowing", OnStartFollowing)

    inst:AddComponent("knownlocations")

    inst.cansleep = true
	inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(TUNING.GH_HELPER_SLEEP_RESIST)
    inst.components.sleeper.testperiod = GetRandomWithVariance(6, 2)
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWakeUp)

	local brain = require "brains/lickinghelperbrain"
	inst:SetBrain(brain)
	inst:SetStateGraph("SGlickingH")

	local light = inst.entity:AddLight()
	inst:AddComponent("lighttweener")
    inst.components.lighttweener:StartTween(light, 1, 0.5, 0.7, {237/255, 237/255, 209/255}, 0)
	light:Enable(true)

	inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "licking_body"
	
    inst.components.combat:SetAttackPeriod(TUNING.GH_HELPER_ATACK_SPEED)
    inst.components.combat:SetRange(TUNING.GH_HELPER_ATACK_RANGE)
    inst.components.combat:SetKeepTargetFunction(KeepTarget)
    inst.components.combat:SetDefaultDamage(TUNING.GH_HELPER_ATACK_DAMAGE)
    inst.components.combat:SetRetargetFunction(2, Retarget)
    inst:ListenForEvent("attacked", OnAttacked)
	
	inst:AddComponent("talker")
	inst.components.talker.ontalk = ontalk
	inst.components.talker.fontsize = 35
	inst.components.talker.font = TALKINGFONT
	inst.components.talker.offset = Vector3(0,-400,0)
	
--*************************
	--MAIN! Anti BuG Setting for Loading and Targeting and Saving.

	inst.components.follower.leader = GetPlayer()

--*************************
	inst.fixtask = inst:DoTaskInTime(TUNING.GH_HELPER_DEATH_TIME, function() DeathTimeOver(inst) end)
	
	return inst
end

return Prefab("cave/monsters/licking_helper", fn, assets, prefabs)