local Animation_EnergyTankLight =
{
    light = nil,
    elapsed = 0,
    waitingForEnergy = true
}

function Animation_EnergyTankLight:OnStart()
    self.light = self.owner:GetLight()
end

function Animation_EnergyTankLight:OnUpdate(deltaTime)
    if self.waitingForEnergy then
        self.elapsed = self.elapsed + deltaTime
        self.light:SetIntensity(math.sin(self.elapsed * 4) + 1)
    else
        self.light:SetIntensity(Math.Lerp(self.light:GetIntensity(), 2.0, 10 * deltaTime))
        self.light:SetColor(Vector3.Lerp(self.light:GetColor(), Vector3.new(0, 1, 1), 10 * deltaTime))
    end
end

return Animation_EnergyTankLight
