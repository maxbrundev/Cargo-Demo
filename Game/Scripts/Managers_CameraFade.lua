local Managers_CameraFade =
{
    cameraWhiteFade = nil,
    cameraBlackFade = nil,
    cameraFade = nil,
    fadeIn = true,
    alpha = 1.0,
    fadeSpeed = 1.0,
    targetAlpha = 0.0
}

function Managers_CameraFade:OnAwake()
    self.cameraWhiteFade = Scenes.GetCurrentScene():FindActorByName("Camera White Fade")
    self.cameraBlackFade = Scenes.GetCurrentScene():FindActorByName("Camera Black Fade")
    self:SetAlpha(1, 1)
end

function Managers_CameraFade:SetAlpha(white, black)
    self.cameraWhiteFade:GetMaterialRenderer():SetUserMatrixElement(0, 0, white)
    self.cameraBlackFade:GetMaterialRenderer():SetUserMatrixElement(0, 0, black)
end

function Managers_CameraFade:FadeBlack(speed, targetAlpha)
    self.cameraWhiteFade:SetActive(false)
    self.cameraBlackFade:SetActive(true)
    self.cameraFade = self.cameraBlackFade
    self.fadeSpeed = speed
    self.targetAlpha = targetAlpha
end

function Managers_CameraFade:FadeWhite(speed, targetAlpha)
    self.cameraBlackFade:SetActive(false)
    self.cameraWhiteFade:SetActive(true)
    self.cameraFade = self.cameraWhiteFade
    self.fadeSpeed = speed
    self.targetAlpha = targetAlpha
end

function Managers_CameraFade:StopFading()
    self.cameraFade = nil
end

function Managers_CameraFade:OnUpdate(deltaTime)
    if self.cameraFade ~= nil then
        self.cameraFade:GetMaterialRenderer():SetUserMatrixElement(0, 0, self.alpha)
        self.alpha = Math.Lerp(self.alpha, self.targetAlpha, self.fadeSpeed * deltaTime)
    end
end

return Managers_CameraFade
