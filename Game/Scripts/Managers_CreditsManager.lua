local Managers_CreditsManager =
{
    cameraFadeManager = nil,
    jukebox = nil,
    elapsed = 0,
    cineStep = 0
}

function Managers_CreditsManager:OnStart()
    self.jukebox = Scenes.GetCurrentScene():FindActorByName("Jukebox"):GetAudioSource()
    self.cameraFadeManager = Scenes.GetCurrentScene():FindActorByName("Camera Fade Manager"):GetBehaviour("Managers_CameraFade")
    self.cameraFadeManager:FadeBlack(0.5, 0)
end

function Managers_CreditsManager:OnUpdate(deltaTime)
    self.elapsed = self.elapsed + deltaTime

    if self.elapsed < 10 and self.cinestep ~= 1 then
        self.cineStep = 1
    elseif self.elapsed < 15 and self.cinestep ~= 2 then
        self.cineStep = 2
        self.cameraFadeManager:FadeBlack(1.5, 1.0)
        self.jukebox:SetVolume((15 - self.elapsed) / 5)
    elseif self.elapsed > 15 then
        Scenes.Load("Scenes\\Menu.ovscene")
    end
end

return Managers_CreditsManager
