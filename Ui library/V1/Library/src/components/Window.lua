-- Window.lua - Main Window Component
-- Handles window creation, management, and tab system

local Window = {}
Window.__index = Window

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("CoreGui")

function Window.new(Info, DoorLib)
    local self = setmetatable({}, Window)
    
    self.DoorLib = DoorLib
    self.Info = Info
    self.Theme = DoorLib.Themes[Info.Theme]
    self.Tabs = {}
    self.CurrentTab = nil
    self.Minimized = false
    self.Dragging = false
    
    self:CreateWindow()
    self:SetupDragging()
    
    return self
end

function Window:CreateWindow()
    -- Main ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "DoorLibWindow"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.Parent = PlayerGui
    
    -- Main Window Frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainWindow"
    self.MainFrame.Size = self.Info.Size
    self.MainFrame.Position = self.Info.Position
    self.MainFrame.BackgroundColor3 = self.Theme.Primary
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.ClipsDescendants = true
    self.MainFrame.Parent = self.ScreenGui
    
    -- Window styling
    self.DoorLib:CreateCorner(self.MainFrame, 12)
    self.DoorLib:CreateStroke(self.MainFrame, 1, self.Theme.Border)
    
    -- Gradient background
    self.DoorLib:CreateGradient(self.MainFrame, {
        {0, self.Theme.Primary},
        {0.3, self.Theme.Secondary},
        {1, self.Theme.Primary}
    }, 45)
    
    -- Drop shadow effect
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxasset://textures/ui/Controls/DropShadow.png"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(12, 12, 256-12, 256-12)
    shadow.ZIndex = -1
    shadow.Parent = self.MainFrame
    
    -- Create TitleBar
    self.TitleBarFrame = Instance.new("Frame")
    self.TitleBarFrame.Name = "TitleBar"
    self.TitleBarFrame.Size = UDim2.new(1, 0, 0, 35)
    self.TitleBarFrame.Position = UDim2.new(0, 0, 0, 0)
    self.TitleBarFrame.BackgroundColor3 = self.Theme.Secondary
    self.TitleBarFrame.BorderSizePixel = 0
    self.TitleBarFrame.Parent = self.MainFrame
    
    self.DoorLib:CreateCorner(self.TitleBarFrame, 12)
    
    -- Title bar gradient
    self.DoorLib:CreateGradient(self.TitleBarFrame, {
        {0, self.Theme.Accent},
        {0.5, self.Theme.Secondary},
        {1, self.Theme.Accent}
    }, 90)
    
    -- Title Text
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Name = "Title"
    self.TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    self.TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = self.Info.Title
    self.TitleLabel.TextColor3 = self.Theme.Text
    self.TitleLabel.TextSize = 16
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.Font = Enum.Font.GothamBold
    self.TitleLabel.Parent = self.TitleBarFrame
    
    -- Subtitle Text
    self.SubTitleLabel = Instance.new("TextLabel")
    self.SubTitleLabel.Name = "SubTitle"
    self.SubTitleLabel.Size = UDim2.new(1, -100, 0.5, 0)
    self.SubTitleLabel.Position = UDim2.new(0, 15, 0.5, 2)
    self.SubTitleLabel.BackgroundTransparency = 1
    self.SubTitleLabel.Text = self.Info.SubTitle
    self.SubTitleLabel.TextColor3 = self.Theme.TextSecondary
    self.SubTitleLabel.TextSize = 12
    self.SubTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.SubTitleLabel.Font = Enum.Font.Gotham
    self.SubTitleLabel.Parent = self.TitleBarFrame
    
    -- Window Controls
    self:CreateWindowControls()
    
    -- Tab Container
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Name = "TabContainer"
    self.TabContainer.Size = UDim2.new(1, 0, 0, 40)
    self.TabContainer.Position = UDim2.new(0, 0, 0, 35)
    self.TabContainer.BackgroundColor3 = self.Theme.Primary
    self.TabContainer.BorderSizePixel = 0
    self.TabContainer.Parent = self.MainFrame
    
    -- Tab List
    self.TabList = Instance.new("ScrollingFrame")
    self.TabList.Name = "TabList"
    self.TabList.Size = UDim2.new(1, -10, 1, -5)
    self.TabList.Position = UDim2.new(0, 5, 0, 5)
    self.TabList.BackgroundTransparency = 1
    self.TabList.BorderSizePixel = 0
    self.TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.TabList.ScrollBarThickness = 0
    self.TabList.ScrollingDirection = Enum.ScrollingDirection.X
    self.TabList.Parent = self.TabContainer
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.Parent = self.TabList
    
    -- Content Area
    self.ContentArea = Instance.new("Frame")
    self.ContentArea.Name = "ContentArea"
    self.ContentArea.Size = UDim2.new(1, 0, 1, -75)
    self.ContentArea.Position = UDim2.new(0, 0, 0, 75)
    self.ContentArea.BackgroundTransparency = 1
    self.ContentArea.Parent = self.MainFrame
end

function Window:CreateWindowControls()
    -- Controls Container
    local controlsFrame = Instance.new("Frame")
    controlsFrame.Name = "Controls"
    controlsFrame.Size = UDim2.new(0, 85, 1, -5)
    controlsFrame.Position = UDim2.new(1, -90, 0, 2.5)
    controlsFrame.BackgroundTransparency = 1
    controlsFrame.Parent = self.TitleBarFrame
    
    local controlsLayout = Instance.new("UIListLayout")
    controlsLayout.FillDirection = Enum.FillDirection.Horizontal
    controlsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    controlsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    controlsLayout.Padding = UDim.new(0, 5)
    controlsLayout.Parent = controlsFrame
    
    -- Minimize Button
    self.MinimizeButton = self:CreateControlButton("−", function()
        self:ToggleMinimize()
    end)
    self.MinimizeButton.Parent = controlsFrame
    
    -- Close Button
    self.CloseButton = self:CreateControlButton("×", function()
        self:Close()
    end, self.Theme.Error)
    self.CloseButton.Parent = controlsFrame
end

function Window:CreateControlButton(text, callback, color)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 25, 0, 25)
    button.BackgroundColor3 = color or self.Theme.Secondary
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = self.Theme.Text
    button.TextSize = 16
    button.Font = Enum.Font.GothamBold
    
    self.DoorLib:CreateCorner(button, 4)
    
    button.MouseEnter:Connect(function()
        self.DoorLib:CreateTween(button, {Duration = 0.2}, {
            BackgroundColor3 = color and color or self.Theme.Accent
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        self.DoorLib:CreateTween(button, {Duration = 0.2}, {
            BackgroundColor3 = color and color or self.Theme.Secondary
        }):Play()
    end)
    
    button.MouseButton1Click:Connect(callback)
    
    return button
end

function Window:SetupDragging()
    local dragStart, startPos
    
    self.TitleBarFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.Dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
            
            local connection
            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    self.Dragging = false
                    connection:Disconnect()
                end
            end)
        end
    end)
    
    self.TitleBarFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and self.Dragging then
            local delta = input.Position - dragStart
            self.MainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

function Window:ToggleMinimize()
    self.Minimized = not self.Minimized
    
    local targetSize = self.Minimized and 
        UDim2.new(self.MainFrame.Size.X.Scale, self.MainFrame.Size.X.Offset, 0, 35) or
        self.Info.Size
    
    self.DoorLib:CreateTween(self.MainFrame, {Duration = 0.3}, {
        Size = targetSize
    }):Play()
    
    self.MinimizeButton.Text = self.Minimized and "□" or "−"
end

function Window:Close()
    self.DoorLib:CreateTween(self.MainFrame, {Duration = 0.3}, {
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1
    }):Play()
    
    wait(0.3)
    self.ScreenGui:Destroy()
end

function Window:MakeTab(Info)
    Info = Info or {}
    local TabInfo = {
        Name = Info.Name or "New Tab",
        Icon = Info.Icon or "",
        Visible = Info.Visible ~= false
    }
    
    local Tab = self.DoorLib.Section.new(TabInfo, self, true)
    table.insert(self.Tabs, Tab)
    
    if #self.Tabs == 1 then
        self.CurrentTab = Tab
        Tab:SetActive(true)
    end
    
    return Tab
end

function Window:SwitchTab(tab)
    if self.CurrentTab == tab then return end
    
    if self.CurrentTab then
        self.CurrentTab:SetActive(false)
    end
    
    self.CurrentTab = tab
    tab:SetActive(true)
end

return Window
