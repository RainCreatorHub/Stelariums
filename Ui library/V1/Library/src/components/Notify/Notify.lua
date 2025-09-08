-- Notify.lua - Advanced Notification System Component
-- Handles notification creation, display management, and user interaction

local Notify = {}
Notify.__index = Notify

-- Services
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Static notification management
Notify.ActiveNotifications = {}
Notify.NotificationQueue = {}
Notify.MaxConcurrentNotifications = 5
Notify.NotificationSpacing = 90

function Notify.new(Info, Window)
    local self = setmetatable({}, Notify)
    
    self.Info = Info or {}
    self.Window = Window
    self.DoorLib = Window.DoorLib
    self.Theme = Window.Theme
    
    -- Notification Properties
    self.Title = self.Info.Title or "Notification"
    self.Content = self.Info.Content or "Notification content"
    self.Icon = self.Info.Icon or ""
    self.Time = self.Info.Time or 6
    self.Options = self.Info.Options or {}
    
    -- State Management
    self.Active = false
    self.Destroyed = false
    self.OptionButtons = {}
    
    self:CreateNotification()
    
    return self
end

function Notify:CreateNotification()
    -- Check notification limits
    if #Notify.ActiveNotifications >= Notify.MaxConcurrentNotifications then
        table.insert(Notify.NotificationQueue, self)
        return
    end
    
    -- Add to active notifications
    table.insert(Notify.ActiveNotifications, self)
    
    -- Create notification GUI container
    self.NotificationGui = Instance.new("ScreenGui")
    self.NotificationGui.Name = "DoorLibNotification_" .. tostring(os.time())
    self.NotificationGui.ResetOnSpawn = false
    self.NotificationGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.NotificationGui.DisplayOrder = 200
    self.NotificationGui.Parent = PlayerGui
    
    -- Calculate notification height based on content
    local baseHeight = 80
    local optionHeight = #self.Options > 0 and (math.min(#self.Options, 3) * 35 + 15) or 0
    local totalHeight = baseHeight + optionHeight
    
    -- Main notification container
    self.Container = Instance.new("Frame")
    self.Container.Name = "NotificationContainer"
    self.Container.Size = UDim2.new(0, 350, 0, totalHeight)
    self.Container.Position = self:CalculateNotificationPosition()
    self.Container.BackgroundColor3 = self.Theme.Secondary
    self.Container.BorderSizePixel = 0
    self.Container.Parent = self.NotificationGui
    
    -- Apply styling
    self.DoorLib:CreateCorner(self.Container, 10)
    self.DoorLib:CreateStroke(self.Container, 1, self.Theme.Border)
    self.DoorLib:CreateShadow(self.Container, 0.4, 15)
    
    -- Background gradient
    self.BackgroundGradient = self.DoorLib:CreateGradient(self.Container, {
        {0, self.Theme.Secondary},
        {0.5, self.Theme.Primary},
        {1, self.Theme.Secondary}
    }, 45)
    
    self:CreateNotificationContent()
    self:CreateNotificationOptions()
    self:AnimateNotificationIn()
    self:StartNotificationTimer()
    
    self.Active = true
end

function Notify:CreateNotificationContent()
    -- Header section
    self.HeaderFrame = Instance.new("Frame")
    self.HeaderFrame.Name = "Header"
    self.HeaderFrame.Size = UDim2.new(1, 0, 0, 50)
    self.HeaderFrame.BackgroundTransparency = 1
    self.HeaderFrame.Parent = self.Container
    
    -- Icon container
    if self.Icon ~= "" then
        self.IconContainer = Instance.new("Frame")
        self.IconContainer.Name = "IconContainer"
        self.IconContainer.Size = UDim2.new(0, 40, 0, 40)
        self.IconContainer.Position = UDim2.new(0, 10, 0.5, -20)
        self.IconContainer.BackgroundColor3 = self.Theme.Accent
        self.IconContainer.BackgroundTransparency = 0.2
        self.IconContainer.BorderSizePixel = 0
        self.IconContainer.Parent = self.HeaderFrame
        
        self.DoorLib:CreateCorner(self.IconContainer, 8)
        
        -- Icon image
        self.IconImage = Instance.new("ImageLabel")
        self.IconImage.Name = "Icon"
        self.IconImage.Size = UDim2.new(0, 24, 0, 24)
        self.IconImage.Position = UDim2.new(0.5, -12, 0.5, -12)
        self.IconImage.BackgroundTransparency = 1
        self.IconImage.Image = self.Icon
        self.IconImage.ImageColor3 = self.Theme.Text
        self.IconImage.Parent = self.IconContainer
    end
    
    -- Text content container
    local textStartX = self.Icon ~= "" and 60 or 15
    self.TextContainer = Instance.new("Frame")
    self.TextContainer.Name = "TextContainer"
    self.TextContainer.Size = UDim2.new(1, -textStartX - 40, 1, 0)
    self.TextContainer.Position = UDim2.new(0, textStartX, 0, 0)
    self.TextContainer.BackgroundTransparency = 1
    self.TextContainer.Parent = self.HeaderFrame
    
    -- Title label
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Name = "Title"
    self.TitleLabel.Size = UDim2.new(1, 0, 0.6, 0)
    self.TitleLabel.Position = UDim2.new(0, 0, 0, 5)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = self.Title
    self.TitleLabel.TextColor3 = self.Theme.Text
    self.TitleLabel.TextSize = 15
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.TextYAlignment = Enum.TextYAlignment.Bottom
    self.TitleLabel.Font = Enum.Font.GothamBold
    self.TitleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    self.TitleLabel.Parent = self.TextContainer
    
    -- Content label
    self.ContentLabel = Instance.new("TextLabel")
    self.ContentLabel.Name = "Content"
    self.ContentLabel.Size = UDim2.new(1, 0, 0.4, 0)
    self.ContentLabel.Position = UDim2.new(0, 0, 0.6, -2)
    self.ContentLabel.BackgroundTransparency = 1
    self.ContentLabel.Text = self.Content
    self.ContentLabel.TextColor3 = self.Theme.TextSecondary
    self.ContentLabel.TextSize = 12
    self.ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.ContentLabel.TextYAlignment = Enum.TextYAlignment.Top
    self.ContentLabel.Font = Enum.Font.Gotham
    self.ContentLabel.TextTruncate = Enum.TextTruncate.AtEnd
    self.ContentLabel.TextWrapped = true
    self.ContentLabel.Parent = self.TextContainer
    
    -- Close button
    self.CloseButton = Instance.new("TextButton")
    self.CloseButton.Name = "CloseButton"
    self.CloseButton.Size = UDim2.new(0, 25, 0, 25)
    self.CloseButton.Position = UDim2.new(1, -30, 0, 5)
    self.CloseButton.BackgroundColor3 = self.Theme.Error
    self.CloseButton.BackgroundTransparency = 0.8
    self.CloseButton.BorderSizePixel = 0
    self.CloseButton.Text = "×"
    self.CloseButton.TextColor3 = self.Theme.Text
    self.CloseButton.TextSize = 14
    self.CloseButton.Font = Enum.Font.GothamBold
    self.CloseButton.Parent = self.HeaderFrame
    
    self.DoorLib:CreateCorner(self.CloseButton, 6)
    
    -- Close button interactions
    self.CloseButton.MouseEnter:Connect(function()
        self.DoorLib:CreateTween(self.CloseButton, {Duration = 0.2}, {
            BackgroundTransparency = 0.3
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
    
    -- Progress bar for timer
    if self.Time > 0 then
        self.ProgressBar = Instance.new("Frame")
        self.ProgressBar.Name = "ProgressBar"
        self.ProgressBar.Size = UDim2.new(1, 0, 0, 3)
        self.ProgressBar.Position = UDim2.new(0, 0, 1, -3)
        self.ProgressBar.BackgroundColor3 = self.Theme.Accent
        self.ProgressBar.BorderSizePixel = 0
        self.ProgressBar.Parent = self.Container
        
        self.DoorLib:CreateCorner(self.ProgressBar, 2)
    end
end

function Notify:CreateNotificationOptions()
    if #self.Options == 0 then return end
    
    -- Options container
    self.OptionsContainer = Instance.new("Frame")
    self.OptionsContainer.Name = "Options"
    self.OptionsContainer.Size = UDim2.new(1, -20, 0, math.min(#self.Options, 3) * 35)
    self.OptionsContainer.Position = UDim2.new(0, 10, 0, 60)
    self.OptionsContainer.BackgroundTransparency = 1
    self.OptionsContainer.Parent = self.Container
    
    -- Options layout
    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    optionsLayout.Padding = UDim.new(0, 5)
    optionsLayout.Parent = self.OptionsContainer
    
    -- Create option buttons
    local optionIndex = 1
    for optionName, optionInfo in pairs(self.Options) do
        if optionIndex > 3 then break end -- Limit to 3 options
        
        local optionButton = self:CreateOptionButton(optionName, optionInfo, optionIndex)
        optionButton.Parent = self.OptionsContainer
        
        self.OptionButtons[optionName] = optionButton
        optionIndex = optionIndex + 1
    end
end

function Notify:CreateOptionButton(optionName, optionInfo, layoutOrder)
    local optionFrame = Instance.new("TextButton")
    optionFrame.Name = optionName
    optionFrame.Size = UDim2.new(1, 0, 0, 30)
    optionFrame.BackgroundColor3 = self.Theme.Primary
    optionFrame.BackgroundTransparency = 0.2
    optionFrame.BorderSizePixel = 0
    optionFrame.Text = ""
    optionFrame.LayoutOrder = layoutOrder
    optionFrame.AutoButtonColor = false
    
    self.DoorLib:CreateCorner(optionFrame, 6)
    self.DoorLib:CreateStroke(optionFrame, 1, self.Theme.Border)
    
    -- Option title
    local optionTitle = Instance.new("TextLabel")
    optionTitle.Name = "Title"
    optionTitle.Size = UDim2.new(1, -20, 0.6, 0)
    optionTitle.Position = UDim2.new(0, 10, 0, 2)
    optionTitle.BackgroundTransparency = 1
    optionTitle.Text = optionInfo.Title or optionName
    optionTitle.TextColor3 = self.Theme.Text
    optionTitle.TextSize = 13
    optionTitle.TextXAlignment = Enum.TextXAlignment.Left
    optionTitle.TextYAlignment = Enum.TextYAlignment.Bottom
    optionTitle.Font = Enum.Font.GothamMedium
    optionTitle.TextTruncate = Enum.TextTruncate.AtEnd
    optionTitle.Parent = optionFrame
    
    -- Option description
    if optionInfo.Desc and optionInfo.Desc ~= "" then
        local optionDesc = Instance.new("TextLabel")
        optionDesc.Name = "Description"
        optionDesc.Size = UDim2.new(1, -20, 0.4, 0)
        optionDesc.Position = UDim2.new(0, 10, 0.6, -2)
        optionDesc.BackgroundTransparency = 1
        optionDesc.Text = optionInfo.Desc
        optionDesc.TextColor3 = self.Theme.TextSecondary
        optionDesc.TextSize = 10
        optionDesc.TextXAlignment = Enum.TextXAlignment.Left
        optionDesc.TextYAlignment = Enum.TextYAlignment.Top
        optionDesc.Font = Enum.Font.Gotham
        optionDesc.TextTruncate = Enum.TextTruncate.AtEnd
        optionDesc.Parent = optionFrame
    end
    
    -- Option interactions
    optionFrame.MouseEnter:Connect(function()
        self.DoorLib:CreateTween(optionFrame, {Duration = 0.2}, {
            BackgroundColor3 = self.Theme.Accent,
            BackgroundTransparency = 0.1
        }):Play()
    end)
    
    optionFrame.MouseLeave:Connect(function()
        self.DoorLib:CreateTween(optionFrame, {Duration = 0.2}, {
            BackgroundColor3 = self.Theme.Primary,
            BackgroundTransparency = 0.2
        }):Play()
    end)
    
    optionFrame.MouseButton1Click:Connect(function()
        -- Execute callback
        if optionInfo.Callback then
            spawn(function()
                optionInfo.Callback()
            end)
        end
        
        -- Close notification after option selection
        self:Close()
    end)
    
    return optionFrame
end

function Notify:CalculateNotificationPosition()
    local screenSize = workspace.CurrentCamera.ViewportSize
    local notificationIndex = #Notify.ActiveNotifications
    local yOffset = screenSize.Y - 100 - (notificationIndex * Notify.NotificationSpacing)
    
    return UDim2.new(1, 370, 0, yOffset)
end

function Notify:AnimateNotificationIn()
    local targetPosition = UDim2.new(1, -360, self.Container.Position.Y.Scale, self.Container.Position.Y.Offset)
    
    self.DoorLib:CreateTween(self.Container, self.DoorLib.AnimationPresets.Smooth, {
        Position = targetPosition
    }):Play()
end

function Notify:AnimateNotificationOut()
    local targetPosition = UDim2.new(1, 370, self.Container.Position.Y.Scale, self.Container.Position.Y.Offset)
    
    local outTween = self.DoorLib:CreateTween(self.Container, self.DoorLib.AnimationPresets.Standard, {
        Position = targetPosition
    })
    outTween:Play()
    
    outTween.Completed:Connect(function()
        self:Destroy()
    end)
end

function Notify:StartNotificationTimer()
    if self.Time <= 0 then return end
    
    if self.ProgressBar then
        self.DoorLib:CreateTween(self.ProgressBar, {Duration = self.Time}, {
            Size = UDim2.new(0, 0, 0, 3)
        }):Play()
    end
    
    spawn(function()
        wait(self.Time)
        if not self.Destroyed then
            self:Close()
        end
    end)
end

function Notify:Close()
    if self.Destroyed then return end
    
    self:AnimateNotificationOut()
end

function Notify:Destroy()
    if self.Destroyed then return end
    
    self.Destroyed = true
    self.Active = false
    
    -- Remove from active notifications
    for i, notification in ipairs(Notify.ActiveNotifications) do
        if notification == self then
            table.remove(Notify.ActiveNotifications, i)
            break
        end
    end
    
    -- Clean up GUI
    if self.NotificationGui then
        self.NotificationGui:Destroy()
    end
    
    -- Process queued notifications
    if #Notify.NotificationQueue > 0 then
        local queuedNotification = table.remove(Notify.NotificationQueue, 1)
        queuedNotification:CreateNotification()
    end
    
    -- Reposition remaining notifications
    self:RepositionNotifications()
end

function Notify:RepositionNotifications()
    for i, notification in ipairs(Notify.ActiveNotifications) do
        if notification.Container then
            local screenSize = workspace.CurrentCamera.ViewportSize
            local newYOffset = screenSize.Y - 100 - ((i-1) * Notify.NotificationSpacing)
            local newPosition = UDim2.new(1, -360, 0, newYOffset)
            
            self.DoorLib:CreateTween(notification.Container, self.DoorLib.AnimationPresets.Standard, {
                Position = newPosition
            }):Play()
        end
    end
end

-- Notification management methods
function Notify:SetTitle(newTitle)
    self.Title = newTitle
    if self.TitleLabel then
        self.TitleLabel.Text = newTitle
    end
end

function Notify:SetContent(newContent)
    self.Content = newContent
    if self.ContentLabel then
        self.ContentLabel.Text = newContent
    end
end

function Notify:SetIcon(newIcon)
    self.Icon = newIcon
    if self.IconImage then
        self.IconImage.Image = newIcon
    end
end

return Notify
