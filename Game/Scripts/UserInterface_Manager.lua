local UserInterface_Manager =
{
    elecBall = nil,
    crosshair = nil,
    grabber = nil,
    ballRecall = nil,
    location = nil,
    throw = nil,
    grab = nil,
    worldAttract = nil,
    crosshairScale = 1.0,
    crosshairColorModifier = 1.0,
    crosshairAnimSpeed = 10.0,
    elapsed = 0,
    firstGrab = true
}

function UserInterface_Manager:OnAwake()
    currentScene = Scenes.GetCurrentScene()
    self.elecBall = currentScene:FindActorByName("Energy Ball")
    self.grabber = currentScene:FindActorByName("Player Camera"):GetBehaviour("Gameplay_Grabber")
    self.crosshair = currentScene:FindActorByName("UI_Crosshair")
    self.location = currentScene:FindActorByName("UI_Location")
    self.throw = currentScene:FindActorByName("UI_Throw")
    self.grab = currentScene:FindActorByName("UI_Grab")
    self.worldAttract = currentScene:FindActorByName("UI_WorldAttract")
    self.ballRecall = currentScene:FindActorByName("Recall Source"):GetBehaviour("Gameplay_BallRecall")
end

function UserInterface_Manager:OnStart()
    self.crosshair:SetActive(false)
    self.location:SetActive(true)
    self.throw:SetActive(false)
    self.grab:SetActive(false)
    self.worldAttract:SetActive(true)
end

function UserInterface_Manager:HideAll()
    self.crosshair:SetActive(false)
    self.location:SetActive(false)
    self.throw:SetActive(false)
    self.grab:SetActive(false)
    self.worldAttract:SetActive(false)
end

function UserInterface_Manager:OnUpdate(deltaTime)
    self:AnimateCrosshair(deltaTime)
    self:AnimateLocation(deltaTime)

    if self.firstGrab then
        self.grab:SetActive(self.grabber.canInteract)
    end

    if self.grabber.grabbed ~= nil then
        if self.firstGrab then
            self.firstGrab = false
            self.grab:SetActive(false)
        end

        if self.grabber.firstThrow and self.grabber.grabbed.owner:GetTag() == "Throwable" then
            self.throw:SetActive(true)
        end
    else
        self.throw:SetActive(false)
    end

    if self.ballRecall.recalling == true and self.elecBall:GetTransform():GetWorldPosition().x < 25 then
        self.worldAttract:SetActive(false)
    end
end

function UserInterface_Manager:AnimateCrosshair(deltaTime)
    crosshairMaterialRenderer = self.crosshair:GetMaterialRenderer()
    
    crosshairMaterialRenderer:SetUserMatrixElement(0, 0, self.crosshairScale)
    crosshairMaterialRenderer:SetUserMatrixElement(0, 1, self.crosshairColorModifier)

    targetScale = 1.0
    targetColorModifier = 1.0

    if self.grabber.canInteract then 
        targetScale = 2.0 
        targetColorModifier = 0.0
    end

    alpha = self.crosshairAnimSpeed * deltaTime
    self.crosshairScale = Math.Lerp(self.crosshairScale, targetScale, alpha)
    self.crosshairColorModifier = Math.Lerp(self.crosshairColorModifier, targetColorModifier, alpha)
end

function UserInterface_Manager:AnimateLocation(deltaTime)
    self.elapsed = self.elapsed + deltaTime

    if self.elapsed < 2 then -- 0 to 2 sec
        self.location:GetMaterialRenderer():SetUserMatrixElement(0, 0, 0)
    elseif self.elapsed < 8 then -- 2 to 8 sec
        self.location:GetMaterialRenderer():SetUserMatrixElement(0, 0, math.min(self.elapsed - 2, 1))
    else -- 8 and over sec
        self.location:GetMaterialRenderer():SetUserMatrixElement(0, 0, 1 - math.min(self.elapsed - 8, 1))
    end
end

return UserInterface_Manager
