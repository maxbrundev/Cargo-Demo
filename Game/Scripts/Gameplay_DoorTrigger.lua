local Gameplay_DoorTrigger =
{
    rightDoor = nil,
    leftDoor = nil,
    doorSoundSystem = nil
}

function Gameplay_DoorTrigger:OnStart()
    self.doorSoundSystem = self.owner:GetBehaviour("Sound_DoorSound")

    if self.owner:GetTag() == "Gate_01" then
        self.rightDoor = Scenes.GetCurrentScene():FindActorByName("Gate 1 Right Door"):GetBehaviour("Animation_Door")
        self.leftDoor = Scenes.GetCurrentScene():FindActorByName("Gate 1 Left Door"):GetBehaviour("Animation_Door")
    end
    if self.owner:GetTag() == "Gate_02" then
        self.rightDoor = Scenes.GetCurrentScene():FindActorByName("Gate 2 Right Door"):GetBehaviour("Animation_Door")
        self.leftDoor = Scenes.GetCurrentScene():FindActorByName("Gate 2 Left Door"):GetBehaviour("Animation_Door")
    end
    if self.owner:GetTag() == "Gate Final" then
        self.rightDoor = Scenes.GetCurrentScene():FindActorByName("Gate Final Right Door"):GetBehaviour("Animation_Door")
        self.leftDoor = Scenes.GetCurrentScene():FindActorByName("Gate Final Left Door"):GetBehaviour("Animation_Door")
    end
end

function Gameplay_DoorTrigger:OnUpdate(deltaTime)
end

function Gameplay_DoorTrigger:OnTriggerEnter(other)
    if other:GetOwner():GetTag() == "Player" then
        self.rightDoor:Activate()
        self.leftDoor:Activate()
        self.doorSoundSystem:PlayOpenSound()
    end
end

function Gameplay_DoorTrigger:OnTriggerExit(other)
    if other:GetOwner():GetTag() == "Player" then
        self.rightDoor:Deactivate()
        self.leftDoor:Deactivate()
        self.doorSoundSystem:PlayCloseSound()
    end
end

return Gameplay_DoorTrigger
