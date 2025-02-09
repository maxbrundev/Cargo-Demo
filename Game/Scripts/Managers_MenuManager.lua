local Managers_MenuManager =
{
    cameraFadeManager = nil,
    startAsked = false,
    jukebox = nil,
    delay = 5,
    elapsed = 0
}

function Managers_MenuManager:OnStart()
    Inputs.LockMouse()
    self.jukebox = Scenes.GetCurrentScene():FindActorByName("Jukebox"):GetAudioSource()
    self.cameraFadeManager = Scenes.GetCurrentScene():FindActorByName("Camera Fade Manager"):GetBehaviour("Managers_CameraFade")
    self.cameraFadeManager:FadeBlack(0.5, 0)
end

function Managers_MenuManager:OnUpdate(deltaTime)
    if Inputs.GetKeyDown(Key.SPACE) and not self.startAsked then
        self.cameraFadeManager:FadeBlack(2.0, 1)
        self.startAsked = true
    end

    if self.startAsked then
        self.elapsed = self.elapsed + deltaTime
        self.jukebox:SetVolume(self.delay - self.elapsed)
        if self.elapsed >= self.delay then
            Scenes.Load("Scenes\\Scenario.ovscene")
        end
    end
end

return Managers_MenuManager
