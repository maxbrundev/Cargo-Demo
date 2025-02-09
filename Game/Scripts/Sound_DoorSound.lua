local Sound_DoorSound =
{
    openSound = nil,
    closeSound = nil,
    audioSource = nil
}

function Sound_DoorSound:OnStart()
    self.openSound = Resources.GetSound("Sounds\\Door_Open.ogg")
    self.closeSound = Resources.GetSound("Sounds\\Door_Close.ogg")
    self.audioSource = self.owner:GetAudioSource()
end

function Sound_DoorSound:PlayOpenSound()
    self.audioSource:Stop()
    self.audioSource:SetSound(self.openSound)
    self.audioSource:Play()
end

function Sound_DoorSound:PlayCloseSound()
    self.audioSource:Stop()
    self.audioSource:SetSound(self.closeSound)
    self.audioSource:Play()
end

return Sound_DoorSound
