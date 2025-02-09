local Gameplay_Wearable =
{
    grabbableBehavior = nil,
    weared = false,
    ironManHelmetItemMesh = nil,
    ironManHelmetLight = nil,
    playerIronManItem = nil,
    playerGun = nil,
    playerGrabber = nil,
    crosshair = nil,
    firstGrab = true
}

function Gameplay_Wearable:OnAwake()
    self.grabbableBehavior = self.owner:GetBehaviour("Gameplay_Grabbable")
    self.ironManHelmetItemMesh = Scenes.GetCurrentScene():FindActorByName("Iron Man Helmet Mesh")
    self.ironManHelmetLight = Scenes.GetCurrentScene():FindActorByName("Iron Man Helmet Light")
    self.playerIronManItem = Scenes.GetCurrentScene():FindActorByName("IronMan Helmet")
    self.playerGrabber = Scenes.GetCurrentScene():FindActorByName("Player Camera"):GetBehaviour("Gameplay_Grabber")
    self.crosshair = Scenes.GetCurrentScene():FindActorByName("UI_Crosshair")
    self.playerGun = Scenes.GetCurrentScene():FindActorByName("Player Gun Animation Pivot"):GetBehaviour("Animation_Gun")
end

function Gameplay_Wearable:OnUpdate(deltaTime)
    if self.grabbableBehavior.grabber ~= nil then
        if self.firstGrab == true then
            self.ironManHelmetLight:SetActive(false)
            self.firstGrab = false
        end

        if Inputs.GetKeyDown(Key.R) then
            if not self.weared then
                self.weared = true
                self.ironManHelmetItemMesh:SetActive(false)
                self.playerIronManItem:SetActive(true)
                self.crosshair:SetActive(false)
                self.playerGrabber.enabled = false
                self.playerGun:Hide()
                self.playerGun.owner:GetTransform():SetLocalRotation(Quaternion.new(Vector3.new(45, 0, 0)))
            else
                self.ironManHelmetItemMesh:SetActive(true)
                self.playerIronManItem:SetActive(false)
                self.playerGrabber.enabled = true
                self.crosshair:SetActive(true)
                self.weared = false
                self.playerGun:Show()
            end
        end
    end

end

return Gameplay_Wearable
