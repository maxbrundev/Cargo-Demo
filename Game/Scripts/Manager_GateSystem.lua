local Manager_GateSystem =
{
    LevelModule_01 = nil,
    LevelModule_02 = nil,
    LevelModule_03 = nil,
    Gate_01 = nil,
    Gate_02 = nil,
    Door_01 = nil,
    Door_02 = nil,
    Door_01_WasClosed = true,
    Door_02_WasClosed = true,
}

function Manager_GateSystem:OnStart()
    self.LevelModule_01 = Scenes.GetCurrentScene():FindActorByName("Level_Module_01")
    self.LevelModule_02 = Scenes.GetCurrentScene():FindActorByName("Level_Module_02")
    self.LevelModule_03 = Scenes.GetCurrentScene():FindActorByName("Level_Module_03")
    self.Gate_01 = Scenes.GetCurrentScene():FindActorByName("Gate 1")
    self.Gate_02 = Scenes.GetCurrentScene():FindActorByName("Gate 2")
    self.Door_01 = Scenes.GetCurrentScene():FindActorByName("Gate 1 Right Door"):GetBehaviour("Animation_Door")
    self.Door_02 = Scenes.GetCurrentScene():FindActorByName("Gate 2 Right Door"):GetBehaviour("Animation_Door")
    self.LevelModule_01:SetActive(true)
    self.LevelModule_02:SetActive(false)
    self.LevelModule_03:SetActive(false)
    self.Gate_02:SetActive(false)
end

function Manager_GateSystem:OnUpdate(deltaTime)
    eventOccured = false
    if self.Door_01_WasClosed ~= self.Door_01.isClosed then
        eventOccured = true
        self.Door_01_WasClosed = self.Door_01.isClosed
    end
    if self.Door_02_WasClosed ~= self.Door_02.isClosed then
        eventOccured = true
        self.Door_02_WasClosed = self.Door_02.isClosed
    end

    if eventOccured then
        self:ManageLevelModuleActivation()
    end
end

function Manager_GateSystem:ManageLevelModuleActivation()
    if self.Door_01.playerCurrentRoom == 2 then
        if self.Door_01.isClosed then
            self.LevelModule_01:SetActive(false)
            self.LevelModule_02:SetActive(true)
        else
            self.LevelModule_01:SetActive(true)
            self.LevelModule_02:SetActive(true)
            self.Gate_02:SetActive(true)
        end
    end
    if self.Door_02.playerCurrentRoom == 2 then
        if self.Door_02.isClosed then
            self.LevelModule_02:SetActive(true)
            self.LevelModule_03:SetActive(false)
        else
            self.LevelModule_02:SetActive(true)
            self.LevelModule_03:SetActive(true)
            self.Gate_02:SetActive(true)
        end
    end
    if self.Door_01.playerCurrentRoom == 1 then
        if self.Door_01.isClosed then
            self.LevelModule_01:SetActive(true)
            self.LevelModule_02:SetActive(false)
            self.Gate_02:SetActive(false)
        else
            self.LevelModule_01:SetActive(true)
            self.LevelModule_02:SetActive(true)
            self.Gate_02:SetActive(true)
        end
    end
    if self.Door_02.playerCurrentRoom == 3 then
        if self.Door_02.isClosed then
            self.LevelModule_02:SetActive(false)
            self.LevelModule_03:SetActive(true)
            self.Gate_01:SetActive(false)
        else
            self.LevelModule_02:SetActive(true)
            self.LevelModule_03:SetActive(true)
            self.Gate_01:SetActive(true)
        end
    end
end

return Manager_GateSystem
