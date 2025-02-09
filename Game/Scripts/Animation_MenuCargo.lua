local Animation_MenuCargo =
{
    elasped = 0,
}

function Animation_MenuCargo:OnUpdate(deltaTime)
    self.owner:GetTransform():SetLocalPosition(Vector3.new(math.sin(self.elasped * 0.1) * 0.03, math.cos(self.elasped * 0.1) * 0.03, 0))
    self.elasped = self.elasped + deltaTime
end

return Animation_MenuCargo
