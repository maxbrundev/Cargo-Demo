local Controller_FPSController =
{
    currentWalkSpeed        = 1.0,
    currentRunSpeed         = 1.0,
    currentJumpStrength     = 1.0,
    readyToGo               = false,
    walkSpeed               = 3.5,
    runSpeed                = 5.5,
    jumpStrength            = 8.0,
    mouseSensitivity        = 0.05,
    mouseLook               = Vector2.new(180, -20),
    previousMouse           = Vector2.new(0, 0),
    firstMouse              = true,
    camera                   = nil,
    mouseLocked             = true,
    isGrounded              = false,
    breathScript            = nil,
    physicalCapsule         = nil,
    running                 = false,
    runAsked                = false,
    walkAsked               = false,
    ballRecall              = nil
}

function Controller_FPSController:OnAwake()
    self.camera = Scenes.GetCurrentScene():FindActorByName("Player Camera")
    self.physicalCapsule = self.owner:GetPhysicalCapsule()
    self.ballRecall = Scenes.GetCurrentScene():FindActorByName("Recall Source"):GetBehaviour("Gameplay_BallRecall")
end

function Controller_FPSController:OnStart()
    if self.mouseLocked then
        Inputs.LockMouse()
    end
end

function Controller_FPSController:OnUpdate(deltaTime)
    if self.readyToGo then
        self.currentWalkSpeed = Math.Lerp(self.currentWalkSpeed, self.walkSpeed, 0.3 * deltaTime)
        self.currentRunSpeed = Math.Lerp(self.currentRunSpeed, self.runSpeed, 0.3 * deltaTime)
        self.currentJumpStrength = Math.Lerp(self.currentJumpStrength, self.jumpStrength, 0.3 * deltaTime)
    end

    -- Toggle mouse lock with Left ALT key
    if Inputs.GetKeyDown(Key.LEFT_ALT) then
        self.mouseLocked = not self.mouseLocked
        self.firstMouse = true
        self.running = false
        self.owner:GetPhysicalCapsule():SetLinearVelocity(Vector3.new(0.0, 0.0, 0.0))
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

function Controller_FPSController:HandleMovement(deltaTime)
    velocity = Vector3.new(0, 0, 0)

    forward = self.owner:GetTransform():GetForward()
    right   = self.owner:GetTransform():GetRight()

    if Inputs.GetKey(Key.A) then velocity = velocity + right end
    if Inputs.GetKey(Key.D) then velocity = velocity - right end
    if Inputs.GetKey(Key.W) then velocity = velocity + forward end
    if Inputs.GetKey(Key.S) then velocity = velocity - forward end
    velocity = Vector3.Normalize(velocity)

    canRun = Vector3.Dot(velocity, self.owner:GetTransform():GetForward()) > 0 and not self.ballRecall.recalling

    self.runAsked = Inputs.GetKey(Key.LEFT_SHIFT)
    self.walkAsked = not self.runAsked
    
    if self.isGrounded then
        self.running = false
        if Inputs.GetKeyDown(Key.LEFT_SHIFT) or self.runAsked then
            if canRun then
                self.running = true
            end
        end
        if Inputs.GetKeyUp(Key.LEFT_SHIFT) or self.walkAsked then
            if canRun then
                self.running = false
            end
        end
    end

    if self.running then speed = self.currentRunSpeed else speed = self.currentWalkSpeed end

    velocity = velocity * speed

    velocity.y =  self.owner:GetPhysicalCapsule():GetLinearVelocity().y
    self.owner:GetPhysicalCapsule():SetLinearVelocity(velocity)

    if Inputs.GetKeyDown(Key.SPACE) and self.readyToGo and self.isGrounded then
        self.physicalCapsule:AddImpulse(Vector3.new(0, self.currentJumpStrength, 0))
    end
end

function Controller_FPSController:HandleRotation(deltaTime)
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

    self.camera:GetTransform():SetRotation(Quaternion.new(Vector3.new(-self.mouseLook.y, 0, 0)))
    self.owner:GetTransform():SetRotation(Quaternion.new(Vector3.new(0, -self.mouseLook.x, 0)))
end

function Controller_FPSController:ResetRotation()
    self.mouseLook.x = -90.0
    self.mouseLook.y = 0.0
end

function Controller_FPSController:IsGroundedAtOffset(offset)
    Hit = Physics.Raycast(self.owner:GetTransform():GetWorldPosition() + offset - Vector3.new(0, self.physicalCapsule:GetHeight() * 0.9, 0), Vector3.new(0, -1, 0), 0.2)
    if Hit ~= nil then
        if Hit.FirstResultObject ~= nil and not Hit.FirstResultObject:IsTrigger() then
            return true
        end

        for key,value in ipairs(Hit.ResultObjects) do
            if value:GetOwner():GetTag() ~= "Player" and not value:IsTrigger() then
                return true
            end
        end
    end
end

function Controller_FPSController:IsGroundedAtOffset(offset)
    physicalOffset = Vector3.new(0, self.physicalCapsule:GetHeight() / 2 + self.physicalCapsule:GetRadius() - 0.1, 0)
    start = self.owner:GetTransform():GetWorldPosition() + offset - physicalOffset
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

function Controller_FPSController:CheckGround()
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

return Controller_FPSController