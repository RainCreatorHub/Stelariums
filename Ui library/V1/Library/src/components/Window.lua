-- Window.lua - Advanced Window Management Component
-- Comprehensive window system with tabbed interface, drag functionality, and theme support

local Window = {}
Window.__index = Window

-- Required Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")

-- Local Variables
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

function Window.new(Info, DoorLib)
    local self = setmetatable({}, Window)
    
    -- Core Properties
    self.DoorLib = DoorLib
    self.Info = Info or {}
    self.Theme = DoorLib.Themes[Info.Theme or "Dark"]
    
    -- Window Configuration
    self.Title = self.Info.Title or "DoorLib Window"
    self.SubTitle = self.Info.SubTitle or "Advanced UI Framework"
    self.Size = self.Info.Size or UDim2.new(0, 580, 0, 420)
    self.Position = self.Info.Position or UDim2.new(0.5, -290, 0.5, -210)
    self.Resizable = self.Info.Resizable ~= false
    
    -- State Management
    self.Tabs = {}
    self.CurrentTab = nil
    self.WindowState = {
        Minimized = false,
        Maximized = false,
        Dragging = false,
        Resizing = false,
        Visible = true
    }
    
    -- Original size storage for maximize/restore functionality
    self.OriginalSize = self.Size
    self.OriginalPosition = self.Position
    
    self:InitializeWindow()
    self:ConfigureWindowBehavior()
    
    return self
end

function Window:InitializeWindow()
    -- Primary ScreenGui Container
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "DoorLibWindow_" .. tostring(math.random(1000, 9999))
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.DisplayOrder = 100
    self.ScreenGui.Parent = PlayerGui
    
    -- Main Window Container
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "WindowContainer"
    self.MainFrame.Size = self.Size
    self.MainFrame.Position = self.Position
    self.MainFrame.BackgroundColor3 = self.Theme.Primary
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.ClipsDescendants = true
    self.MainFrame.Active = true
    self.MainFrame.Parent = self.ScreenGui
    
    self:ApplyWindowStyling()
    self:CreateWindowStructure()
end

function Window:ApplyWindowStyling()
    -- Window Corner Radius
    self.DoorLib:CreateCorner(self.MainFrame, 12)
    
    -- Window Border
    local windowStroke = self.DoorLib:CreateStroke(self.MainFrame, 1, self.Theme.Border)
    windowStroke.Transparency = 0.3
    
    -- Window Background Gradient
    self.WindowGradient = self.DoorLib:CreateGradient(self.MainFrame, {
        {0, self.Theme.Primary},
        {0.4, self.Theme.Secondary},
        {0.6, self.Theme.Secondary},
        {1, self.Theme.Primary}
    }, 135)
    
    -- Drop Shadow Implementation
    self.ShadowFrame = Instance.new("ImageLabel")
    self.ShadowFrame.Name = "WindowShadow"
    self.ShadowFrame.Size = UDim2.new(1, 30, 1, 30)
    self.ShadowFrame.Position = UDim2.new(0, -15, 0, -15)
    self.ShadowFrame.BackgroundTransparency = 1
    self.ShadowFrame.Image = "rbxasset://textures/ui/Controls/DropShadow.png"
    self.ShadowFrame.ImageColor3 = Color3.fromRGB(0, 0, 0)
    self.ShadowFrame.ImageTransparency = 0.4
    self.ShadowFrame.ScaleType = Enum.ScaleType.Slice
    self.ShadowFrame.SliceCenter = Rect.new(12, 12, 244, 244)
    self.ShadowFrame.ZIndex = -1
    self.ShadowFrame.Parent = self.MainFrame
end

function Window:CreateWindowStructure()
    -- Title Bar Creation
    self.TitleBarFrame = Instance.new("Frame")
    self.TitleBarFrame.Name = "TitleBar"
    self.TitleBarFrame.Size = UDim2.new(1, 0, 0, 40)
    self.TitleBarFrame.Position = UDim2.new(0, 0, 0, 0)
    self.TitleBarFrame.BackgroundColor3 = self.Theme.Secondary
    self.TitleBarFrame.BorderSizePixel = 0
    self.TitleBarFrame.Parent = self.MainFrame
    
    self.DoorLib:CreateCorner(self.TitleBarFrame, 12)
    
    -- Title Bar Gradient
    self.TitleBarGradient = self.DoorLib:CreateGradient(self.TitleBarFrame, {
        {0, self.Theme.Accent},
        {0.3, self.Theme.Secondary},
        {0.7, self.Theme.Secondary},
        {1, self.Theme.Accent}
    }, 90)
    
    self:CreateTitleElements()
    self:CreateWindowControls()
    
    -- Tab Navigation Area
    self.TabNavigationFrame = Instance.new("Frame")
    self.TabNavigationFrame.Name = "TabNavigation"
    self.TabNavigationFrame.Size = UDim2.new(1, 0, 0, 45)
    self.TabNavigationFrame.Position = UDim2.new(0, 0, 0, 40)
    self.TabNavigationFrame.BackgroundColor3 = self.Theme.Primary
    self.TabNavigationFrame.BackgroundTransparency = 0.1
    self.TabNavigationFrame.BorderSizePixel = 0
    self.TabNavigationFrame.Parent = self.MainFrame
    
    -- Tab List Scrolling Container
    self.TabList = Instance.new("ScrollingFrame")
    self.TabList.Name = "TabList"
    self.TabList.Size = UDim2.new(1, -10, 1, -10)
    self.TabList.Position = UDim2.new(0, 5, 0, 5)
    self.TabList.BackgroundTransparency = 1
    self.TabList.BorderSizePixel = 0
    self.TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.TabList.ScrollBarThickness = 0
    self.TabList.ScrollingDirection = Enum.ScrollingDirection.X
    self.TabList.Parent = self.TabNavigationFrame
    
    -- Tab Layout Management
    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.FillDirection = Enum.FillDirection.Horizontal
    tabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    tabListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    tabListLayout.Padding = UDim.new(0, 6)
    tabListLayout.Parent = self.TabList
    
    -- Content Display Area
    self.ContentArea = Instance.new("Frame")
    self.ContentArea.Name = "ContentArea"
    self.ContentArea.Size = UDim2.new(1, 0, 1, -85)
    self.ContentArea.Position = UDim2.new(0, 0, 0, 85)
    self.ContentArea.BackgroundTransparency = 1
    self.ContentArea.Parent = self.MainFrame
end

function Window:CreateTitleElements()
    -- Window Icon Container
    self.IconFrame = Instance.new("Frame")
    self.IconFrame.Name = "WindowIcon"
    self.IconFrame.Size = UDim2.new(0, 28, 0, 28)
    self.IconFrame.Position = UDim2.new(0, 8, 0.5, -14)
    self.IconFrame.BackgroundColor3 = self.Theme.Accent
    self.IconFrame.BorderSizePixel = 0
    self.IconFrame.Parent = self.TitleBarFrame
    
    self.DoorLib:CreateCorner(self.IconFrame, 8)
    
    -- Icon Glow Effect
    local iconGlow = Instance.new("Frame")
    iconGlow.Name = "IconGlow"
    iconGlow.Size = UDim2.new(1, 6, 1, 6)
    iconGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
    iconGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    iconGlow.BackgroundColor3 = self.Theme.Accent
    iconGlow.BackgroundTransparency = 0.6
    iconGlow.BorderSizePixel = 0
    iconGlow.ZIndex = -1
    iconGlow.Parent = self.IconFrame
    
    self.DoorLib:CreateCorner(iconGlow, 11)
    
    -- Title and Subtitle Container
    self.TitleContainer = Instance.new("Frame")
    self.TitleContainer.Name = "TitleContainer"
    self.TitleContainer.Size = UDim2.new(1, -150, 1, 0)
    self.TitleContainer.Position = UDim2.new(0, 44, 0, 0)
    self.TitleContainer.BackgroundTransparency = 1
    self.TitleContainer.Parent = self.TitleBarFrame
    
    -- Primary Title
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Name = "WindowTitle"
    self.TitleLabel.Size = UDim2.new(1, 0, 0.65, 0)
    self.TitleLabel.Position = UDim2.new(0, 0, 0, 2)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = self.Title
    self.TitleLabel.TextColor3 = self.Theme.Text
    self.TitleLabel.TextSize = 16
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.TextYAlignment = Enum.TextYAlignment.Bottom
    self.TitleLabel.Font = Enum.Font.GothamBold
    self.TitleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    self.TitleLabel.Parent = self.TitleContainer
    
    -- Subtitle
    self.SubTitleLabel = Instance.new("TextLabel")
    self.SubTitleLabel.Name = "WindowSubTitle"
    self.SubTitleLabel.Size = UDim2.new(1, 0, 0.35, 0)
    self.SubTitleLabel.Position = UDim2.new(0, 0, 0.65, -2)
    self.SubTitleLabel.BackgroundTransparency = 1
    self.SubTitleLabel.Text = self.SubTitle
    self.SubTitleLabel.TextColor3 = self.Theme.TextSecondary
    self.SubTitleLabel.TextSize = 11
    self.SubTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.SubTitleLabel.TextYAlignment = Enum.TextYAlignment.Top
    self.SubTitleLabel.Font = Enum.Font.Gotham
    self.SubTitleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    self.SubTitleLabel.Parent = self.TitleContainer
end

function Window:CreateWindowControls()
    -- Control Buttons Container
    self.ControlsContainer = Instance.new("Frame")
    self.ControlsContainer.Name = "WindowControls"
    self.ControlsContainer.Size = UDim2.new(0, 105, 0, 28)
    self.ControlsContainer.Position = UDim2.new(1, -113, 0.5, -14)
    self.ControlsContainer.BackgroundTransparency = 1
    self.ControlsContainer.Parent = self.TitleBarFrame
    
    local controlsLayout = Instance.new("UIListLayout")
    controlsLayout.FillDirection = Enum.FillDirection.Horizontal
    controlsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    controlsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    controlsLayout.Padding = UDim.new(0, 4)
    controlsLayout.Parent = self.ControlsContainer
    
    -- Minimize Control
    self.MinimizeButton = self:CreateControlButton("—", "Minimize Window", function()
        self:ToggleMinimize()
    end, self.Theme.Warning)
    self.MinimizeButton.Parent = self.ControlsContainer
    
    -- Maximize Control
    if self.Resizable then
        self.MaximizeButton = self:CreateControlButton("□", "Maximize Window", function()
            self:ToggleMaximize()
        end, self.Theme.Success)
        self.MaximizeButton.Parent = self.ControlsContainer
    end
    
    -- Close Control
    self.CloseButton = self:CreateControlButton("×", "Close Window", function()
        self:CloseWindow()
    end, self.Theme.Error)
    self.CloseButton.Parent = self.ControlsContainer
end

function Window:CreateControlButton(symbol, tooltip, callback, hoverColor)
    local controlButton = Instance.new("TextButton")
    controlButton.Name = tooltip:gsub(" ", "") .. "Button"
    controlButton.Size = UDim2.new(0, 28, 0, 28)
    controlButton.BackgroundColor3 = Color3.new(1, 1, 1)
    controlButton.BackgroundTransparency = 0.85
    controlButton.BorderSizePixel = 0
    controlButton.Text = symbol
    controlButton.TextColor3 = self.Theme.Text
    controlButton.TextSize = 14
    controlButton.Font = Enum.Font.GothamBold
    controlButton.AutoButtonColor = false
    
    self.DoorLib:CreateCorner(controlButton, 6)
    
    -- Control Button Interactions
    controlButton.MouseEnter:Connect(function()
        self.DoorLib:CreateTween(controlButton, {Duration = 0.2}, {
            BackgroundColor3 = hoverColor,
            BackgroundTransparency = 0.1,
            Size = UDim2.new(0, 30, 0, 30)
        }):Play()
    end)
    
    controlButton.MouseLeave:Connect(function()
        self.DoorLib:CreateTween(controlButton, {Duration = 0.2}, {
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 0.85,
            Size = UDim2.new(0, 28, 0, 28)
        }):Play()
    end)
    
    controlButton.MouseButton1Click:Connect(function()
        self.DoorLib:CreateTween(controlButton, {Duration = 0.1}, {
            Size = UDim2.new(0, 26, 0, 26)
        }):Play()
        
        spawn(function()
            wait(0.1)
            self.DoorLib:CreateTween(controlButton, {Duration = 0.1}, {
                Size = UDim2.new(0, 28, 0, 28)
            }):Play()
        end)
        
        callback()
    end)
    
    return controlButton
end

function Window:ConfigureWindowBehavior()
    self:EnableDragFunctionality()
    self:EnableResizeFunctionality()
    self:ConfigureDoubleClickMaximize()
end

function Window:EnableDragFunctionality()
    local dragStart, startPosition
    
    self.TitleBarFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and not self.WindowState.Maximized then
            self.WindowState.Dragging = true
            dragStart = input.Position
            startPosition = self.MainFrame.Position
            
            -- Visual feedback during drag
            self.DoorLib:CreateTween(self.MainFrame, {Duration = 0.1}, {
                Size = self.MainFrame.Size - UDim2.new(0, 2, 0, 2)
            }):Play()
        end
    end)
    
    self.TitleBarFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and self.WindowState.Dragging then
            local deltaPosition = input.Position - dragStart
            local newPosition = UDim2.new(
                startPosition.X.Scale, startPosition.X.Offset + deltaPosition.X,
                startPosition.Y.Scale, startPosition.Y.Offset + deltaPosition.Y
            )
            
            -- Boundary constraints
            local viewportSize = workspace.CurrentCamera.ViewportSize
            local constrainedPosition = self:ConstrainToViewport(newPosition, viewportSize)
            
            self.MainFrame.Position = constrainedPosition
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and self.WindowState.Dragging then
            self.WindowState.Dragging = false
            
            -- Reset visual feedback
            self.DoorLib:CreateTween(self.MainFrame, {Duration = 0.1}, {
                Size = self.OriginalSize
            }):Play()
        end
    end)
end

function Window:EnableResizeFunctionality()
    if not self.Resizable then return end
    
    -- Resize Handle Creation
    self.ResizeHandle = Instance.new("Frame")
    self.ResizeHandle.Name = "ResizeHandle"
    self.ResizeHandle.Size = UDim2.new(0, 20, 0, 20)
    self.ResizeHandle.Position = UDim2.new(1, -20, 1, -20)
    self.ResizeHandle.BackgroundTransparency = 1
    self.ResizeHandle.Parent = self.MainFrame
    
    local resizeIndicator = Instance.new("TextLabel")
    resizeIndicator.Size = UDim2.new(1, 0, 1, 0)
    resizeIndicator.BackgroundTransparency = 1
    resizeIndicator.Text = "⤡"
    resizeIndicator.TextColor3 = self.Theme.TextSecondary
    resizeIndicator.TextSize = 16
    resizeIndicator.Font = Enum.Font.Gotham
    resizeIndicator.Parent = self.ResizeHandle
    
    local resizeStart, initialSize
    
    self.ResizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.WindowState.Resizing = true
            resizeStart = input.Position
            initialSize = self.MainFrame.Size
        end
    end)
    
    self.ResizeHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and self.WindowState.Resizing then
            local deltaSize = input.Position - resizeStart
            local newSize = UDim2.new(
                initialSize.X.Scale, math.max(400, initialSize.X.Offset + deltaSize.X),
                initialSize.Y.Scale, math.max(300, initialSize.Y.Offset + deltaSize.Y)
            )
            
            self.MainFrame.Size = newSize
            self.OriginalSize = newSize
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.WindowState.Resizing = false
        end
    end)
end

function Window:ConfigureDoubleClickMaximize()
    local lastClickTime = 0
    
    self.TitleBarFrame.MouseButton1Click:Connect(function()
        local currentTime = tick()
        if currentTime - lastClickTime < 0.3 and self.Resizable then
            self:ToggleMaximize()
        end
        lastClickTime = currentTime
    end)
end

function Window:ConstrainToViewport(position, viewportSize)
    local windowSize = self.MainFrame.AbsoluteSize
    local constrainedX = math.clamp(position.X.Offset, 0, viewportSize.X - windowSize.X)
    local constrainedY = math.clamp(position.Y.Offset, 0, viewportSize.Y - windowSize.Y)
    
    return UDim2.new(position.X.Scale, constrainedX, position.Y.Scale, constrainedY)
end

-- Window State Management Methods
function Window:ToggleMinimize()
    self.WindowState.Minimized = not self.WindowState.Minimized
    
    local targetSize = self.WindowState.Minimized and 
        UDim2.new(self.MainFrame.Size.X.Scale, self.MainFrame.Size.X.Offset, 0, 40) or
        (self.WindowState.Maximized and self:GetMaximizedSize() or self.OriginalSize)
    
    self.DoorLib:CreateTween(self.MainFrame, {Duration = 0.4, EasingStyle = Enum.EasingStyle.Back}, {
        Size = targetSize
    }):Play()
    
    -- Update minimize button symbol
    self.MinimizeButton.Text = self.WindowState.Minimized and "□" or "—"
    
    -- Hide/show content areas
    self.TabNavigationFrame.Visible = not self.WindowState.Minimized
    self.ContentArea.Visible = not self.WindowState.Minimized
end

function Window:ToggleMaximize()
    if not self.Resizable then return end
    
    self.WindowState.Maximized = not self.WindowState.Maximized
    
    if self.WindowState.Maximized then
        -- Store current state before maximizing
        if not self.WindowState.Minimized then
            self.OriginalSize = self.MainFrame.Size
            self.OriginalPosition = self.MainFrame.Position
        end
        
        local maximizedSize = self:GetMaximizedSize()
        local maximizedPosition = UDim2.new(0, 0, 0, 0)
        
        self.DoorLib:CreateTween(self.MainFrame, {Duration = 0.3}, {
            Size = maximizedSize,
            Position = maximizedPosition
        }):Play()
        
        self.MaximizeButton.Text = "❐"
    else
        -- Restore to original state
        self.DoorLib:CreateTween(self.MainFrame, {Duration = 0.3}, {
            Size = self.OriginalSize,
            Position = self.OriginalPosition
        }):Play()
        
        self.MaximizeButton.Text = "□"
    end
end

function Window:GetMaximizedSize()
    local viewportSize = workspace.CurrentCamera.ViewportSize
    local guiInset = GuiService:GetGuiInset()
    return UDim2.new(0, viewportSize.X, 0, viewportSize.Y - guiInset.Y)
end

function Window:CloseWindow()
    -- Fade out animation
    self.DoorLib:CreateTween(self.MainFrame, {Duration = 0.3}, {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
    
    -- Fade shadow
    self.DoorLib:CreateTween(self.ShadowFrame, {Duration = 0.3}, {
        ImageTransparency = 1
    }):Play()
    
    spawn(function()
        wait(0.3)
        self.ScreenGui:Destroy()
    end)
end

-- Tab Management Methods
function Window:MakeTab(Info)
    local Tab = self.DoorLib.Tab.new(Info, self)
    table.insert(self.Tabs, Tab)
    
    -- Activate first tab automatically
    if #self.Tabs == 1 then
        self:SwitchTab(Tab)
    end
    
    return Tab
end

function Window:SwitchTab(targetTab)
    if self.CurrentTab == targetTab then return end
    
    -- Deactivate current tab
    if self.CurrentTab then
        self.CurrentTab:SetActive(false)
    end
    
    -- Activate target tab
    self.CurrentTab = targetTab
    targetTab:SetActive(true)
    
    -- Update window title if tab has custom title
    if targetTab.Info.WindowTitle then
        self:UpdateTitle(targetTab.Info.WindowTitle)
    end
end

function Window:GetCurrentTab()
    return self.CurrentTab
end

function Window:RemoveTab(tab)
    for index, existingTab in ipairs(self.Tabs) do
        if existingTab == tab then
            table.remove(self.Tabs, index)
            break
        end
    end
    
    -- Switch to another tab if the removed tab was active
    if self.CurrentTab == tab and #self.Tabs > 0 then
        self:SwitchTab(self.Tabs[1])
    end
end

-- Window Property Management
function Window:UpdateTitle(newTitle)
    self.Title = newTitle
    self.TitleLabel.Text = newTitle
end

function Window:UpdateSubTitle(newSubTitle)
    self.SubTitle = newSubTitle
    self.SubTitleLabel.Text = newSubTitle
end

function Window:SetTheme(themeName)
    local newTheme = self.DoorLib.Themes[themeName]
    if not newTheme then return end
    
    self.Theme = newTheme
    
    -- Apply theme changes with animations
    local animationDuration = 0.4
    
    self.DoorLib:CreateTween(self.MainFrame, {Duration = animationDuration}, {
        BackgroundColor3 = self.Theme.Primary
    }):Play()
    
    self.DoorLib:CreateTween(self.TitleBarFrame, {Duration = animationDuration}, {
        BackgroundColor3 = self.Theme.Secondary
    }):Play()
    
    self.DoorLib:CreateTween(self.TitleLabel, {Duration = animationDuration}, {
        TextColor3 = self.Theme.Text
    }):Play()
    
    self.DoorLib:CreateTween(self.SubTitleLabel, {Duration = animationDuration}, {
        TextColor3 = self.Theme.TextSecondary
    }):Play()
    
    self.DoorLib:CreateTween(self.IconFrame, {Duration = animationDuration}, {
        BackgroundColor3 = self.Theme.Accent
    }):Play()
    
    -- Update gradients
    spawn(function()
        wait(animationDuration * 0.5)
        
        self.WindowGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, self.Theme.Primary),
            ColorSequenceKeypoint.new(0.4, self.Theme.Secondary),
            ColorSequenceKeypoint.new(0.6, self.Theme.Secondary),
            ColorSequenceKeypoint.new(1, self.Theme.Primary)
        })
        
        self.TitleBarGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, self.Theme.Accent),
            ColorSequenceKeypoint.new(0.3, self.Theme.Secondary),
            ColorSequenceKeypoint.new(0.7, self.Theme.Secondary),
            ColorSequenceKeypoint.new(1, self.Theme.Accent)
        })
    end)
    
    -- Update all tabs with new theme
    for _, tab in ipairs(self.Tabs) do
        tab.Theme = self.Theme
        -- Tab-specific theme updates would be handled in Tab component
    end
end

function Window:SetVisible(visible)
    self.WindowState.Visible = visible
    self.ScreenGui.Enabled = visible
end

function Window:GetWindowState()
    return {
        Minimized = self.WindowState.Minimized,
        Maximized = self.WindowState.Maximized,
        Visible = self.WindowState.Visible,
        Size = self.MainFrame.Size,
        Position = self.MainFrame.Position,
        TabCount = #self.Tabs,
        CurrentTab = self.CurrentTab and self.CurrentTab.Name or nil
    }
end

return Window
