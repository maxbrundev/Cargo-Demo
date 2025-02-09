local Animation_IronManHelmetItemRotation =
{
    eulerAngles = Vector3.new(0, 0, 0),
    canRotate = true,
    GrabbableBehavior = nil
}

function Animation_IronManHelmetItemRotation:OnAwake()
    self.eulerAngles = self.owner:GetTransform():GetRotation():EulerAngles()
    self.GrabbableBehavior = self.owner:GetBehaviour("Gameplay_Grabbable")
end

function Animation_IronManHelmetItemRotation:OnUpdate(deltaTime)
    if self.GrabbableBehavior.grabber ~= nil then
        self.canRotate = false
    end
    if self.canRotate then
        self.eulerAngles.y = self.eulerAngles.y + 90 * deltaTime
        self.owner:GetTransform():SetRotation(Quaternion.new(self.eulerAngles))
    end
end

return Animation_IronManHelmetItemRotation

