local TitleBar = {}

function TitleBar.new(parentFrame, config)
    local barFrame = Instance.new("Frame")
    barFrame.Name = "TitleBar"
    barFrame.Size = UDim2.new(1, 0, 0, 40)
    barFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    barFrame.BorderSizePixel = 0
    barFrame.Parent = parentFrame

    if config.Logo and config.Logo ~= "" then
        local logoImage = Instance.new("ImageLabel")
        logoImage.Name = "Logo"
        logoImage.Size = UDim2.new(0, 28, 0, 28)
        logoImage.Position = UDim2.new(0, 6, 0.5, -14)
        logoImage.BackgroundTransparency = 1
        logoImage.Image = config.Logo
        logoImage.Parent = barFrame
    end

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(0, 200, 0, 20)
    titleLabel.Position = UDim2.new(0, 40, 0, 3)
    titleLabel.Text = config.Title
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextSize = 16
    titleLabel.Parent = barFrame

    if config.SubTitle and config.SubTitle ~= "" then
        local subTitleLabel = Instance.new("TextLabel")
        subTitleLabel.Name = "SubTitle"
        subTitleLabel.Size = UDim2.new(0, 200, 0, 15)
        subTitleLabel.Position = UDim2.new(0, 40, 0, 20)
        subTitleLabel.Text = config.SubTitle
        subTitleLabel.Font = Enum.Font.SourceSans
        subTitleLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
        subTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        subTitleLabel.TextSize = 12
        subTitleLabel.Parent = barFrame
    end

    barFrame.Active = true
    barFrame.Draggable = true

    return barFrame
end

return TitleBar
