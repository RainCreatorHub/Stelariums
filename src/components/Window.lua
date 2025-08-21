local Stell = {}

function Stell:Window(Info)
    local self = setmetatable({}, Stell)

    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Stell"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = Info.Size or UDim2.fromOffset(580, 460)
    MainFrame.Position = UDim2.fromOffset(
        (ScreenGui.AbsoluteSize.X - MainFrame.Size.X.Offset) / 2,
        (ScreenGui.AbsoluteSize.Y - MainFrame.Size.Y.Offset) / 2
    )
    MainFrame.ClipsDescendants = true
    MainFrame.BorderSizePixel = 0
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = MainFrame

    local Stroke = Instance.new("UIStroke")
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.Thickness = 1
    Stroke.LineJoinMode = Enum.LineJoinMode.Round
    Stroke.Color = Color3.fromRGB(80, 80, 80)
    Stroke.Parent = MainFrame

    local SideBarWidth = Info.SideBarWidth or 200

    local SideBar = Instance.new("Frame")
    SideBar.Name = "SideBar"
    SideBar.Size = UDim2.fromOffset(SideBarWidth, MainFrame.AbsoluteSize.Y)
    SideBar.Position = UDim2.fromOffset(0, 0)
    SideBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SideBar.BorderSizePixel = 0
    SideBar.Parent = MainFrame

    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -SideBarWidth, 1, 0)
    ContentArea.Position = UDim2.fromOffset(SideBarWidth, 0)
    ContentArea.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    ContentArea.BorderSizePixel = 0
    ContentArea.Parent = MainFrame

    local HeaderArea = Instance.new("Frame")
    HeaderArea.Name = "HeaderArea"
    HeaderArea.Size = UDim2.new(1, 0, 0, 60)
    HeaderArea.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    HeaderArea.BorderSizePixel = 0
    HeaderArea.Parent = SideBar

    local TabsArea = Instance.new("Frame")
    TabsArea.Name = "TabsArea"
    TabsArea.Size = UDim2.new(1, 0, 1, -60)
    TabsArea.Position = UDim2.fromOffset(0, 60)
    TabsArea.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TabsArea.BorderSizePixel = 0
    TabsArea.Parent = SideBar

    local Icon = Instance.new("ImageLabel")
    Icon.Name = "Icon"
    Icon.Size = UDim2.fromOffset(24, 24)
    Icon.Position = UDim2.fromOffset(15, 10)
    Icon.BackgroundTransparency = 1
    Icon.Image = "rbxassetid://10748313424"
    Icon.Parent = HeaderArea

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(1, -50, 0, 24)
    TitleLabel.Position = UDim2.fromOffset(45, 8)
    TitleLabel.Text = Info.Title or "Fallback Title"
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 18
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = HeaderArea

    local AuthorLabel = Instance.new("TextLabel")
    AuthorLabel.Name = "Author"
    AuthorLabel.Size = UDim2.new(1, -50, 0, 16)
    AuthorLabel.Position = UDim2.fromOffset(45, 32)
    AuthorLabel.Text = Info.Author or ""
    AuthorLabel.Font = Enum.Font.Gotham
    AuthorLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    AuthorLabel.TextSize = 12
    AuthorLabel.TextXAlignment = Enum.TextXAlignment.Left
    AuthorLabel.BackgroundTransparency = 1
    AuthorLabel.Parent = HeaderArea

    if Info.User and Info.User.Enabled then
        local UserFrame = Instance.new("Frame")
        UserFrame.Name = "UserFrame"
        UserFrame.Size = UDim2.new(1, 0, 0, 50)
        UserFrame.AnchorPoint = Vector2.new(0, 1)
        UserFrame.Position = UDim2.new(0, 0, 1, 0)
        UserFrame.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        UserFrame.BackgroundTransparency = 0.5
        UserFrame.Parent = SideBar

        local UserButton = Instance.new("TextButton")
        UserButton.Name = "UserButton"
        UserButton.Size = UDim2.new(1, 0, 1, 0)
        UserButton.BackgroundTransparency = 1
        UserButton.Text = ""
        UserButton.Parent = UserFrame
        
        if Info.User.Callback and typeof(Info.User.Callback) == "function" then
            UserButton.MouseButton1Click:Connect(Info.User.Callback)
        end

        local UserIcon = Instance.new("ImageLabel")
        UserIcon.Name = "UserIcon"
        UserIcon.Size = UDim2.fromOffset(32, 32)
        UserIcon.Position = UDim2.fromOffset(10, 9)
        UserIcon.BackgroundTransparency = 1
        local userId = Players.LocalPlayer.UserId
        local thumbType = Enum.ThumbnailType.HeadShot
        local thumbSize = Enum.ThumbnailSize.Size420x420
        local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
        UserIcon.Image = content
        UserIcon.Parent = UserFrame

        local UserName = Instance.new("TextLabel")
        UserName.Name = "UserName"
        UserName.Size = UDim2.new(1, -50, 1, 0)
        UserName.Position = UDim2.fromOffset(50, 0)
        UserName.Text = (Info.User.Anonymous and "Anonymous") or Players.LocalPlayer.DisplayName
        UserName.Font = Enum.Font.GothamBold
        UserName.TextColor3 = Color3.fromRGB(255, 255, 255)
        UserName.TextSize = 14
        UserName.TextXAlignment = Enum.TextXAlignment.Left
        UserName.BackgroundTransparency = 1
        UserName.Parent = UserFrame
    end

    if Info.Resizable then
        local resizeHandle = Instance.new("Frame")
        resizeHandle.Name = "ResizeHandle"
        resizeHandle.Size = UDim2.fromOffset(12, 12)
        resizeHandle.AnchorPoint = Vector2.new(1, 1)
        resizeHandle.Position = UDim2.new(1, 0, 1, 0)
        resizeHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        resizeHandle.BackgroundTransparency = 0.8
        resizeHandle.Parent = MainFrame
    end

    local dragging = false
    local dragInput, dragStart, startPos
    
    HeaderArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    HeaderArea.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    return self
end

return Stell
