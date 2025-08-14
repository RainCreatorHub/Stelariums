local TitleBar = {}
TitleBar.__index = TitleBar

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

function TitleBar.new(config)
    local self = setmetatable({}, TitleBar)

    self.windowFrame = config.WindowFrame
    self.title = config.Title or "Stell"
    self.subTitle = config.SubTitle or ""
    self.logo = config.Logo or ""
    self.dependencies = config.Dependencies
    self.minimizeCallback = config.MinimizeCallback
    self.closeCallback = config.CloseCallback
    self.theme = config.Theme or "Dark"
    self.connections = {}
    
    self.themeColors = {
        Dark = {
            Primary = Color3.fromRGB(10, 10, 10),
            Secondary = Color3.fromRGB(20, 20, 20),
            Accent = Color3.fromRGB(150, 0, 20),
            Text = Color3.fromRGB(255, 255, 255),
            SubText = Color3.fromRGB(180, 180, 180),
            ButtonHover = Color3.fromRGB(255, 60, 70),
            MinimizeHover = Color3.fromRGB(80, 80, 80)
        },
        Light = {
            Primary = Color3.fromRGB(240, 240, 240),
            Secondary = Color3.fromRGB(220, 220, 220),
            Accent = Color3.fromRGB(200, 50, 50),
            Text = Color3.fromRGB(0, 0, 0),
            SubText = Color3.fromRGB(100, 100, 100),
            ButtonHover = Color3.fromRGB(255, 80, 80),
            MinimizeHover = Color3.fromRGB(150, 150, 150)
        }
    }
    
    self:createBar()
    self:makeDraggable()
    self:createActionButtons()
    
    return self
end

function TitleBar:getThemeColor(key)
    return self.themeColors[self.theme][key] or Color3.fromRGB(255, 255, 255)
end

function TitleBar:addHoverEffect(button, hoverColor, originalColor, duration)
    table.insert(self.connections, button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3 = hoverColor,
            Size = UDim2.new(0, button.Size.X.Offset + 2, 0, button.Size.Y.Offset + 2)
        }):Play()
    end))
    table.insert(self.connections, button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3 = originalColor,
            Size = UDim2.new(0, button.Size.X.Offset - 2, 0, button.Size.Y.Offset - 2)
        }):Play()
    end))
end

function TitleBar:createBar()
    self.BarFrame = Instance.new("Frame")
    self.BarFrame.Name = "TitleBar"
    self.BarFrame.Size = UDim2.new(1, 0, 0, 40)
    self.BarFrame.BackgroundColor3 = self:getThemeColor("Secondary")
    self.BarFrame.BorderSizePixel = 0
    self.BarFrame.ZIndex = 2
    self.BarFrame.ClipsDescendants = true
    self.BarFrame.Parent = self.windowFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = self.BarFrame
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new(self:getThemeColor("Accent"), self:getThemeColor("Primary"))
    gradient.Rotation = 90
    gradient.Parent = self.BarFrame

    local bottomBorder = Instance.new("Frame")
    bottomBorder.Name = "BottomBorder"
    bottomBorder.Size = UDim2.new(1, 0, 0, 1)
    bottomBorder.Position = UDim2.new(0, 0, 1, 0)
    bottomBorder.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bottomBorder.BorderSizePixel = 0
    bottomBorder.Parent = self.BarFrame

    local IconLabel = Instance.new("ImageLabel")
    IconLabel.Name = "Icon"
    IconLabel.Size = UDim2.new(0, 24, 0, 24)
    IconLabel.Position = UDim2.new(0, 12, 0.5, -12)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Image = self.logo or (self.dependencies.Icons and self.dependencies.Icons.Shield) or ""
    IconLabel.Parent = self.BarFrame

    local TitleContainer = Instance.new("Frame")
    TitleContainer.Name = "TitleContainer"
    TitleContainer.Size = UDim2.new(0, 0, 1, 0)
    TitleContainer.AutomaticSize = Enum.AutomaticSize.X
    TitleContainer.Position = UDim2.new(0, 46, 0, 0)
    TitleContainer.BackgroundTransparency = 1
    TitleContainer.Parent = self.BarFrame

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.Parent = TitleContainer

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(0, 0, 1, 0)
    TitleLabel.AutomaticSize = Enum.AutomaticSize.X
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 18
    TitleLabel.Text = self.title
    TitleLabel.TextColor3 = self:getThemeColor("Text")
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleContainer

    local SubTitleLabel = Instance.new("TextLabel")
    SubTitleLabel.Name = "SubTitle"
    SubTitleLabel.Size = UDim2.new(0, 0, 1, 0)
    SubTitleLabel.AutomaticSize = Enum.AutomaticSize.X
    SubTitleLabel.BackgroundTransparency = 1
    SubTitleLabel.Font = Enum.Font.Gotham
    SubTitleLabel.TextSize = 14
    SubTitleLabel.Text = self.subTitle
    SubTitleLabel.TextColor3 = self:getThemeColor("SubText")
    SubTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubTitleLabel.Parent = TitleContainer
end

function TitleBar:createActionButtons()
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Size = UDim2.new(0, 60, 1, 0)
    buttonContainer.Position = UDim2.new(1, -60, 0, 0)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Parent = self.BarFrame
    
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    layout.Padding = UDim.new(0, 5)
    layout.Parent = buttonContainer
    
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 24, 0, 24)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 40, 50)
    closeButton.Text = "X"
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.TextColor3 = self:getThemeColor("Text")
    closeButton.TextSize = 14
    closeButton.Parent = buttonContainer
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeButton
    
    self:addHoverEffect(closeButton, self:getThemeColor("ButtonHover"), Color3.fromRGB(200, 40, 50))
    
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.Size = UDim2.new(0, 24, 0, 24)
    minimizeButton.BackgroundColor3 = Color18
    minimizeButton.Text = "_"
    minimizeButton.Font = Enum.Font.SourceSansBold
    minimizeButton.TextColor3 = self:getThemeColor("Text")
    minimizeButton.TextSize = 14
    minimizeButton.Parent = buttonContainer
    
    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(0, 6)
    minCorner.Parent = minimizeButton
    
    self:addHoverEffect(minimizeButton, self:getThemeColor("MinimizeHover"), Color3.fromRGB(60, 60, 60))

    if self.minimizeCallback then
        table.insert(self.connections, minimizeButton.MouseButton1Click:Connect(self.minimizeCallback))
    end
    if self.closeCallback then
        table.insert(self.connections, closeButton.MouseButton1Click:Connect(self.closeCallback))
    end
end

function TitleBar:makeDraggable()
    local dragging = false
    local dragStart
    local startPos

    table.insert(self.connections, self.BarFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.windowFrame.Position
            
            table.insert(self.connections, input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end))
        end
    end))

    table.insert(self.connections, UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                local delta = input.Position - dragStart
                local newX = startPos.X.Offset + delta.X
                local newY = startPos.Y.Offset + delta.Y
                
                local screenSize = workspace.CurrentCamera.ViewportSize
                newX = math.clamp(newX, -self.windowFrame.Size.X.Offset + 50, screenSize.X - 50)
                newY = math.clamp(newY, -40, screenSize.Y - 50)
                
                self.windowFrame.Position = UDim2.new(0, newX, 0, newY)
            end
        end
    end))
end

function TitleBar:Destroy()
    for _, conn in ipairs(self.connections) do
        conn:Disconnect()
    end
    self.BarFrame:Destroy()
end

return TitleBar
