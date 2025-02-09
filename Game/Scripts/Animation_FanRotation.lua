local Animation_FanRotation =
{
    eulerAngles = Vector3.new(0, 0, 0),
    degreesPerSeconds = 180
}

function Animation_FanRotation:OnAwake()
    self.eulerAngles = self.owner:GetTransform():GetRotation():EulerAngles()
end

function Animation_FanRotation:OnUpdate(deltaTime)
    self.eulerAngles.y = self.eulerAngles.y + self.degreesPerSeconds * deltaTime
    self.owner:GetTransform():SetRotation(Quaternion.new(self.eulerAngles))
end

return Animation_FanRotation
