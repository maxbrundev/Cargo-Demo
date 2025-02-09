local Sound_Footsteps =
{
    playerController = nil,
    walkAudioSource = nil,
    runAudioSource = nil,
    physicalObject = nil
}

function Sound_Footsteps:OnStart()
    self.playerController = Scenes.GetCurrentScene():FindActorByName("Player"):GetBehaviour("Controller_FPSController")
    self.walkAudioSource = Scenes.GetCurrentScene():FindActorByName("WalkAudioSource"):GetAudioSource()
    self.runAudioSource = Scenes.GetCurrentScene():FindActorByName("RunAudioSource"):GetAudioSource()
    self.physicalObject = self.owner:GetPhysicalObject()
end

function Sound_Footsteps:OnUpdate(deltaTime)
    horizontalVelocity = self.physicalObject:GetLinearVelocity()
    horizontalVelocity.y = 0

    velocityMagnitude = Vector3.Length(horizontalVelocity)

    if velocityMagnitude < 1.0 or not self.playerController.isGrounded then
        self.runAudioSource:SetVolume(0.0)
        self.walkAudioSource:SetVolume(0.0)
    elseif velocityMagnitude < 5.0 then
        self.runAudioSource:SetVolume(0.0)
        self.walkAudioSource:SetVolume(1.0)
    else
        self.runAudioSource:SetVolume(1.0)
        self.walkAudioSource:SetVolume(0.0)
    end
end

return Sound_Footsteps
