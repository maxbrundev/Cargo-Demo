local Gameplay_BallRecall =
{
    elecBall = nil,
    recalling = false,
    recallAudioSource = nil,
    gunShaker = nil,
    gunLight = nil,
    grabber = nil,
    playerCamera = nil,
    gunAnim = nil
}

function Gameplay_BallRecall:OnStart()
    self.elecBall = Scenes.GetCurrentScene():FindActorByName("Energy Ball")
    self.recallAudioSource = self.owner:GetAudioSource()
    self.gunShaker = self.owner:GetParent():GetBehaviour("Animation_Shake")
    self.gunLight = self.owner:GetPointLight()
    self.grabber = self.owner:GetParent():GetParent():GetParent():GetBehaviour("Gameplay_Grabber")
    self.playerCamera = self.owner:GetParent():GetParent():GetParent()
    self.gunAnim = self.owner:GetParent():GetParent():GetBehaviour("Animation_Gun")
end

function Gameplay_BallRecall:OnUpdate(deltaTime)
    if not self.gunAnim.hidden then
        if Inputs.GetMouseButton(MouseButton.BUTTON_RIGHT) and self.grabber.grabbed == nil and self.elecBall:IsActive() then
            if not self.recalling then
                self:StartRecalling()
            end

            self:OnRecall(deltaTime)
        else
            if self.recalling then
                self:StopRecalling()
            end

            self:OnNotRecall(deltaTime)
        end
    end
end

function Gameplay_BallRecall:StartRecalling()
    self.elecBall:GetPhysicalObject():SetKinematic(true)
    self.recallAudioSource:SetVolume(1.0)
    self.recallAudioSource:Stop()
    self.recallAudioSource:Play()
    self.gunShaker:Shake(0.0, 0.002)
    self.recalling = true
end

function Gameplay_BallRecall:StopRecalling()
    self.elecBall:GetPhysicalObject():SetKinematic(false)
    self.gunShaker:StopShaking()
    self.recalling = false
end

function Gameplay_BallRecall:OnRecall(deltaTime)
    destination = self.playerCamera:GetTransform():GetWorldPosition() + self.playerCamera:GetTransform():GetWorldForward()
    self.elecBall:GetTransform():SetLocalPosition(Vector3.Lerp(self.elecBall:GetTransform():GetLocalPosition(), destination, deltaTime * 0.5))
    self.gunLight:SetIntensity(Math.Lerp(self.gunLight:GetIntensity(), 4.0, deltaTime * 0.25))
    if Vector3.Distance(destination, self.elecBall:GetTransform():GetWorldPosition()) < 1.0 then
        self:StopRecalling()
        grabbable = self.elecBall:GetBehaviour("Gameplay_Grabbable")
        grabbable:Grab(self.grabber.owner)
        self.grabber.grabbed = grabbable
    end
end

function Gameplay_BallRecall:OnNotRecall(deltaTime)
    self.recallAudioSource:SetVolume(Math.Lerp(self.recallAudioSource:GetVolume(), 0.0, 10 * deltaTime))
    self.gunLight:SetIntensity(Math.Lerp(self.gunLight:GetIntensity(), 0.0, deltaTime * 10))
end

return Gameplay_BallRecall
