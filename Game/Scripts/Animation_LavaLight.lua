local Animation_LavaLight =
{
    startPos    = Vector3.new(),
    direction   = 1,
    orientation = 0,
    offset      = Vector3.new(0, 0, 0),
    elasped     = 0
}

function Animation_LavaLight:OnAwake()
    self.startPos = self.owner:GetTransform():GetLocalPosition()
    if self.owner:GetID() % 2 == 0 then
        self.direction = -1
    else
        self.direction = 1
    end
    if self.owner:GetTag() == "Horizontal" then
        self.orientation = 0
    else
        self.orientation = 1
    end
end

function Animation_LavaLight:OnStart()
end

function Animation_LavaLight:OnUpdate(deltaTime)
    self.elasped = self.elasped + deltaTime
    
    if self.orientation == 0 then
        self.offset.y = math.sin(self.elasped * 0.5) * 0.5 * self.direction
        self.offset.z = math.cos(self.elasped * 0.25) * 3.0 * self.direction
        self.offset.x = math.sin(self.elasped * 0.25) * 3.0 * self.direction
    else
        self.offset.y = math.sin(self.elasped * 0.1) * 0.5 * self.direction
        self.offset.x = math.sin(self.elasped * 0.25) * 3.0 * self.direction
        self.offset.x = math.cos(self.elasped * 0.25) * 3.0 * self.direction
    end
    self.owner:GetTransform():SetPosition(self.startPos + self.offset)
end

return Animation_LavaLight
