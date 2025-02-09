local Sound_ElectricHit =
{
    audioSource = nil
}

function Sound_ElectricHit:OnAwake()
    self.audioSource = self.owner:GetAudioSource()
end

function Sound_ElectricHit:OnCollisionEnter()
    self.audioSource:Play()
end

return Sound_ElectricHit
