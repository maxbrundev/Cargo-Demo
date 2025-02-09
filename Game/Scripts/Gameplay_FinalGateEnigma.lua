local Gameplay_FinalGateEnigma =
{
    rightDoor = nil,
    leftDoor = nil,
    slot = nil,
    activated = false,
    leftNeonMaterialRenderer = nil,
    rightNeonMaterialRenderer = nil,
    targetColor = nil
}

function Gameplay_FinalGateEnigma:OnStart()
    self.rightDoor = Scenes.GetCurrentScene():FindActorByName("Gate Final Right Door"):GetBehaviour("Animation_Door")
    self.leftDoor = Scenes.GetCurrentScene():FindActorByName("Gate Final Left Door"):GetBehaviour("Animation_Door")
    self.slot = Scenes.GetCurrentScene():FindActorByName("Light Cube Trigger"):GetBehaviour("Gameplay_LightCubeSlot")
    self.targetColor = Scenes.GetCurrentScene():FindActorByName("Key Light"):GetLight():GetColor()

    self.leftNeonMaterialRenderer = Scenes.GetCurrentScene():FindActorByName("Final Door Arc Left"):GetMaterialRenderer()
    self.rightNeonMaterialRenderer = Scenes.GetCurrentScene():FindActorByName("Final Door Arc Right"):GetMaterialRenderer()
end

function Gameplay_FinalGateEnigma:UpdateNeonColor()
    self.leftNeonMaterialRenderer:SetUserMatrixElement(3, 0, self.slot.color.x)
    self.leftNeonMaterialRenderer:SetUserMatrixElement(3, 1, self.slot.color.y)
    self.leftNeonMaterialRenderer:SetUserMatrixElement(3, 2, self.slot.color.z)
    self.rightNeonMaterialRenderer:SetUserMatrixElement(3, 0, self.slot.color.x)
    self.rightNeonMaterialRenderer:SetUserMatrixElement(3, 1, self.slot.color.y)
    self.rightNeonMaterialRenderer:SetUserMatrixElement(3, 2, self.slot.color.z)
end

function Gameplay_FinalGateEnigma:OnUpdate(deltaTime)
    self:UpdateNeonColor()

    if not self.activated and self.slot.color == self.targetColor then
        self.owner:GetAudioSource():Play()
        self.activated = true
        self.rightDoor:Activate()
        self.leftDoor:Activate()
    end
end

return Gameplay_FinalGateEnigma
