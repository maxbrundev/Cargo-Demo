local Gameplay_EnergyTarget =
{
    lavaPlatform = nil,
    energyTankShaker = nil,
    energyTankLightAnim = nil,
    energyTankTubeOff = nil,
    energyTankTubeOn = nil,
    lowBattery = nil
}

function Gameplay_EnergyTarget:OnStart()
    self.lavaPlatform = Scenes.GetCurrentScene():FindActorByName("Lava Platform"):GetBehaviour("Animation_LavaPlatform")
    self.energyTankShaker = Scenes.GetCurrentScene():FindActorByName("Energy Tank Model"):GetBehaviour("Animation_Shake")
    self.energyTankLightAnim = Scenes.GetCurrentScene():FindActorByName("Energy Tank Light"):GetBehaviour("Animation_EnergyTankLight")
    self.energyTankTubeOff = Scenes.GetCurrentScene():FindActorByName("Energy Tank Tube Off")
    self.energyTankTubeOn = Scenes.GetCurrentScene():FindActorByName("Energy Tank Tube On")
    self.lowBattery = Scenes.GetCurrentScene():FindActorByName("UI_WorldLowEnergy")
end

function Gameplay_EnergyTarget:OnUpdate(deltaTime)
end

function Gameplay_EnergyTarget:OnTriggerEnter(other)
    if other:GetOwner():GetName() == "Energy Ball" then
        self.lavaPlatform:Activate()
        other:GetOwner():SetActive(false)
        self.owner:GetPhysicalObject():SetTrigger(false)
        self.energyTankShaker:Shake(0.2, 0.1)
        self.energyTankLightAnim.waitingForEnergy = false
        self.energyTankTubeOff:SetActive(false)
        self.energyTankTubeOn:SetActive(true)
        self.lowBattery:SetActive(false)
    end
end

return Gameplay_EnergyTarget
