local TitleBar = {}
TitleBar.__index = TitleBar

function TitleBar.new(config)
    local self = setmetatable({}, TitleBar)
    
    self.windowFrame = config.WindowFrame
    self.title = config.Title
    self.subTitle = config.SubTitle
    self.logo = config.Logo
    self.dependencies = config.Dependencies
    
    self:createBar()
    self:makeDraggable()
    self:attachMinimize()
    
    return self
end

function TitleBar:createBar()
    self.BarFrame = Instance.new("Frame")
    self.BarFrame.Name = "TitleBar"
    self.BarFrame.Size = UDim2.new(1, 0, 0, 40)
    self.BarFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    self.BarFrame.BorderSizePixel = 0
    self.BarFrame.ZIndex = 2
    self.BarFrame.Parent = self.windowFrame

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
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
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
    SubTitleLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    SubTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubTitleLabel.Parent = TitleContainer
end

function TitleBar:makeDraggable()
    local UserInputService = game:GetService("UserInputService")
    local dragging = false
    local dragStart
    local startPos

    self.BarFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.windowFrame.Position
            
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
                self.windowFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
end

function TitleBar:attachMinimize()
    local MinimizeModule = self.dependencies.FetchModule("components/MF.lua")
    if MinimizeModule then
        MinimizeModule.new({
            WindowFrame = self.windowFrame,
            TitleBar = self.BarFrame
        })
    end
end

return TitleBar
