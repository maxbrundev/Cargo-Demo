local Gameplay_Grabber =
{
    interactionRange = 2.5,
    grabbed = nil,
    gunShaker = nil,
    ballRecaller = nil,
    canInteract = false,
    enabled = true,
    firstThrow = true
}

function Gameplay_Grabber:OnStart()
    self.gunShaker = Scenes.GetCurrentScene():FindActorByName("Player Gun"):GetBehaviour("Animation_Shake")
    self.ballRecaller = Scenes.GetCurrentScene():FindActorByName("Recall Source"):GetBehaviour("Gameplay_BallRecall")
end

function Gameplay_Grabber:OnUpdate(deltaTime)
    self.canInteract = false

    if self.enabled == true then
        inFront = self:FindObjectInFront()
        if inFront ~= nil then
            grabbable = inFront:GetOwner():GetBehaviour("Gameplay_Grabbable")
            if grabbable ~= nil then
                self.canInteract = true
                if Inputs.GetKeyDown(Key.E) then
                    if self.grabbed == nil then -- Try to grab the object in front
                        if self.ballRecaller.recalling then 
                            self.ballRecaller:StopRecalling()
                        end
                        grabbable:Grab(self.owner)
                        self.grabbed = grabbable
                    elseif grabbable:IsDroppable() then -- Try to drop the object in front (Prevent behind-wall dropping)
                        if grabbable == self.grabbed then
                            self.grabbed:Drop()
                            self.grabbed = nil
                        end
                    end
                end
            end
        end

        if self.grabbed ~= nil and self.grabbed.owner:GetTag() == "Throwable" then
            if Inputs.GetMouseButtonDown(MouseButton.BUTTON_LEFT) then
                self:Throw(deltaTime)
            end
        end
    end
end

function Gameplay_Grabber:Throw(deltaTime)
    self.firstThrow = false
    self.gunShaker:Shake(0.2, 0.015)
    self.grabbed:Drop()
    self.grabbed.owner:GetPhysicalObject():AddImpulse(self.owner:GetTransform():GetForward() * 20, 1.0)
    Scenes.GetCurrentScene():FindActorByName("Elec Shot Sound"):GetBehaviour("Sound_ElectricShot"):Play()
    self.grabbed = nil
end

function Gameplay_Grabber:FindObjectInFront(considerTriggers)
    Hit = Physics.Raycast(self.owner:GetTransform():GetWorldPosition(), self.owner:GetTransform():GetForward(), self.interactionRange)

    if Hit ~= nil then
        if Hit.FirstResultObject ~= nil and Hit.FirstResultObject:GetOwner():GetTag() ~= "Player" and (not Hit.FirstResultObject:IsTrigger() or (self.grabbed ~= nil and Hit.FirstResultObject:GetOwner():GetID() == self.grabbed.owner:GetID())) then
            return Hit.FirstResultObject
        end

        for key,value in ipairs(Hit.ResultObjects) do
            if value:GetOwner():GetTag() ~= "Player" and (not value:IsTrigger() or (self.grabbed ~= nil and value:GetOwner():GetID() == self.grabbed.owner:GetID())) then
                return value
            end
        end
    end

    return nil
end

return Gameplay_Grabber
