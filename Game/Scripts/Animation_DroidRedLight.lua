local Animation_DroidRedLight =
{
    light = nil,
    elapsed = 0
}

function Animation_DroidRedLight:OnStart()
    self.light = self.owner:GetLight()
end

function Animation_DroidRedLight:OnUpdate(deltaTime)
    self.elapsed = self.elapsed + deltaTime
    self.light:SetIntensity((math.sin(self.elapsed * 10) + 1) / 2)
end

return Animation_DroidRedLight
