local Animation_CargoCrashLight =
{
    light = nil,
    elapsed = 0
}

function Animation_CargoCrashLight:OnStart()
    self.light = self.owner:GetLight()
end

function Animation_CargoCrashLight:OnUpdate(deltaTime)
    self.elapsed = self.elapsed + deltaTime
    self.light:SetIntensity((math.sin(self.elapsed * 2.8) + 1) / 10)
end

return Animation_CargoCrashLight
