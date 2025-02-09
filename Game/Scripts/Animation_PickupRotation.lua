local Animation_PickupRotation =
{
    eulerAngles = Vector3.new(0, 0, 0),
    enabled = true
}

function Animation_PickupRotation:OnAwake()
    self.eulerAngles = self.owner:GetTransform():GetRotation():EulerAngles()
end

function Animation_PickupRotation:OnUpdate(deltaTime)
    if self.enabled == true then
        self.eulerAngles.y = self.eulerAngles.y + 90 * deltaTime
        self.owner:GetTransform():SetRotation(Quaternion.new(self.eulerAngles))
    end
end

return Animation_PickupRotation
