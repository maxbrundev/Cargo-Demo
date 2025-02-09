local Animation_DroidShake =
{
    shaker = nil,
    nextShake = 0,
    elapsed = 0,
    audioSource = nil
}

function Animation_DroidShake:OnAwake()
    self.shaker = self.owner:GetBehaviour("Animation_Shake")
    self.audioSource = self.owner:GetAudioSource()
    self:GenerateNewFutureShake()
end

function Animation_DroidShake:GenerateNewFutureShake()
    self.nextShake = Math.RandomFloat(0.5, 8)
end

function Animation_DroidShake:OnUpdate(deltaTime)
    self.elapsed = self.elapsed + deltaTime

    if self.elapsed >= self.nextShake then
        self:Shake()
    end
end

function Animation_DroidShake:Shake()
    self.audioSource:Play()
    self.shaker:Shake(0.1, 0.05)
    self.elapsed = 0
    self:GenerateNewFutureShake()
end

return Animation_DroidShake
