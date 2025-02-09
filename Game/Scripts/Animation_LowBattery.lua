local Animation_LowBattery =
{
    defaultPosition = nil,
    elapsed = 0
}

function Animation_LowBattery:OnStart()
    self.defaultPosition = self.owner:GetTransform():GetLocalPosition()
end

function Animation_LowBattery:OnUpdate(deltaTime)
    self.elapsed = self.elapsed + deltaTime
    self.owner:GetTransform():SetLocalPosition(self.defaultPosition + Vector3.new(0, math.sin(self.elapsed * 2) * 0.1, 0))
end

return Animation_LowBattery
