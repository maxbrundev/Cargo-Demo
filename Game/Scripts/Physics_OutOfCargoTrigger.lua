local Physics_OutOfCargoTrigger =
{
    defaultWalkSpeed = nil,
    defaultRunSpeed = nil,
    player = nil,
    fpsController = nil,
    physicalObject = nil,
    cameraShaker = nil,
    headBob = nil,
    triggered = false
}

function Physics_OutOfCargoTrigger:OnStart()
    self.headBob = Scenes.GetCurrentScene():FindActorByName("Head Bob Pivot"):GetBehaviour("Animation_HeadBob")
    self.player = Scenes.GetCurrentScene():FindActorByName("Player")
    self.fpsController = self.player:GetBehaviour("Controller_FPSController")
    self.physicalObject = self.player:GetPhysicalObject()
    self.cameraShaker = Scenes.GetCurrentScene():FindActorByName("Player Camera"):GetBehaviour("Animation_Shake")
    self.defaultWalkSpeed = self.fpsController.walkSpeed
    self.defaultRunSpeed = self.fpsController.runSpeed

    self.headBob.amplitude = 2.5
    self.headBob.frequency = 1.25 
end

function Physics_OutOfCargoTrigger:OnUpdate(deltaTime)
end

function Physics_OutOfCargoTrigger:OnTriggerEnter(other)
    if not self.triggered then
        self.headBob.amplitude = 1    
        self.headBob.frequency = 1
    
        self.triggered = true
        self.physicalObject:SetFriction(0.0)
        self.fpsController.readyToGo = true
        self.owner:GetAudioSource():Play()
        self.cameraShaker:Shake(0.5, 0.1)

        Scenes.GetCurrentScene():FindActorByName("UIManager"):GetBehaviour("UserInterface_Manager").crosshair:SetActive(true)
    end
end

return Physics_OutOfCargoTrigger
