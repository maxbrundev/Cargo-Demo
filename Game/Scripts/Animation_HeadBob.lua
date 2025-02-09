local Animation_HeadBob =
{
    physicalObject = nil,
    controller = nil,
    transform = nil,
    resetRotationSpeed = 10,
    rotationCoefficient = 0,
    rotationFrequency = 1.75,
    rotationAmplitude = 0.2,
    resetTranslationSpeed = 10,
    translationCoefficient = 0,
    translationFrequency = 1.75,
    translationAmplitude = 0.03,
    frequency = 1.0,
    amplitude = 1.0
}

function Animation_HeadBob:OnStart()
    self.physicalObject = self.owner:GetParent():GetPhysicalObject()
    self.controller = self.owner:GetParent():GetBehaviour("Controller_FPSController")
    self.transform = self.owner:GetTransform()
end

function Animation_HeadBob:GetMotionVelocity()
    velocity = self.physicalObject:GetLinearVelocity()
    velocity.y = 0
    return Vector3.Length(velocity)
end

function Animation_HeadBob:ApplyHeadBob(deltaTime, velocity)
    self.rotationCoefficient = self.rotationCoefficient + deltaTime * velocity
    self.transform:SetLocalRotation(Quaternion.new(Vector3.new(0, 0, math.sin(self.rotationCoefficient * self.rotationFrequency * self.frequency) * self.rotationAmplitude * self.amplitude)))
end

function Animation_HeadBob:ApplyHeadTranslation(deltaTime, velocity)
    self.translationCoefficient = self.translationCoefficient + deltaTime * velocity
    self.transform:SetLocalPosition(Vector3.new(0,  math.sin(self.translationCoefficient * self.translationFrequency * self.frequency) * self.translationAmplitude * self.amplitude, 0))
end

function Animation_HeadBob:ResetRotations(deltaTime)
    self.rotationCoefficient = 0
    self.transform:SetLocalRotation(Quaternion.Slerp(self.transform:GetLocalRotation(), Quaternion.new(), self.resetRotationSpeed * deltaTime))
end

function Animation_HeadBob:ResetTranslations(deltaTime)
    self.translationCoefficient = 0
    self.transform:SetLocalPosition(Vector3.Lerp(self.transform:GetLocalPosition(), Vector3.Zero(), self.resetTranslationSpeed * deltaTime))
end

function Animation_HeadBob:OnUpdate(deltaTime)
    velocity = self:GetMotionVelocity()

    if velocity > 0.5 then
        self:ApplyHeadBob(deltaTime, velocity)
        self:ApplyHeadTranslation(deltaTime, velocity)
    else
        self:ResetRotations(deltaTime)
        self:ResetTranslations(deltaTime)
    end
end

return Animation_HeadBob
