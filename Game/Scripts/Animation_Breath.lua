local Animation_Breath =
{
    startPos    = Vector3.new(),
    offset      = Vector3.new(0, 0, 0),
    elasped     = 0,
    run         = false
}

function Animation_Breath:OnAwake()
    self.startPos = self.owner:GetTransform():GetLocalPosition()
end

function Animation_Breath:OnStart()
end

function Animation_Breath:OnUpdate(deltaTime)
    factor = 1

    if self.run then
        factor = 15
    end

    self.elasped = self.elasped + deltaTime * factor
    
    self.offset.y = math.sin(self.elasped) * 0.02
    self.owner:GetTransform():SetPosition(self.startPos + self.offset)
end

function Animation_Breath:Walk()
    self.run = false
end

function Animation_Breath:Run()
    self.run = true
end

return Animation_Breath
