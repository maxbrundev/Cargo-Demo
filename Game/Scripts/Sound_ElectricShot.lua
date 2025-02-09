local Sound_ElectricShot =
{
    audioSource = nil,
    sounds = nil
}

function Sound_ElectricShot:OnStart()
    self.audioSource = self.owner:GetAudioSource()
    self.sounds = 
    {
        Resources.GetSound("Sounds\\Electric_Shot_01.ogg"),
        Resources.GetSound("Sounds\\Electric_Shot_02.ogg"),
        Resources.GetSound("Sounds\\Electric_Shot_03.ogg"),
        Resources.GetSound("Sounds\\Electric_Shot_04.ogg"),
        Resources.GetSound("Sounds\\Electric_Shot_05.ogg")
    }
end

function Sound_ElectricShot:Play()
    self.audioSource:SetSound(self.sounds[math.random(1, 5)])
    self.audioSource:Play()
end

return Sound_ElectricShot
