local Controller_SimpleFPSController =
{
    walkSpeed           = 5,
    runSpeed            = 10,
    mouseSensitivity    = 0.05,
    mouseLook           = Vector2.new(180, 0),
    previousMouse       = Vector2.new(0, 0),
    firstMouse          = true,
    body                = nil,
    mouseLocked         = true,
    isGrounded          = false,
    defaultRotation     = nil,
    physicalCapsule     = nil,
    running             = false
}

function Controller_SimpleFPSController:OnAwake()
    self.body = self.owner:GetParent()
    self.defaultRotation = self.body:GetTransform():GetRotation()
    self.physicalCapsule = self.body:GetPhysicalCapsule()
end

function Controller_SimpleFPSController:OnStart()
    if self.mouseLocked then
        Inputs.LockMouse()
    end
end

function Controller_SimpleFPSController:OnUpdate(deltaTime)
    -- Toggle mouse lock with Left ALT key
    if Inputs.GetKeyDown(Key.LEFT_ALT) then
        self.mouseLocked = not self.mouseLocked
        self.firstMouse = true
        self.running = false
        self.body:GetPhysicalCapsule():SetLinearVelocity(Vector3.new(0.0, 0.0, 0.0))
        if self.mouseLocked then
            Inputs.LockMouse()
        else
            Inputs.UnlockMouse()
        end
    end

    self:CheckGround()

    -- Handle mouse and keyboard only if mouse is locked
    if self.mouseLocked then
        self:HandleMovement(deltaTime)
        self:HandleRotation(deltaTime)
    end
end

function Controller_SimpleFPSController:HandleMovement(deltaTime)
    velocity = Vector3.new(0, 0, 0)

    forward = self.body:GetTransform():GetForward()
    right   = self.body:GetTransform():GetRight()

    if self.isGrounded then
        if Inputs.GetKeyDown(Key.LEFT_SHIFT) then self.running = true end
        if Inputs.GetKeyUp(Key.LEFT_SHIFT) then self.running = false end
    end

    if self.running then speed = self.runSpeed else speed = self.walkSpeed end
    if Inputs.GetKey(Key.A) then velocity = velocity + right end
    if Inputs.GetKey(Key.D) then velocity = velocity - right end
    if Inputs.GetKey(Key.W) then velocity = velocity + forward end
    if Inputs.GetKey(Key.S) then velocity = velocity - forward end

    velocity = velocity * speed

    velocity.y =  self.body:GetPhysicalCapsule():GetLinearVelocity().y
    self.body:GetPhysicalCapsule():SetLinearVelocity(velocity)
end

function Controller_SimpleFPSController:HandleRotation(deltaTime)
    mousePosition = Inputs.GetMousePos()
    
    if self.firstMouse == true then
        self.previousMouse = mousePosition
        self.firstMouse = false
    end
    
    mouseOffset = Vector2.new(0, 0)
    mouseOffset.x = mousePosition.x - self.previousMouse.x
    mouseOffset.y = self.previousMouse.y - mousePosition.y

    self.previousMouse = mousePosition

    mouseOffset = mouseOffset * self.mouseSensitivity

    self.mouseLook = self.mouseLook + mouseOffset;

    -- Clamp x and y
    if self.mouseLook.y > 89    then self.mouseLook.y = 89  end
    if self.mouseLook.y < -89   then self.mouseLook.y = -89 end

    self.owner:GetTransform():SetRotation(Quaternion.new(Vector3.new(-self.mouseLook.y, 0, 0)))
    self.body:GetTransform():SetRotation(self.defaultRotation * Quaternion.new(Vector3.new(0, 180 - self.mouseLook.x, 0)))
end

function Controller_SimpleFPSController:IsGroundedAtOffset(offset)
    physicalOffset = Vector3.new(0, self.physicalCapsule:GetHeight() / 2 + self.physicalCapsule:GetRadius() - 0.1, 0)
    start = self.body:GetTransform():GetWorldPosition() + offset - physicalOffset
    Hit = Physics.Raycast(start, Vector3.new(0, -1, 0), 0.2)
    if Hit ~= nil then
        if Hit.FirstResultObject ~= nil and Hit.FirstResultObject:GetOwner():GetTag() ~= "Player" and not Hit.FirstResultObject:IsTrigger() then
            return true
        end

        for key,value in ipairs(Hit.ResultObjects) do
            if value:GetOwner():GetTag() ~= "Player" and not value:IsTrigger() then
                return true
            end
        end
    end
end

function Controller_SimpleFPSController:CheckGround()
    radius = self.physicalCapsule:GetRadius()

    left = self:IsGroundedAtOffset(Vector3.Left() * radius)
    right = self:IsGroundedAtOffset(Vector3.Right() * radius)
    forward = self:IsGroundedAtOffset(Vector3.Forward() * radius)
    backward = self:IsGroundedAtOffset(Vector3.Backward() * radius)
    middle = self:IsGroundedAtOffset(Vector3.Zero())

    if left or right or forward or backward or middle then
        self.isGrounded = true
    else
        self.isGrounded = false
    end
end

return Controller_SimpleFPSController