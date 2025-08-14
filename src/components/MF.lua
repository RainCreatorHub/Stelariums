local MinimizeFloating = {}
MinimizeFloating.__index = MinimizeFloating

function MinimizeFloating.new(config)
    local self = setmetatable({}, MinimizeFloating)
    
    self.name = config.Name
    self.format = config.Format
    self.dependencies = config.Dependencies
    self.toggleCallback = config.ToggleCallback
    
    self:createFloatingButton()
    self:makeDraggable()
    
    return self.FloatingFrame
end

function MinimizeFloating:createFloatingButton()
    local holder = Instance.new("ScreenGui")
    holder.Name = "Stell_FloatingButtonHolder"
    holder.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    holder.DisplayOrder = 999
    holder.ResetOnSpawn = false
    holder.Parent = gethui and gethui() or game:GetService("CoreGui")

    self.FloatingFrame = Instance.new("Frame")
    self.FloatingFrame.Name = "FloatingButtonHolder"
    self.FloatingFrame.Size = UDim2.new(0, 100, 0, 40)
    self.FloatingFrame.Position = UDim2.new(0, 20, 1, -60)
    self.FloatingFrame.BackgroundTransparency = 1
    self.FloatingFrame.Parent = holder

    local button = Instance.new("TextButton")
    button.Name = "FloatingToggleButton"
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    button.Text = self.name
    button.Font = Enum.Font.GothamBold
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Parent = self.FloatingFrame

    if self.format == "Circle" then
        self.FloatingFrame.Size = UDim2.new(0, 50, 0, 50)
        button.Text = ""
        button.Image = self.dependencies.Icons and self.dependencies.Icons.Shield or ""
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = button
    end

    local border = Instance.new("UIStroke")
    border.Color = Color3.fromRGB(150, 20, 30)
    border.Thickness = 2
    border.Parent = button

    if self.toggleCallback then
        button.MouseButton1Click:Connect(self.toggleCallback)
    end
end

function MinimizeFloating:makeDraggable()
    local UserInputService = game:GetService("UserInputService")
    local dragging = false
    local dragStart
    local startPos

    self.FloatingFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.FloatingFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                local delta = input.Position - dragStart
                self.FloatingFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
end

return MinimizeFloating
