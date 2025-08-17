local TitleBar = {}
TitleBar.__index = TitleBar

function TitleBar.new(title, subTitle, logo)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "Stell_TitleBar_Container"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local barFrame = Instance.new("Frame")
    barFrame.Name = "TitleBar"
    barFrame.Size = UDim2.new(1, 0, 0, 40)
    barFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    barFrame.BorderSizePixel = 0
    barFrame.Draggable = true
    barFrame.Active = true
    barFrame.Parent = screenGui

    if logo and logo ~= "" then
        local logoImage = Instance.new("ImageLabel")
        logoImage.Name = "Logo"
        logoImage.Size = UDim2.new(0, 28, 0, 28)
        logoImage.Position = UDim2.new(0, 6, 0.5, -14)
        logoImage.BackgroundTransparency = 1
        logoImage.Image = logo
        logoImage.Parent = barFrame
    end

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(0, 200, 0, 20)
    titleLabel.Position = UDim2.new(0, 40, 0, 3)
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextSize = 16
    titleLabel.Parent = barFrame

    if subTitle and subTitle ~= "" then
        local subTitleLabel = Instance.new("TextLabel")
        subTitleLabel.Name = "SubTitle"
        subTitleLabel.Size = UDim2.new(0, 200, 0, 15)
        subTitleLabel.Position = UDim2.new(0, 40, 0, 20)
        subTitleLabel.Text = subTitle
        subTitleLabel.Font = Enum.Font.SourceSans
        subTitleLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
        subTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        subTitleLabel.TextSize = 12
        subTitleLabel.Parent = barFrame
    end

    local titleBarInstance = {
        GUI = screenGui,
        Frame = barFrame
    }

    return setmetatable(titleBarInstance, TitleBar)
end

return TitleBar
