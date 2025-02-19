local Managers_CinematicManager =
{
    cargoShaker = nil,
    cineStep = 0,
    elasped = 0,
    ambientRedLight = nil,
    whiteLightFirstGroup = nil,
    whiteLightSecondGroup = nil,
    cameraFadeManager = nil,
    playerCapsule = nil
}

function Managers_CinematicManager:OnAwake()
    self.cargoShaker = Scenes.GetCurrentScene():FindActorByName("CargoModel"):GetBehaviour("Animation_Shake")
    self.ambientRedLight = Scenes.GetCurrentScene():FindActorByName("Ambient Red"):GetLight()
    self.whiteLightFirstGroup = Scenes.GetCurrentScene():FindActorsByTag("WhiteLight1")
    self.whiteLightSecondGroup = Scenes.GetCurrentScene():FindActorsByTag("WhiteLight2")
    self.cameraFadeManager = Scenes.GetCurrentScene():FindActorByName("Camera Fade Manager"):GetBehaviour("Managers_CameraFade")
    self.playerCapsule = Scenes:GetCurrentScene():FindActorByName("Player"):GetPhysicalCapsule()
end

function Managers_CinematicManager:OnUpdate(deltaTime)
    self.elasped = self.elasped + deltaTime
    if self.cineStep < 1 then -- Clignote
        self.cameraFadeManager:FadeBlack(1, 0)
        self.cineStep = 1
        self.cargoShaker:Shake(0.001, 0.01)
        self.playerCapsule:AddImpulse(Vector3.new(0, 6, 0))
        self.playerCapsule:SetLinearFactor(Vector3.new(1, 0.01, 1))
    elseif self.elasped > 7.5 and self.cineStep < 2 then -- Buzzer Part 1
        self.cargoShaker:StopShaking()
        self.cargoShaker:Shake(0.001, 0.02)
        self.playerCapsule:SetLinearFactor(Vector3.new(1, 1, 1))
        self.playerCapsule:AddImpulse(Vector3.new(0, 6, 0))
        self.playerCapsule:SetLinearFactor(Vector3.new(1, 0.015, 1))
        self.cineStep = 2
    elseif self.elasped > 10.0 and self.cineStep < 3 then -- Buzzer Part 2
        self.cineStep = 3
    elseif self.elasped > 15.0 and self.cineStep < 4 then  -- Final Part 1
        self.cineStep = 4
    elseif self.elasped > 18.0 and self.cineStep < 5 then  -- Final Part 2
        self.cargoShaker:StopShaking()
        self.cargoShaker:Shake(0.001, 0.045)
        self.cameraFadeManager:FadeWhite(2, 1)
        self.playerCapsule:SetLinearFactor(Vector3.new(1, 1, 1))
        self.playerCapsule:AddImpulse(Vector3.new(0, 15, 0))
        self.playerCapsule:SetLinearFactor(Vector3.new(1, 0.05, 1))
        self.cineStep = 5
    end

    if self.cineStep == 1 then
        self.ambientRedLight:SetIntensity((math.sin(self.elasped * 5.0) + 1) / 4)
    elseif self.cineStep == 2 then
        self.ambientRedLight:SetIntensity((math.sin(self.elasped * 10.0) + 1) / 3)
        for id, light in pairs(self.whiteLightFirstGroup) do
            light:GetPointLight():SetIntensity(Math.Lerp(light:GetPointLight():GetIntensity(), 0.0, 20 * deltaTime))
        end
    elseif self.cineStep == 3 then
        self.ambientRedLight:SetIntensity((math.sin(self.elasped * 15.0) + 1) / 3)
        for id, light in pairs(self.whiteLightSecondGroup) do
            light:GetPointLight():SetIntensity((math.sin(self.elasped * 20.0) + 1) / 3)
        end
    elseif self.cineStep == 3 then
        self.ambientRedLight:SetIntensity((math.sin(self.elasped * 15.0) + 1) / 3)
        for id, light in pairs(self.whiteLightSecondGroup) do
            light:GetPointLight():SetIntensity(Math.Lerp(light:GetPointLight():GetIntensity(), 0.2, 20 * deltaTime))
        end
    elseif self.cineStep == 4 or self.cinestep == 5 then
        self.ambientRedLight:SetIntensity((math.sin(self.elasped * 10.0) + 1) / 3)
        for id, light in pairs(self.whiteLightFirstGroup) do
            light:GetPointLight():SetIntensity((math.sin(self.elasped * 20.0) + 1) / 3)
        end
    end

    if self.elasped > 24.25 then
        Scenes.Load("Scenes\\Game.ovscene")
    end
end

return Managers_CinematicManager
