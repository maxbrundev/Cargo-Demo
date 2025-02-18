local Gameplay_LightCubeSlot =
{
    triggerCounter = 0,
    body = nil,
    startPosition = nil,
    endPosition =  nil,
    activated = false,
    color = nil
}

function Gameplay_LightCubeSlot:OnAwake()
    self.body = Scenes.GetCurrentScene():FindActorByName("Light Cube Slot Mesh")
    self.startPosition = self.body:GetTransform():GetLocalPosition()
    self.endPosition = self.startPosition - self.owner:GetTransform():GetUp() * 0.13
    self.color = Vector3.new(0, 0, 0)
end

function Gameplay_LightCubeSlot:OnUpdate(deltaTime)
    self:Move(deltaTime)
 end
 
function Gameplay_LightCubeSlot:Move(deltaTime)
    targetPosition = nil

    if self.activated then
        targetPosition = self.endPosition
    else
        targetPosition = self.startPosition
    end

    self.body:GetTransform():SetPosition(Vector3.Lerp(self.body:GetTransform():GetLocalPosition(), targetPosition, 20 * deltaTime))
end

function Gameplay_LightCubeSlot:OnTriggerEnter(other)
    self.triggerCounter = self.triggerCounter + 1
    if self.triggerCounter == 1 then
        self.activated = true
    end

    if other:GetOwner():GetTag() == "LightCube" then
        self.color = self.color + other:GetOwner():GetLight():GetColor()
    end
end

function Gameplay_LightCubeSlot:OnTriggerExit(other)
    self.triggerCounter = self.triggerCounter - 1
    if self.triggerCounter == 0 then
        self.activated = false
    end

    if other:GetOwner():GetTag() == "LightCube" then
        self.color = self.color - other:GetOwner():GetLight():GetColor()
    end
end

return Gameplay_LightCubeSlot
