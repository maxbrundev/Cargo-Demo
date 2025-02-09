local Animation_Door =
{
    lerpAlpha = 1.0,
    startPosition = nil,
    endPosition =  nil,
    activated = false,
    playerCurrentRoom = 1,
    player = nil,
    isClosed = true,
    parentName = nil
}

function Animation_Door:OnStart()
    self.startPosition = self.owner:GetTransform():GetLocalPosition()
    self.player = Scenes.GetCurrentScene():FindActorByName("Player")
    self.parentName = self.owner:GetParent():GetName()

    tag = self.owner:GetTag()
    if tag == "Right" then
        self.endPosition = self.startPosition + self.owner:GetTransform():GetLocalRotation() 
                           * (Vector3.new(-(self.owner:GetTransform():GetLocalScale().x * 2.5), 0, 0))
    elseif  tag == "Left" then
        self.endPosition = self.startPosition + self.owner:GetTransform():GetLocalRotation() 
                           * (Vector3.new(self.owner:GetTransform():GetLocalScale().x * 2.5, 0, 0))
    end

    self:CheckPlayerCurrentRoom()
end

function Animation_Door:OnUpdate(deltaTime)
    self:Move(deltaTime)
 end
 
 function Animation_Door:Move(deltaTime)
    targetPosition = nil

    self.lerpAlpha = math.min(self.lerpAlpha + deltaTime, 1.0)
    
    if self.activated then
        targetPosition = self.endPosition
    else
        targetPosition = self.startPosition

        if self.lerpAlpha >= 0.4 then
            self.isClosed = true
        end
    end

    self.owner:GetTransform():SetLocalPosition(Vector3.Lerp(self.owner:GetTransform():GetLocalPosition(), targetPosition, self.lerpAlpha * 50 * deltaTime))
 end
 
 function Animation_Door:Activate()
    self.activated = true
    self.lerpAlpha = 0.0
    self.isClosed = false
 end
 
 function Animation_Door:Deactivate()
    self.activated = false
    self.lerpAlpha = 0.0
    self:CheckPlayerCurrentRoom()
 end

 function Animation_Door:CheckPlayerCurrentRoom()
    playerDoorDirection = self.owner:GetTransform():GetPosition() - self.player:GetTransform():GetPosition()
    c = Vector3.Cross(self.owner:GetTransform():GetRight(), playerDoorDirection);
    if Vector3.Dot(c, Vector3.Up()) < 0.0 then
        if self.parentName == "Gate 1" then
            self.playerCurrentRoom = 1
        else
            self.playerCurrentRoom = 2
        end
    else
        if self.parentName == "Gate 1" then
            self.playerCurrentRoom = 2
        else
            self.playerCurrentRoom = 3
        end
    end
end

return Animation_Door
