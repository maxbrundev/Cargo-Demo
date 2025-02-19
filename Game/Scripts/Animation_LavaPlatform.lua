local Animation_LavaPlatform =
{
    cineStep = 0,
    shakeScript = nil,
    audioSource = nil,
    activated = false,
    arrived = false,
    alpha = 0,
    defaultPosition = nil,
    destPosition = nil
}

function Animation_LavaPlatform:OnStart()
    self.defaultPosition = self.owner:GetTransform():GetLocalPosition()
    self.destPosition = self.defaultPosition + Vector3.new(0, 4.2, 0)
    self.shakeScript = Scenes.GetCurrentScene():FindActorByName("Lava Platform Model"):GetBehaviour("Animation_Shake")
    self.audioSource = self.owner:GetAudioSource()
end

function Animation_LavaPlatform:Activate()
    self.shakeScript:Shake(0.012, 0.08)
    self.audioSource:Play()
    self.activated = true
end

function Animation_LavaPlatform:OnUpdate(deltaTime)
    if self.activated and not self.arrived then
        self.alpha = math.min(self.alpha + deltaTime * 0.165, 1.0)

        self.owner:GetTransform():SetLocalPosition(Vector3.Lerp(self.defaultPosition, self.destPosition, self.alpha))

        if self.alpha >= 1.0 then
            self.arrived = true
        end
    end
end

return Animation_LavaPlatform
