-- TitleBar.lua - Advanced TitleBar Component
-- Handles title display, window controls, and drag functionality

local TitleBar = {}
TitleBar.__index = TitleBar

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

function TitleBar.new(Parent, DoorLib, WindowInstance)
    local self = setmetatable({}, TitleBar)
    
    self.Parent = Parent
    self.DoorLib = DoorLib
    self.Window = WindowInstance
    self.Theme = WindowInstance.Theme
    self.Dragging = false
    self.ResizeMode = false
    
    self:CreateTitleBar()
    self:SetupInteractions()
    
    return self
end

function TitleBar:CreateTitleBar()
    -- Main TitleBar Frame
    self.Frame = Instance.new("Frame")
    self.Frame.Name = "TitleBar"
    self.Frame.Size = UDim2.new(1, 0, 0, 40)
    self.Frame.Position = UDim2.new(0, 0, 0, 0)
    self.Frame.BackgroundColor3 = self.Theme.Secondary
    self.Frame.BorderSizePixel = 0
    self.Frame.ZIndex = 10
    self.Frame.Parent = self.Parent
    
    -- Styling
    self.DoorLib:CreateCorner(self.Frame, 12)
    self.DoorLib:CreateStroke(self.Frame, 1, self.Theme.Border)
    
    -- Animated gradient background
    self.BackgroundGradient = self.DoorLib:CreateGradient(self.Frame, {
        {0, self.Theme.Accent},
        {0.4, self.Theme.Secondary}, 
        {0.6, self.Theme.Secondary},
        {1, self.Theme.Accent}
    }, 0)
    
    -- Title Section
    self:CreateTitleSection()
    
    -- Controls Section
    self:CreateControlsSection()
    
    -- Status Indicator
    self:CreateStatusIndicator()
    
    -- Resize Handle (if resizable)
    if self.Window.Info.Resizable then
        self:CreateResizeHandle()
    end
end

function TitleBar:CreateTitleSection()
    -- Icon (optional)
    self.IconFrame = Instance.new("Frame")
    self.IconFrame.Name = "IconFrame"
    self.IconFrame.Size = UDim2.new(0, 30, 0, 30)
    self.IconFrame.Position = UDim2.new(0, 8, 0.5, -15)
    self.IconFrame.BackgroundColor3 = self.Theme.Accent
    self.IconFrame.BorderSizePixel = 0
    self.IconFrame.Parent = self.Frame
    
    self.DoorLib:CreateCorner(self.IconFrame, 6)
    
    local iconGlow = Instance.new("Frame")
    iconGlow.Name = "IconGlow"
    iconGlow.Size = UDim2.new(1, 4, 1, 4)
    iconGlow.Position = UDim2.new(0.5, -2, 0.5, -2)
    iconGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    iconGlow.BackgroundColor3 = self.Theme.Accent
    iconGlow.BackgroundTransparency = 0.7
    iconGlow.BorderSizePixel = 0
    iconGlow.ZIndex = -1
    iconGlow.Parent = self.IconFrame
    
    self.DoorLib:CreateCorner(iconGlow, 8)
    
    -- Title Text Container
    self.TitleContainer = Instance.new("Frame")
    self.TitleContainer.Name = "TitleContainer"
    self.TitleContainer.Size = UDim2.new(1, -160, 1, 0)
    self.TitleContainer.Position = UDim2.new(0, 45, 0, 0)
    self.TitleContainer.BackgroundTransparency = 1
    self.TitleContainer.Parent = self.Frame
    
    -- Main Title
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Name = "Title"
    self.TitleLabel.Size = UDim2.new(1, 0, 0.6, 0)
    self.TitleLabel.Position = UDim2.new(0, 0, 0, 2)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = self.Window.Info.Title
    self.TitleLabel.TextColor3 = self.Theme.Text
    self.TitleLabel.TextSize = 16
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.TextYAlignment = Enum.TextYAlignment.Bottom
    self.TitleLabel.Font = Enum.Font.GothamBold
    self.TitleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    self.TitleLabel.Parent = self.TitleContainer
    
    -- Subtitle
    self.SubTitleLabel = Instance.new("TextLabel")
    self.SubTitleLabel.Name = "SubTitle"
    self.SubTitleLabel.Size = UDim2.new(1, 0, 0.4, 0)
    self.SubTitleLabel.Position = UDim2.new(0, 0, 0.6, -2)
    self.SubTitleLabel.BackgroundTransparency = 1
    self.SubTitleLabel.Text = self.Window.Info.SubTitle
    self.SubTitleLabel.TextColor3 = self.Theme.TextSecondary
    self.SubTitleLabel.TextSize = 11
    self.SubTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.SubTitleLabel.TextYAlignment = Enum.TextYAlignment.Top
    self.SubTitleLabel.Font = Enum.Font.Gotham
    self.SubTitleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    self.SubTitleLabel.Parent = self.TitleContainer
end

function TitleBar:CreateControlsSection()
    -- Controls Container
    self.ControlsFrame = Instance.new("Frame")
    self.ControlsFrame.Name = "Controls"
    self.ControlsFrame.Size = UDim2.new(0, 100, 0, 30)
    self.ControlsFrame.Position = UDim2.new(1, -108, 0.5, -15)
    self.ControlsFrame.BackgroundTransparency = 1
    self.ControlsFrame.Parent = self.Frame
    
    local controlsLayout = Instance.new("UIListLayout")
    controlsLayout.FillDirection = Enum.FillDirection.Horizontal
    controlsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    controlsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    controlsLayout.Padding = UDim.new(0, 4)
    controlsLayout.Parent = self.ControlsFrame
    
    -- Minimize Button
    self.MinimizeButton = self:CreateControlButton("—", "Minimize", function()
        self.Window:ToggleMinimize()
    end, self.Theme.Warning)
    self.MinimizeButton.Parent = self.ControlsFrame
    
    -- Maximize Button (if resizable)
    if self.Window.Info.Resizable then
        self.MaximizeButton = self:CreateControlButton("□", "Maximize", function()
            self.Window:ToggleMaximize()
        end, self.Theme.Success)
        self.MaximizeButton.Parent = self.ControlsFrame
    end
    
    -- Close Button
    self.CloseButton = self:CreateControlButton("×", "Close", function()
        self.Window:Close()
    end, self.Theme.Error)
    self.CloseButton.Parent = self.ControlsFrame
end

function TitleBar:CreateControlButton(text, tooltip, callback, hoverColor)
    local button = Instance.new("TextButton")
    button.Name = tooltip .. "Button"
    button.Size = UDim2.new(0, 28, 0, 28)
    button.BackgroundColor3 = Color3.new(1, 1, 1)
    button.BackgroundTransparency = 0.9
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = self.Theme.Text
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    button.AutoButtonColor = false
    
    self.DoorLib:CreateCorner(button, 6)
    
    -- Hover effects
    local function onEnter()
        self.DoorLib:CreateTween(button, {Duration = 0.2}, {
            BackgroundColor3 = hoverColor,
            BackgroundTransparency = 0.1,
            TextSize = 15
        }):Play()
    end
    
    local function onLeave()
        self.DoorLib:CreateTween(button, {Duration = 0.2}, {
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 0.9,
            TextSize = 14
        }):Play()
    end
    
    local function onClick()
        -- Click animation
        self.DoorLib:CreateTween(button, {Duration = 0.1}, {
            Size = UDim2.new(0, 26, 0, 26)
        }):Play()
        
        wait(0.1)
        
        self.DoorLib:CreateTween(button, {Duration = 0.1}, {
            Size = UDim2.new(0, 28, 0, 28)
        }):Play()
        
        callback()
    end
    
    button.MouseEnter:Connect(onEnter)
    button.MouseLeave:Connect(onLeave)
    button.MouseButton1Click:Connect(onClick)
    
    return button
end

function TitleBar:CreateStatusIndicator()
    -- Status indicator for connection/activity
    self.StatusIndicator = Instance.new("Frame")
    self.StatusIndicator.Name = "StatusIndicator"
    self.StatusIndicator.Size = UDim2.new(0, 8, 0, 8)
    self.StatusIndicator.Position = UDim2.new(1, -16, 0, 8)
    self.StatusIndicator.BackgroundColor3 = self.Theme.Success
    self.StatusIndicator.BorderSizePixel = 0
    self.StatusIndicator.Parent = self.Frame
    
    self.DoorLib:CreateCorner(self.StatusIndicator, 4)
    
    -- Pulsing animation
    spawn(function()
        while self.StatusIndicator.Parent do
            self.DoorLib:CreateTween(self.StatusIndicator, {Duration = 1}, {
                BackgroundTransparency = 0.5
            }):Play()
            wait(1)
            self.DoorLib:CreateTween(self.StatusIndicator, {Duration = 1}, {
                BackgroundTransparency = 0
            }):Play()
            wait(1)
        end
    end)
end

function TitleBar:CreateResizeHandle()
    self.ResizeHandle = Instance.new("Frame")
    self.ResizeHandle.Name = "ResizeHandle"
    self.ResizeHandle.Size = UDim2.new(0, 20, 0, 20)
    self.ResizeHandle.Position = UDim2.new(1, -20, 1, -20)
    self.ResizeHandle.BackgroundTransparency = 1
    self.ResizeHandle.Parent = self.Parent
    
    local resizeIcon = Instance.new("TextLabel")
    resizeIcon.Size = UDim2.new(1, 0, 1, 0)
    resizeIcon.BackgroundTransparency = 1
    resizeIcon.Text = "⤡"
    resizeIcon.TextColor3 = self.Theme.TextSecondary
    resizeIcon.TextSize = 14
    resizeIcon.Font = Enum.Font.Gotham
    resizeIcon.Parent = self.ResizeHandle
    
    self:SetupResizing()
end

function TitleBar:SetupInteractions()
    self:SetupDragging()
    self:SetupDoubleClick()
end

function TitleBar:SetupDragging()
    local dragStart, startPos
    local dragging = false
    
    self.Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.Window.MainFrame.Position
            
            -- Visual feedback
            self.DoorLib:CreateTween(self.Frame, {Duration = 0.2}, {
                BackgroundTransparency = 0.1
            }):Play()
        end
    end)
    
    self.Frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            self.Window.MainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
            dragging = false
            
            -- Remove visual feedback
            self.DoorLib:CreateTween(self.Frame, {Duration = 0.2}, {
                BackgroundTransparency = 0
            }):Play()
        end
    end)
end

function TitleBar:SetupDoubleClick()
    local lastClick = 0
    
    self.Frame.MouseButton1Click:Connect(function()
        local currentTime = tick()
        if currentTime - lastClick < 0.3 and self.Window.Info.Resizable then
            self.Window:ToggleMaximize()
        end
        lastClick = currentTime
    end)
end

function TitleBar:SetupResizing()
    if not self.ResizeHandle then return end
    
    local resizing = false
    local startSize, startPos
    
    self.ResizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            startSize = self.Window.MainFrame.Size
            startPos = input.Position
        end
    end)
    
    self.ResizeHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and resizing then
            local delta = input.Position - startPos
            local newSize = UDim2.new(
                startSize.X.Scale, math.max(300, startSize.X.Offset + delta.X),
                startSize.Y.Scale, math.max(200, startSize.Y.Offset + delta.Y)
            )
            self.Window.MainFrame.Size = newSize
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = false
        end
    end)
end

function TitleBar:UpdateTitle(newTitle)
    self.TitleLabel.Text = newTitle
    self.Window.Info.Title = newTitle
end

function TitleBar:UpdateSubTitle(newSubTitle)
    self.SubTitleLabel.Text = newSubTitle
    self.Window.Info.SubTitle = newSubTitle
end

function TitleBar:SetTheme(themeName)
    local newTheme = self.DoorLib.Themes[themeName]
    if not newTheme then return end
    
    self.Theme = newTheme
    self.Window.Theme = newTheme
    
    -- Update colors with animation
    self.DoorLib:CreateTween(self.Frame, {Duration = 0.3}, {
        BackgroundColor3 = self.Theme.Secondary
    }):Play()
    
    self.DoorLib:CreateTween(self.TitleLabel, {Duration = 0.3}, {
        TextColor3 = self.Theme.Text
    }):Play()
    
    self.DoorLib:CreateTween(self.SubTitleLabel, {Duration = 0.3}, {
        TextColor3 = self.Theme.TextSecondary
    }):Play()
    
    self.DoorLib:CreateTween(self.IconFrame, {Duration = 0.3}, {
        BackgroundColor3 = self.Theme.Accent
    }):Play()
end

return TitleBar
