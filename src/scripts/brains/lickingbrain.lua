require "behaviours/follow" --1.1
require "behaviours/wander" --1.1
require "behaviours/faceentity" --1.1
require "behaviours/panic" --1.2
require "behaviours/chaseandattack" --1.3
require "behaviours/doaction" --1.3
require "behaviours/runaway" --1.3
--require "behaviours/chattynode" --1.4

local MIN_FOLLOW_DIST = 0
local MAX_FOLLOW_DIST = 10
local TARGET_FOLLOW_DIST = 4

local MAX_WANDER_DIST = 4


local function GetFaceTargetFn(inst)
    return inst.components.follower.leader
end

local function KeepFaceTargetFn(inst, target)
    return inst.components.follower.leader == target
end


local LickingBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)


function LickingBrain:OnStart()
    local root = 
	
	PriorityNode({
        WhileNode( function() return self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst)),
			Follow(self.inst, function() return self.inst.components.follower.leader end, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST),
			WhileNode( function() return self.inst.components.combat.target == nil or not self.inst.components.combat:InCooldown() end, "AttackMomentarily",
			ChaseAndAttack(self.inst, 60, 100)),
			FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn),
			Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, MAX_WANDER_DIST),
        
    }, .25)
	--]]
    self.bt = BT(self.inst, root)
end

return LickingBrain