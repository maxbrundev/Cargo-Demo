local Sound_BreathAttenuation =
{
    audioSource = nil,
    elapsed = 0
}

function Sound_BreathAttenuation:OnStart()
    self.audioSource = self.owner:GetAudioSource()
end

function Sound_BreathAttenuation:OnUpdate(deltaTime)
    self.elapsed = self.elapsed + deltaTime

    if self.elapsed > 6 then
        self.audioSource:SetVolume(1 - (self.elapsed - 6) / (23.5 - 6))
    end

end

return Sound_BreathAttenuation
