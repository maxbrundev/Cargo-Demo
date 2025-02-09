local Gameplay_GunPickup =
{
}

function Gameplay_GunPickup:OnStart()
end

function Gameplay_GunPickup:OnTriggerEnter(other)
    if other:GetOwner():GetTag() == "Player" then
        animGun = Scenes.GetCurrentScene():FindActorByName("Player Gun Animation Pivot"):GetBehaviour("Animation_Gun")
        animGun:Unlock()
        animGun:Show()
        self.owner:GetParent():SetActive(false)
    end
end

return Gameplay_GunPickup
