local Animation_AlienBall =
{
    transform = nil,
    defaultPosition = nil,
    elapsed = 0
}

function Animation_AlienBall:OnStart()
    self.transform = self.owner:GetTransform()
    self.defaultPosition = self.transform:GetLocalPosition()
end

function Animation_AlienBall:OnUpdate(deltaTime)
    self.transform:SetLocalPosition(self.defaultPosition + Vector3.new(0, math.sin(self.elapsed) * 0.05, 0))
    self.elapsed = self.elapsed + deltaTime
end

return Animation_AlienBall
