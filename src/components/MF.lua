local MinimizeFloating = {}
MinimizeFloating.__index = MinimizeFloating

function MinimizeFloating.new(config)
    local self = setmetatable({}, MinimizeFloating)
    
    self.guiToToggle = config.GuiToToggle
    self.name = config.Name
    self.format = config.Format
    self.dependencies = config.Dependencies
    
    self:createFloatingButton()
    self:makeDraggable()
    
    return self
end

function MinimizeFloating:createFloatingButton()
    local holder = Instance.new("ScreenGui")
    holder.Name = "Stell_FloatingButtonHolder"
    holder.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    holder.DisplayOrder = 999
    holder.ResetOnSpawn = false
    holder.Parent = gethui and gethui() or game:GetService("CoreGui")

    self.FloatingButton = Instance.new("TextButton")
    self.FloatingButton.Name = "FloatingToggleButton"
    self.FloatingButton.Size = UDim2.new(0, 100, 0, 40)
    self.FloatingButton.Position = UDim2.new(0, 20, 1, -60)
    self.FloatingButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    self.FloatingButton.Text = self.name
    self.FloatingButton.Font = Enum.Font.GothamBold
    self.FloatingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.FloatingButton.Parent = holder

    if self.format == "Circle" then
        self.FloatingButton.Size = UDim2.new(0, 50, 0, 50)
        self.FloatingButton.Text = ""
        self.FloatingButton.Image = self.dependencies.Icons and self.dependencies.Icons.Shield or ""
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = self.FloatingButton
    end

    local border = Instance.new("UIStroke")
    border.Color = Color3.fromRGB(150, 20, 30)
    border.Thickness = 2
    border.Parent = self.FloatingButton

    self.FloatingButton.MouseButton1Click:Connect(function()
        self.guiToToggle.Enabled = not self.guiToToggle.Enabled
    end)
end

function MinimizeFloating:makeDraggable()
    local UserInputService = game:GetService("UserInputService")
    local dragging = false
    local dragStart
    local startPos

    self.FloatingButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.FloatingButton.Position
            
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
                self.FloatingButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
end

return MinimizeFloating
