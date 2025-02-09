local Managers_ScenarioManager =
{
    cameraFadeManager = nil,
    elapsed = 0,
    cineStep = 0
}

function Managers_ScenarioManager:OnStart()
    self.cameraFadeManager = Scenes.GetCurrentScene():FindActorByName("Camera Fade Manager"):GetBehaviour("Managers_CameraFade")
    self.cameraFadeManager:FadeBlack(0.5, 0)
end

function Managers_ScenarioManager:OnUpdate(deltaTime)
    self.elapsed = self.elapsed + deltaTime

    if self.elapsed < 12 and self.cinestep ~= 1 then
        self.cineStep = 1
    elseif self.elapsed < 15 and self.cinestep ~= 2 then
        self.cineStep = 2
        self.cameraFadeManager:FadeBlack(2, 1.0)
    elseif self.elapsed > 15 then
        Scenes.Load("Scenes\\Cinematic.ovscene")
    end
end

return Managers_ScenarioManager
