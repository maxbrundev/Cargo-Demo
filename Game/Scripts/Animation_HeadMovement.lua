local Animation_HeadMovement =
{
    physicalObject = nil,
    startPosition = nil,
    currentTime = 0.0
}

function Animation_HeadMovement:OnStart()
    self.physicalObject = self.owner:GetParent():GetPhysicalObject()
    self.startPosition = self.owner:GetTransform():GetLocalPosition()
end

function Animation_HeadMovement:OnUpdate(deltaTime)
    if self.physicalObject ~= nil and self.physicalObject:GetLinearVelocity():Length() > 0.2 then
        self.currentTime = self.currentTime + deltaTime
    else
        self.currentTime = self.currentTime + (deltaTime / 10.0)
    end
    
    animationSpeed = math.sin(self.currentTime * 10.0) 
    
    self.owner:GetTransform():SetPosition(self.startPosition + Vector3.new(0.0, animationSpeed * 0.025, 0.0))
    self.owner:GetTransform():SetRotation(self.owner:GetTransform():GetLocalRotation() * Quaternion.new(Vector3.new(0.0, 0.0, animationSpeed * 0.1)))
end

return Animation_HeadMovement
