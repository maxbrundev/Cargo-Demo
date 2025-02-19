local Animation_Gun =
{
    physicalObject = nil,
    controller = nil,
    transform = nil,
    playerGun = nil,
    resetRotationSpeed = 15,
    rotationCoefficient = 0,
    rotationFrequency = 2,
    rotationAmplitude = 0.1,
    resetTranslationSpeed = 15,
    translationCoefficient = 0,
    translationFrequency = 2,
    translationAmplitude = 0.005,
    targetRotation = Quaternion.new(Vector3.new(0, 0, 0)),
    hidden = false,
    unlocked = false,
}

function Animation_Gun:OnStart()
    self.physicalObject = self.owner:GetParent():GetParent():GetParent():GetPhysicalObject()
    self.controller = self.owner:GetParent():GetParent():GetParent():GetBehaviour("Controller_FPSController")
    self.transform = self.owner:GetTransform()
    self.playerGun = Scenes.GetCurrentScene():FindActorByName("Player Gun")
    self:Hide()
end

function Animation_Gun:GetMotionVelocity()
    velocity = self.physicalObject:GetLinearVelocity()
    velocity.y = 0
    return Vector3.Length(velocity)
end

function Animation_Gun:ApplyRotations(deltaTime, velocity)
    self.rotationCoefficient = self.rotationCoefficient + deltaTime * velocity
    targetRotation = Quaternion.new(Vector3.new(0, 0, math.sin(self.rotationCoefficient * self.rotationFrequency) * self.rotationAmplitude))
    offset = Quaternion.new()
    if self.controller.running and not self.controller.walkAsked then
        offset = Quaternion.new(Vector3.new(13, 33, 0))
    end
    self.transform:SetLocalRotation(Quaternion.Slerp(self.transform:GetLocalRotation(), targetRotation * offset, 10 * deltaTime))
end

function Animation_Gun:ApplyTranslations(deltaTime, velocity)
    self.translationCoefficient = self.translationCoefficient + deltaTime * velocity

    frequency = self.translationFrequency
    
    if not self.controller.isGrounded then
        frequency = frequency * 0.3
    end

    xTranslation = math.sin(self.translationCoefficient * frequency / 2) * self.translationAmplitude
    yTranslation = math.sin(self.translationCoefficient * frequency) * self.translationAmplitude

    if not self.controller.isGrounded then
        xTranslation = 0
        yTranslation = yTranslation * 3
    end

    self.transform:SetLocalPosition(Vector3.Lerp(self.transform:GetLocalPosition(), Vector3.new(xTranslation, yTranslation, 0), 10 * deltaTime))
end

function Animation_Gun:ResetRotations(deltaTime)
    self.rotationCoefficient = 0
    self.transform:SetLocalRotation(Quaternion.Slerp(self.transform:GetLocalRotation(), self.targetRotation, self.resetRotationSpeed * deltaTime))
end

function Animation_Gun:ResetTranslations(deltaTime)
    self.translationCoefficient = 0
    self.transform:SetLocalPosition(Vector3.Lerp(self.transform:GetLocalPosition(), Vector3.Zero(), self.resetTranslationSpeed * deltaTime))
end

function Animation_Gun:OnUpdate(deltaTime)
    velocity = self:GetMotionVelocity()

    if velocity > 0.5 and not self.hidden then
        self:ApplyRotations(deltaTime, velocity)
        self:ApplyTranslations(deltaTime, velocity)
    else
        self:ResetRotations(deltaTime)
        self:ResetTranslations(deltaTime)
    end
end

function Animation_Gun:Unlock()
    self.unlocked = true
end

function Animation_Gun:Show()
    if self.unlocked then
        self.targetRotation = Quaternion.new(Vector3.new(0, 0, 0))
        self.playerGun:GetAudioSource():Play()
        self.hidden = false
    end
end

function Animation_Gun:Hide()
    self.targetRotation = Quaternion.new(Vector3.new(45, 0, 0))
    self.hidden = true
end

return Animation_Gun
