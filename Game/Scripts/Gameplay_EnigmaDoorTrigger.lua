local Physics_WallPlatformTrigger =
{
    rightDoor = nil,
    leftDoor = nil,
    triggerCounter = 0,
    body = nil,
    startPosition = nil,
    endPosition =  nil,
    activated = false,
    enigmaDoorSoundSource = nil
}

function Physics_WallPlatformTrigger:OnAwake()
    self.enigmaDoorSoundSource = Scenes.GetCurrentScene():FindActorByName("Gate Enigma Door Sound"):GetBehaviour("Sound_DoorSound")
    self.rightDoor = Scenes.GetCurrentScene():FindActorByName("Gate Enigma Right Door"):GetBehaviour("Animation_Door")
    self.leftDoor = Scenes.GetCurrentScene():FindActorByName("Gate Enigma Left Door"):GetBehaviour("Animation_Door")

    self.body = Scenes.GetCurrentScene():FindActorByName("Enigma Door Trigger Mesh")

    self.startPosition = self.body:GetTransform():GetLocalPosition()
    self.endPosition = self.startPosition - self.owner:GetTransform():GetUp() * 0.13
end

function Physics_WallPlatformTrigger:OnUpdate(deltaTime)
    self:Move(deltaTime)
end
 
function Physics_WallPlatformTrigger:Move(deltaTime)
    targetPosition = nil

    if self.activated then
        targetPosition = self.endPosition
    else
        targetPosition = self.startPosition
    end

    self.body:GetTransform():SetPosition(Vector3.Lerp(self.body:GetTransform():GetLocalPosition(), targetPosition, 20 * deltaTime))
end 

function Physics_WallPlatformTrigger:OnTriggerEnter(other)
    if other:GetOwner():GetTag() ~= "Lightweight" then
        self.triggerCounter = self.triggerCounter + 1
        if self.triggerCounter == 1 then
            self.activated = true
            self.rightDoor:Activate()
            self.leftDoor:Activate()
            self.enigmaDoorSoundSource:PlayOpenSound()
        end
    end
end

function Physics_WallPlatformTrigger:OnTriggerExit(other)
    if other:GetOwner():GetTag() ~= "Lightweight" then
        self.triggerCounter = self.triggerCounter - 1
        if self.triggerCounter == 0 then
            self.activated = false
            self.rightDoor:Deactivate()
            self.leftDoor:Deactivate()
            self.enigmaDoorSoundSource:PlayCloseSound()
        end
    end
end

return Physics_WallPlatformTrigger
