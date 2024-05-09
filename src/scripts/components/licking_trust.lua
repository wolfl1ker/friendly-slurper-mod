local LickingTrust = Class(function(self, inst) --Hunger   LickingTrust
	self.inst = inst
	self.min = 0
	self.max = 100
	self.current = self.min
	self.dellta = 0

	self.burning = true --Тратится ли это?
	self.droprate = TUNING.GH_LT_DROPRATE -- Коэфициент траты 1 - количественный
	self.burnrate = TUNING.GH_LT_BURNRATE -- Коэфициент траты 2 - процентный
	self.dropping = TUNING.GH_LT_DROPPING -- Коэфициент траты 3 - Равен либо 1 либо -1

	self.task = self.inst:DoPeriodicTask(1, function() self:DoTasking() end)
	
end)

function LickingTrust:DoTasking()
	if self.burning then
		self:DoDec(1)
	end
end

function LickingTrust:OnSave()
	return {lickingtrust = self.current}
end

function LickingTrust:OnLoad(data)
	if data.lickingtrust then
		self.current = data.lickingtrust
		self:DoDelta(0)
	end
end

function LickingTrust:Pause(G_time)
	self.burning = false
	self.task = self.inst:DoTaskInTime(G_time, function() self:Resume() end)
end

function LickingTrust:Resume()
	self.burning = true
end

function LickingTrust:SetMax(temp3)
	self.max = temp3
end

function LickingTrust:SetPeriod(temp1)
	self.periodMax = temp1
end

function LickingTrust:SetBurnRate(temp2)
	self.burnrate = temp2
end

function LickingTrust:SetNormalDrop()
	self.droprate = TUNING.GH_LT_DROPRATE
	self.burnrate = TUNING.GH_LT_BURNRATE
	self.dropping = TUNING.GH_LT_DROPPING
end

function LickingTrust:SetCustomDrop(newdropping, newdroprate, newburnrate)
	self.dropping = newdropping
	self.droprate = newdroprate
	self.burnrate = newburnrate
end

function LickingTrust:DoDelta(delta)
    
    local old = self.current
    self.current = self.current + delta
    if self.current < self.min then 
        self.current = self.min
    end
	if self.current > self.max then
		self.current = self.max
	end
	self.inst:PushEvent("lickingtrustdelta")
end

function LickingTrust:LongUpdate(dt)
	self:DoDec(dt)
end

function LickingTrust:DoDec(dt)
	local old = self.current
	if self.burning then
		self.dellta = self.burnrate*self.droprate*self.dropping
		self:DoDelta(self.dellta)
	end
end

function LickingTrust:GetDelta()
	if self.burning then
		return self.dellta
	else
		return 0
	end
end

function LickingTrust:GetCurrent()
	return self.current
end
function LickingTrust:GetString()
	local str
	if self.dropping == -1 then
		str = string.format("\nLicking's Trust = %2.2f / %2.2f. DropRate: %d. BurnRate: %2.2f.", self.current, self.max, self.droprate, self.burnrate)
	else
		str = string.format("\nLicking's Trust = %2.2f / %2.2f. DropRate: %d. RegenerateRate: %2.2f.", self.current, self.max, self.droprate, self.burnrate)
	end
	print(str)
end

function LickingTrust:IsTrusted() 
	if self.current > 0 then
		return true
	else
		return false
	end
end

function LickingTrust:GetPenaltyPercent()
	return (self.burnrate*(-self.droprate))/self.max 
end

function LickingTrust:GetPercent()
	return self.current / self.max
end

return LickingTrust