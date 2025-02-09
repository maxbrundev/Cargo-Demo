local Demo_Rotation =
{
    currentRotation = 0
}

function Demo_Rotation:OnStart()
end

function Demo_Rotation:OnUpdate(deltaTime)
    self.currentRotation = self.currentRotation + 10 * deltaTime
    self.owner:GetTransform():SetLocalRotation(Quaternion.new(Vector3.new(0, self.currentRotation, 0)))
end

return Demo_Rotation
