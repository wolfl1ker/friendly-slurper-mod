local UIAnim = require "widgets/uianim"
local Widget = require "widgets/widget"
local Text = require "widgets/text"
local Image = require "widgets/image"

local LickingsBadge = Class(Widget, function(self, owner)
	Widget._ctor(self, "LickingsTrust")
	self.owner = owner
	
	self.owner:AddComponent("licking_trust") -- 2.2.3
	
    self:SetPosition(0,0,0)

    self.active = false

    self.numDrops = 0
    self.drops = {}

    self.licking_trust = 0
    self.active = false

    self.anim = self:AddChild(UIAnim())
	self.anim:GetAnimState():SetBank("licking_trust_meter")
	self.anim:GetAnimState():SetBuild("licking_trust_meter")
	self.anim:SetClickable(true )


	self.arrow = self.anim:AddChild(UIAnim())
	self.arrow:GetAnimState():SetBank("sanity_arrow")
	self.arrow:GetAnimState():SetBuild("sanity_arrow")
	self.arrow:GetAnimState():PlayAnimation("neutral")
	self.arrow:SetClickable(false)

    self.underNumber = self:AddChild(Widget("undernumber"))

    self.num = self:AddChild(Text(BODYTEXTFONT, 33))
    self.num:SetHAlign(ANCHOR_MIDDLE)
    self.num:SetPosition(5, 0, 0)
	self.num:SetClickable(false)
    
    self.num:Hide()

	self:StartUpdating()
end)

function LickingsBadge:UpdateMeter()
	self.anim:GetAnimState():SetPercent("anim", 1-self.licking_trust/100) --self.licking_trust/100
end

function LickingsBadge:OnGainFocus()
	LickingsBadge._base:OnGainFocus(self)
	self.num:Show()
end

function LickingsBadge:OnLoseFocus()
	LickingsBadge._base:OnLoseFocus(self)
	self.num:Hide()
end

function LickingsBadge:UpdateArrowAnim()
	local rate = self.owner.components.licking_trust:GetDelta()
	local small_down = .001
	local med_down = 1.1
	local large_down = 2
	local small_up = .001
	local med_up = .2
	local large_up = .3
	local anim = "neutral"
	if rate > 0 and self.owner.components.licking_trust:GetCurrent() < 100 then
		if rate > large_up then
			anim = "arrow_loop_increase_most"
		elseif rate > med_up then
			anim = "arrow_loop_increase_more"
		elseif rate > small_up then
			anim = "arrow_loop_increase"
		end
	elseif rate < 0 and self.owner.components.licking_trust:GetCurrent() > 0 then
		if rate < -large_down then
			anim = "arrow_loop_decrease_most"
		elseif rate < -med_down then
			anim = "arrow_loop_decrease_more"
		elseif rate < -small_down then
			anim = "arrow_loop_decrease"
		end
	end
	
	if anim and self.arrowdir ~= anim then
		self.arrowdir = anim
		self.arrow:GetAnimState():PlayAnimation(anim, true)
	end
end

function LickingsBadge:OnUpdate(dt)
	self.licking_trust = self.owner.components.licking_trust:GetCurrent() or 0 -- My mistake was there. 12.09.2015
	self.anim:GetAnimState():SetPercent("anim", 1-self.licking_trust/100)
	self.num:SetString(tostring(math.ceil(self.licking_trust)))
	self:UpdateArrowAnim()
end

return LickingsBadge