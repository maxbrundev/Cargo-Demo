local Gameplay_Grabbable =
{
    physicalObject = nil,
    grabber = nil,
    lerpSpeed = 10
}

function Gameplay_Grabbable:OnAwake()
    self.physicalObject = self.owner:GetPhysicalObject()
end

function Gameplay_Grabbable:OnUpdate(deltaTime)
    if self.grabber ~= nil then
        targetPos = self.grabber:GetTransform():GetWorldPosition() + self.grabber:GetTransform():GetWorldForward() * 2
        targetRot = self.grabber:GetTransform():GetWorldRotation()

        self.owner:GetTransform():SetPosition(Vector3.Lerp(self.owner:GetTransform():GetPosition(), targetPos, self.lerpSpeed * deltaTime))
        self.owner:GetTransform():SetRotation(Quaternion.Slerp(self.owner:GetTransform():GetRotation(), targetRot, self.lerpSpeed * deltaTime))
    end
end

function Gameplay_Grabbable:Grab(source)
    self.physicalObject:SetLinearVelocity(Vector3.new(0, 0, 0))
    self.physicalObject:SetAngularVelocity(Vector3.new(0, 0, 0))
    self.physicalObject:SetKinematic(true)
    self.physicalObject:SetTrigger(true)
    self.grabber = source
end

function Gameplay_Grabbable:Drop()
    self.grabber = nil
    self.physicalObject:SetKinematic(false)
    self.physicalObject:SetTrigger(false)
end

function Gameplay_Grabbable:IsDroppable()
    return self:IsGrabbed()
end

function Gameplay_Grabbable:IsGrabbed()
    return self.grabber ~= nil
end

return Gameplay_Grabbable
