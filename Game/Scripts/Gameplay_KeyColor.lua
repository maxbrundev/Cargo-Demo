local Gameplay_KeyColor =
{
    materialRenderer = nil,
    light = nil,
    color = nil,
}

function Gameplay_KeyColor:OnStart()
    self.materialRenderer = Scenes.GetCurrentScene():FindActorByName("Key Model"):GetMaterialRenderer()
    self.light = Scenes.GetCurrentScene():FindActorByName("Key Light"):GetLight()

    colorType = math.random(1, 3)
    if colorType == 1 then self.color = Vector3.new(1, 1, 0) end
    if colorType == 2 then self.color = Vector3.new(1, 0, 1) end
    if colorType == 3 then self.color = Vector3.new(0, 1, 1) end

    self.light:SetColor(self.color)
end

function Gameplay_KeyColor:OnUpdate(deltaTime)
    self.materialRenderer:SetUserMatrixElement(3, 0, self.color.x)
    self.materialRenderer:SetUserMatrixElement(3, 1, self.color.y)
    self.materialRenderer:SetUserMatrixElement(3, 2, self.color.z)
end

return Gameplay_KeyColor
