local Sound_MetalBox =
{
    audioSource = nil,
    sounds = nil
}

function Sound_MetalBox:OnStart()
    self.audioSource = self.owner:GetAudioSource()
    self.sounds = 
    {
        Resources.GetSound("Sounds\\Metal_Hit_01.ogg"),
        Resources.GetSound("Sounds\\Metal_Hit_02.ogg")
    }
end

function Sound_MetalBox:Play(velocity)
    self.audioSource:Stop()
    self.audioSource:SetSound(self.sounds[math.random(1, 2)])
    self.audioSource:Play()
end

function Sound_MetalBox:OnCollisionEnter(other)
    if other:GetOwner():GetTag() ~= "Player" then
        relativeVelocity = Vector3.Distance(other:GetLinearVelocity(), self.owner:GetPhysicalObject():GetLinearVelocity())
        if relativeVelocity > 1.5 then
            self:Play(relativeVelocity)
        end
    end
end

return Sound_MetalBox
