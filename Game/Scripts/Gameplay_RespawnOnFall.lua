local Gameplay_RespawnOnFall =
{
    defaultPosition = nil,
    defaultRotation = nil,
    transform = nil,
    physicalObject = nil
}

function Gameplay_RespawnOnFall:OnStart()
    self.transform = self.owner:GetTransform()
    self.physicalObject = self.owner:GetPhysicalObject()

    self.defaultPosition = self.transform:GetLocalPosition()
    self.defaultRotation = self.transform:GetLocalRotation()
end

function Gameplay_RespawnOnFall:Respawn()
    self.transform:SetLocalPosition(self.defaultPosition)
    self.transform:SetLocalRotation(self.defaultRotation)
end

function Gameplay_RespawnOnFall:OnUpdate(deltaTime)
    yPos = self.transform:GetWorldPosition().y
    if not self.physicalObject:IsTrigger() and (yPos < -2.5 or yPos > 3.5) then
        self:Respawn()
    end
end

return Gameplay_RespawnOnFall
