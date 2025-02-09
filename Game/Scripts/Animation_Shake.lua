local Animation_Shake =
{
    defaultDecay		= 0.002,
	defaultIntensity	= 0.3,
    shakeOnStart		= false,
    
    defaultPosition = nil, 
    defaultRotation = nil,
    originPosition  = nil,
    originRotation  = nil,
    decay           = 0,
    intensity       = 0,

    transform = nil
}

function Animation_Shake:OnAwake()
    self.transform = self.owner:GetTransform()

    self.defaultPosition = self.transform:GetLocalPosition()
	self.defaultRotation = self.transform:GetLocalRotation()

    if self.shakeOnStart then self:Shake(defaultDecay, defaultIntensity) end
end

function Animation_Shake:OnUpdate(deltaTime)
    if self.intensity > 0 then
        self.transform:SetLocalPosition(self.originPosition + Vector3.new(Math.RandomFloat(0, 1), Math.RandomFloat(0,1), Math.RandomFloat(0,1)) * self.intensity);

        self.transform:SetLocalRotation
        (
            Quaternion.new
            (
                self.originRotation.x + Math.RandomFloat(-self.intensity, self.intensity) * 0.2,
                self.originRotation.y + Math.RandomFloat(-self.intensity, self.intensity) * 0.2,
                self.originRotation.z + Math.RandomFloat(-self.intensity, self.intensity) * 0.2,
                self.originRotation.w + Math.RandomFloat(-self.intensity, self.intensity) * 0.2
            )
        );

        self.intensity = self.intensity - self.decay * deltaTime;
        self.intensity = math.max(0.0, self.intensity);
    end
end

function Animation_Shake:ResetTransform()
    self.transform:SetLocalPosition(self.defaultPosition)
	self.transform:SetLocalRotation(self.defaultRotation)
end

function Animation_Shake:Shake(p_decay, p_intensity)
    if self.intensity == 0.0 then
        self.decay = p_decay;
        self.intensity = p_intensity;
        self.originPosition = self.transform:GetLocalPosition();
        self.originRotation = self.transform:GetLocalRotation();
    end
end

function Animation_Shake:StopShaking()
    self.intensity = 0
end

return Animation_Shake
