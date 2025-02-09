local Gameplay_LevelEnd =
{
    gameManager = nil
}

function Gameplay_LevelEnd:OnStart()
    self.gameManager = Scenes.GetCurrentScene():FindActorByName("Game Manager"):GetBehaviour("Managers_GameManager")
end

function Gameplay_LevelEnd:OnTriggerEnter(other)
    if other:GetOwner():GetTag() == "Player" then
        other:SetKinematic(true)
        self.gameManager:OnLevelEnd()
    end
end

return Gameplay_LevelEnd
