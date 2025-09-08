-- Tab.lua - Advanced Tab Component
-- Handles individual tab functionality, content management, and visual states

local Tab = {}
Tab.__index = Tab

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

function Tab.new(Info, Window)
    local self = setmetatable({}, Tab)
    
    self.Info = Info or {}
    self.Window = Window
    self.DoorLib = Window.DoorLib
    self.Theme = Window.Theme
    
    self.Name = self.Info.Name or "New Tab"
    self.Icon = self.Info.Icon or ""
    self.Description = self.Info.Description or ""
    self.Visible = self.Info.Visible ~= false
    self.Active = false
    self.Elements = {}
    self.Sections = {}
    
    self:CreateTab()
    self:SetupTabInteractions()
    
    return self
end

function Tab:CreateTab()
    -- Tab Button Container
    self.TabButtonContainer = Instance.new("Frame")
    self.TabButtonContainer.Name = self.Name .. "TabButton"
    self.TabButtonContainer.Size = UDim2.new(0, 140, 1, -10)
    self.TabButtonContainer.BackgroundTransparency = 1
    self.TabButtonContainer.Visible = self.Visible
    self.TabButtonContainer.Parent = self.Window.TabList
    
    -- Tab Button Frame
    self.TabButton = Instance.new("TextButton")
    self.TabButton.Name = "TabButton"
    self.TabButton.Size = UDim2.new(1, 0, 1, 0)
    self.TabButton.BackgroundColor3 = self.Theme.Secondary
    self.TabButton.BackgroundTransparency = 0.4
    self.TabButton.BorderSizePixel = 0
    self.TabButton.Text = ""
    self.TabButton.AutoButtonColor = false
    self.TabButton.Parent = self.TabButtonContainer
    
    -- Tab Button Styling
    self.DoorLib:CreateCorner(self.TabButton, 8)
    local tabStroke = self.DoorLib:CreateStroke(self.TabButton, 1, Color3.new(1, 1, 1))
    tabStroke.Transparency = 0.85
    
    -- Tab Button Gradient
    self.TabGradient = self.DoorLib:CreateGradient(self.TabButton, {
        {0, self.Theme.Secondary},
        {0.3, self.Theme.Primary},
        {0.7, self.Theme.Primary},
        {1, self.Theme.Secondary}
    }, 45)
    
    -- Tab Icon Container
    if self.Icon and self.Icon ~= "" then
        self.IconContainer = Instance.new("Frame")
        self.IconContainer.Name = "IconContainer"
        self.IconContainer.Size = UDim2.new(0, 24, 0, 24)
        self.IconContainer.Position = UDim2.new(0, 8, 0.5, -12)
        self.IconContainer.BackgroundColor3 = self.Theme.Accent
        self.IconContainer.BackgroundTransparency = 0.8
        self.IconContainer.BorderSizePixel = 0
        self.IconContainer.Parent = self.TabButton
        
        self.DoorLib:CreateCorner(self.IconContainer, 6)
        
        -- Tab Icon
        self.TabIcon = Instance.new("ImageLabel")
        self.TabIcon.Name = "TabIcon"
        self.TabIcon.Size = UDim2.new(0, 16, 0, 16)
        self.TabIcon.Position = UDim2.new(0.5, -8, 0.5, -8)
        self.TabIcon.BackgroundTransparency = 1
        self.TabIcon.Image = self.Icon
        self.TabIcon.ImageColor3 = self.Theme.TextSecondary
        self.TabIcon.Parent = self.IconContainer
    end
    
    -- Tab Label
    self.TabLabel = Instance.new("TextLabel")
    self.TabLabel.Name = "TabLabel"
    self.TabLabel.Size = UDim2.new(1, self.Icon ~= "" and -40 or -16, 0, 16)
    self.TabLabel.Position = UDim2.new(0, self.Icon ~= "" and 40 or 8, 0.5, -8)
    self.TabLabel.BackgroundTransparency = 1
    self.TabLabel.Text = self.Name
    self.TabLabel.TextColor3 = self.Theme.TextSecondary
    self.TabLabel.TextSize = 13
    self.TabLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TabLabel.TextYAlignment = Enum.TextYAlignment.Center
    self.TabLabel.Font = Enum.Font.GothamMedium
    self.TabLabel.TextTruncate = Enum.TextTruncate.AtEnd
    self.TabLabel.Parent = self.TabButton
    
    -- Tab Active Indicator
    self.ActiveIndicator = Instance.new("Frame")
    self.ActiveIndicator.Name = "ActiveIndicator"
    self.ActiveIndicator.Size = UDim2.new(0, 0, 0, 3)
    self.ActiveIndicator.Position = UDim2.new(0.5, 0, 1, -3)
    self.ActiveIndicator.AnchorPoint = Vector2.new(0.5, 0)
    self.ActiveIndicator.BackgroundColor3 = self.Theme.Accent
    self.ActiveIndicator.BorderSizePixel = 0
    self.ActiveIndicator.Parent = self.TabButton
    
    self.DoorLib:CreateCorner(self.ActiveIndicator, 2)
    
    -- Tab Content Container
    self.ContentContainer = Instance.new("ScrollingFrame")
    self.ContentContainer.Name = self.Name .. "Content"
    self.ContentContainer.Size = UDim2.new(1, -10, 1, -10)
    self.ContentContainer.Position = UDim2.new(0, 5, 0, 5)
    self.ContentContainer.BackgroundTransparency = 1
    self.ContentContainer.BorderSizePixel = 0
    self.ContentContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.ContentContainer.ScrollBarThickness = 6
    self.ContentContainer.ScrollBarImageColor3 = self.Theme.Accent
    self.ContentContainer.ScrollBarImageTransparency = 0.4
    self.ContentContainer.ScrollingDirection = Enum.ScrollingDirection.Y
    self.ContentContainer.Visible = false
    self.ContentContainer.Parent = self.Window.ContentArea
    
    -- Content Layout Manager
    self.ContentLayout = Instance.new("UIListLayout")
    self.ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    self.ContentLayout.Padding = UDim.new(0, 8)
    self.ContentLayout.FillDirection = Enum.FillDirection.Vertical
    self.ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    self.ContentLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    self.ContentLayout.Parent = self.ContentContainer
    
    -- Content Padding
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 0)
    contentPadding.PaddingBottom = UDim.new(0, 10)
    contentPadding.PaddingLeft = UDim.new(0, 0)
    contentPadding.PaddingRight = UDim.new(0, 10)
    contentPadding.Parent = self.ContentContainer
    
    -- Update canvas size automatically
    self.ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.ContentContainer.CanvasSize = UDim2.new(0, 0, 0, self.ContentLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Tab close button (optional)
    if self.Info.Closable then
        self:CreateCloseButton()
    end
    
    -- Tab notification indicator
    self:CreateNotificationIndicator()
    
    -- Update tab list sizing
    self:UpdateTabListCanvas()
end

function Tab:CreateCloseButton()
    self.CloseButton = Instance.new("TextButton")
    self.CloseButton.Name = "CloseButton"
    self.CloseButton.Size = UDim2.new(0, 18, 0, 18)
    self.CloseButton.Position = UDim2.new(1, -22, 0, 4)
    self.CloseButton.BackgroundColor3 = self.Theme.Error
    self.CloseButton.BackgroundTransparency = 0.8
    self.CloseButton.BorderSizePixel = 0
    self.CloseButton.Text = "×"
    self.CloseButton.TextColor3 = self.Theme.Text
    self.CloseButton.TextSize = 12
    self.CloseButton.Font = Enum.Font.GothamBold
    self.CloseButton.Visible = false
    self.CloseButton.Parent = self.TabButton
    
    self.DoorLib:CreateCorner(self.CloseButton, 9)
    
    -- Close button interactions
    self.CloseButton.MouseEnter:Connect(function()
        self.DoorLib:CreateTween(self.CloseButton, {Duration = 0.2}, {
            BackgroundTransparency = 0.2
        }):Play()
    end)
    
    self.CloseButton.MouseLeave:Connect(function()
        self.DoorLib:CreateTween(self.CloseButton, {Duration = 0.2}, {
            BackgroundTransparency = 0.8
        }):Play()
    end)
    
    self.CloseButton.MouseButton1Click:Connect(function()
        self:Close()
    end)
end

function Tab:CreateNotificationIndicator()
    self.NotificationIndicator = Instance.new("Frame")
    self.NotificationIndicator.Name = "NotificationIndicator"
    self.NotificationIndicator.Size = UDim2.new(0, 8, 0, 8)
    self.NotificationIndicator.Position = UDim2.new(1, -12, 0, 4)
    self.NotificationIndicator.BackgroundColor3 = self.Theme.Error
    self.NotificationIndicator.BorderSizePixel = 0
    self.NotificationIndicator.Visible = false
    self.NotificationIndicator.Parent = self.TabButton
    
    self.DoorLib:CreateCorner(self.NotificationIndicator, 4)
    
    -- Notification pulse animation
    spawn(function()
        while self.NotificationIndicator.Parent do
            if self.NotificationIndicator.Visible then
                self.DoorLib:CreateTween(self.NotificationIndicator, {Duration = 0.8}, {
                    BackgroundTransparency = 0.5,
                    Size = UDim2.new(0, 10, 0, 10)
                }):Play()
                wait(0.8)
                self.DoorLib:CreateTween(self.NotificationIndicator, {Duration = 0.8}, {
                    BackgroundTransparency = 0,
                    Size = UDim2.new(0, 8, 0, 8)
                }):Play()
                wait(0.8)
            else
                wait(1)
            end
        end
    end)
end

function Tab:SetupTabInteractions()
    -- Tab selection
    self.TabButton.MouseButton1Click:Connect(function()
        self.Window:SwitchTab(self)
    end)
    
    -- Tab hover effects
    self.TabButton.MouseEnter:Connect(function()
        self:OnTabHover(true)
    end)
    
    self.TabButton.MouseLeave:Connect(function()
        self:OnTabHover(false)
    end)
    
    -- Right-click context menu (future implementation)
    self.TabButton.MouseButton2Click:Connect(function()
        self:ShowContextMenu()
    end)
end

function Tab:OnTabHover(hovering)
    if self.Active then return end
    
    local targetTransparency = hovering and 0.2 or 0.4
    local targetStrokeTransparency = hovering and 0.6 or 0.85
    local targetTextColor = hovering and self.Theme.Text or self.Theme.TextSecondary
    local targetIconColor = hovering and self.Theme.Accent or self.Theme.TextSecondary
    
    -- Button background transition
    self.DoorLib:CreateTween(self.TabButton, {Duration = 0.25}, {
        BackgroundTransparency = targetTransparency
    }):Play()
    
    -- Stroke transition
    if self.TabButton:FindFirstChild("UIStroke") then
        self.DoorLib:CreateTween(self.TabButton.UIStroke, {Duration = 0.25}, {
            Transparency = targetStrokeTransparency
        }):Play()
    end
    
    -- Text color transition
    self.DoorLib:CreateTween(self.TabLabel, {Duration = 0.25}, {
        TextColor3 = targetTextColor
    }):Play()
    
    -- Icon color transition
    if self.TabIcon then
        self.DoorLib:CreateTween(self.TabIcon, {Duration = 0.25}, {
            ImageColor3 = targetIconColor
        }):Play()
        
        self.DoorLib:CreateTween(self.IconContainer, {Duration = 0.25}, {
            BackgroundTransparency = hovering and 0.6 or 0.8
        }):Play()
    end
    
    -- Show close button on hover (if closable)
    if self.CloseButton then
        self.CloseButton.Visible = hovering
    end
end

function Tab:SetActive(active)
    if self.Active == active then return end
    
    self.Active = active
    
    if active then
        -- Active state styling
        self.DoorLib:CreateTween(self.TabButton, {Duration = 0.3}, {
            BackgroundColor3 = self.Theme.Accent,
            BackgroundTransparency = 0.1
        }):Play()
        
        self.DoorLib:CreateTween(self.TabLabel, {Duration = 0.3}, {
            TextColor3 = Color3.new(1, 1, 1),
            TextSize = 14
        }):Play()
        
        if self.TabIcon then
            self.DoorLib:CreateTween(self.TabIcon, {Duration = 0.3}, {
                ImageColor3 = Color3.new(1, 1, 1)
            }):Play()
            
            self.DoorLib:CreateTween(self.IconContainer, {Duration = 0.3}, {
                BackgroundColor3 = Color3.new(1, 1, 1),
                BackgroundTransparency = 0.1
            }):Play()
        end
        
        -- Active indicator animation
        self.DoorLib:CreateTween(self.ActiveIndicator, {Duration = 0.3}, {
            Size = UDim2.new(0.8, 0, 0, 3),
            BackgroundTransparency = 0
        }):Play()
        
        -- Stroke styling for active state
        if self.TabButton:FindFirstChild("UIStroke") then
            self.DoorLib:CreateTween(self.TabButton.UIStroke, {Duration = 0.3}, {
                Color = self.Theme.Accent,
                Transparency = 0.2
            }):Play()
        end
        
        -- Show content with animation
        self.ContentContainer.Visible = true
        self.ContentContainer.Size = UDim2.new(1, -10, 0, 0)
        self.DoorLib:CreateTween(self.ContentContainer, {Duration = 0.3}, {
            Size = UDim2.new(1, -10, 1, -10)
        }):Play()
        
        -- Clear notifications when activated
        self:ClearNotification()
        
    else
        -- Inactive state styling
        self.DoorLib:CreateTween(self.TabButton, {Duration = 0.3}, {
            BackgroundColor3 = self.Theme.Secondary,
            BackgroundTransparency = 0.4
        }):Play()
        
        self.DoorLib:CreateTween(self.TabLabel, {Duration = 0.3}, {
            TextColor3 = self.Theme.TextSecondary,
            TextSize = 13
        }):Play()
        
        if self.TabIcon then
            self.DoorLib:CreateTween(self.TabIcon, {Duration = 0.3}, {
                ImageColor3 = self.Theme.TextSecondary
            }):Play()
            
            self.DoorLib:CreateTween(self.IconContainer, {Duration = 0.3}, {
                BackgroundColor3 = self.Theme.Accent,
                BackgroundTransparency = 0.8
            }):Play()
        end
        
        -- Hide active indicator
        self.DoorLib:CreateTween(self.ActiveIndicator, {Duration = 0.3}, {
            Size = UDim2.new(0, 0, 0, 3),
            BackgroundTransparency = 1
        }):Play()
        
        -- Reset stroke styling
        if self.TabButton:FindFirstChild("UIStroke") then
            self.DoorLib:CreateTween(self.TabButton.UIStroke, {Duration = 0.3}, {
                Color = Color3.new(1, 1, 1),
                Transparency = 0.85
            }):Play()
        end
        
        -- Hide content with animation
        self.DoorLib:CreateTween(self.ContentContainer, {Duration = 0.3}, {
            Size = UDim2.new(1, -10, 0, 0)
        }):Play()
        
        spawn(function()
            wait(0.3)
            if not self.Active then
                self.ContentContainer.Visible = false
            end
        end)
        
        -- Hide close button
        if self.CloseButton then
            self.CloseButton.Visible = false
        end
    end
end

function Tab:ShowContextMenu()
    -- Context menu implementation for future development
    print("Tab context menu for:", self.Name)
end

function Tab:ShowNotification()
    self.NotificationIndicator.Visible = true
end

function Tab:ClearNotification()
    self.NotificationIndicator.Visible = false
end

function Tab:UpdateTabListCanvas()
    local totalWidth = 0
    for _, child in pairs(self.Window.TabList:GetChildren()) do
        if child:IsA("Frame") and child.Visible then
            totalWidth = totalWidth + child.Size.X.Offset + 5
        end
    end
    self.Window.TabList.CanvasSize = UDim2.new(0, totalWidth, 0, 0)
end

-- Element Creation Methods
function Tab:AddSection(Info)
    local section = self.DoorLib.Section.new(Info, self.Window, false)
    section.SectionFrame.Parent = self.ContentContainer
    table.insert(self.Sections, section)
    table.insert(self.Elements, section)
    return section
end

function Tab:AddButton(Info)
    local button = self.DoorLib.Button.new(Info, self)
    table.insert(self.Elements, button)
    return button
end

function Tab:AddToggle(Info)
    local toggle = self.DoorLib.Toggle.new(Info, self)
    table.insert(self.Elements, toggle)
    return toggle
end

function Tab:AddSlider(Info)
    local slider = self.DoorLib.Slider.new(Info, self)
    table.insert(self.Elements, slider)
    return slider
end

function Tab:GetContentParent()
    return self.ContentContainer
end

function Tab:SetVisible(visible)
    self.Visible = visible
    self.TabButtonContainer.Visible = visible
    
    if not visible and self.Active then
        -- Switch to another tab if this one becomes invisible
        for _, tab in pairs(self.Window.Tabs) do
            if tab ~= self and tab.Visible then
                self.Window:SwitchTab(tab)
                break
            end
        end
    end
    
    self:UpdateTabListCanvas()
end

function Tab:Close()
    -- Remove from window tabs
    for i, tab in ipairs(self.Window.Tabs) do
        if tab == self then
            table.remove(self.Window.Tabs, i)
            break
        end
    end
    
    -- Switch to another tab if this was active
    if self.Active and #self.Window.Tabs > 0 then
        self.Window:SwitchTab(self.Window.Tabs[1])
    end
    
    -- Clean up UI elements
    if self.TabButtonContainer then
        self.TabButtonContainer:Destroy()
    end
    
    if self.ContentContainer then
        self.ContentContainer:Destroy()
    end
    
    self:UpdateTabListCanvas()
end

function Tab:SetText(newText)
    self.Name = newText
    self.TabLabel.Text = newText
    self.TabButtonContainer.Name = newText .. "TabButton"
    self.ContentContainer.Name = newText .. "Content"
end

function Tab:SetIcon(newIcon)
    if self.TabIcon then
        self.TabIcon.Image = newIcon
    end
end

return Tab
