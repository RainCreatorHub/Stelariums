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
    self.BarFrame.Size = UDim2.new(1, 0, 0, 30)
    self.BarFrame.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
    self.BarFrame.BorderSizePixel = 0
    self.BarFrame.Parent = self.windowFrame

    local IconLabel = Instance.new("ImageLabel")
    IconLabel.Name = "Icon"
    IconLabel.Size = UDim2.new(0, 20, 0, 20)
    IconLabel.Position = UDim2.new(0, 5, 0.5, -10)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Image = self.logo or (self.dependencies.Icons and self.dependencies.Icons.Shield) or ""
    IconLabel.Parent = self.BarFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(0, 0, 1, 0)
    TitleLabel.AutomaticSize = Enum.AutomaticSize.X
    TitleLabel.Position = UDim2.new(0, 30, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamSemibold
    TitleLabel.Text = self.title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = self.BarFrame
    
    local SubTitleLabel = Instance.new("TextLabel")
    SubTitleLabel.Name = "SubTitle"
    SubTitleLabel.Size = UDim2.new(0, 0, 1, 0)
    SubTitleLabel.AutomaticSize = Enum.AutomaticSize.X
    SubTitleLabel.Position = UDim2.new(0, 5, 0, 0)
    SubTitleLabel.AnchorPoint = Vector2.new(0, 0)
    SubTitleLabel.BackgroundTransparency = 1
    SubTitleLabel.Font = Enum.Font.Gotham
    SubTitleLabel.Text = self.subTitle
    SubTitleLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    SubTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubTitleLabel.Parent = TitleLabel
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.FillDirection = Enum.FillDirection.Horizontal
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    listLayout.Padding = UDim.new(0, 5)
    listLayout.Parent = TitleLabel
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
