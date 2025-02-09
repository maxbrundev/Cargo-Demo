local Managers_GameManager =
{
    player = nil,
    fadeManager = nil,
    restartAsked = false,
    restartDelay = 0,
    restartElapsed = 0,
    exitAsked = false,
    exitDelay = 0,
    exitElapsed = 0,
    playerDied = false,
    levelEnded = false,
    jukebox = nil
}

function Managers_GameManager:OnStart()
    self.player = Scenes.GetCurrentScene():FindActorByName("Player")
    self.fadeManager = Scenes.GetCurrentScene():FindActorByName("Fade Manager"):GetBehaviour("Managers_CameraFade")
    self.fadeManager:FadeWhite(0.35, 0.0)
    self.jukebox = Scenes.GetCurrentScene():FindActorByName("Jukebox"):GetAudioSource()
end

function Managers_GameManager:OnUpdate(deltaTime)
    if self.player:GetTransform():GetWorldPosition().y < -3.3 then
        self:OnPlayerDeath()
    end

    if self.exitAsked then
        self.exitElapsed = self.exitElapsed + deltaTime
        self.jukebox:SetVolume(1 - self.exitElapsed / self.exitDelay)
        if self.exitElapsed >= self.exitDelay then
            self:LoadCredits()
        end
    elseif self.restartAsked then
        self.restartElapsed = self.restartElapsed + deltaTime
        if self.restartElapsed >= self.restartDelay then
            self:RestartLevel()
        end
    end
end

function Managers_GameManager:OnPlayerDeath()
    if not self.playerDied then
        Scenes.GetCurrentScene():FindActorByName("Lava Splash Sound"):GetAudioSource():Play()
        self.playerDied = true
        self.player:GetPhysicalObject():SetKinematic(true)
        self:RestartLevelAfterDelay(2.0)
    end
end

function Managers_GameManager:OnLevelEnd()
    if not self.levelEnded then
        self.levelEnded = true
        self:ExitLevelAfterDelay(3.0)
    end
end

function Managers_GameManager:RestartLevelAfterDelay(delay)
    self.restartAsked = true
    self.restartDelay = delay
    self.fadeManager:FadeWhite(10.0, 1.0)
end

function Managers_GameManager:ExitLevelAfterDelay(delay)
    self.exitAsked = true
    self.exitDelay = delay
    self.fadeManager:FadeBlack(3.0, 1.0)
end

function Managers_GameManager:RestartLevel()
    Scenes.Load("Scenes\\Game.ovscene")
end

function Managers_GameManager:LoadCredits()
    Scenes.Load("Scenes\\Credits.ovscene")
end

return Managers_GameManager
