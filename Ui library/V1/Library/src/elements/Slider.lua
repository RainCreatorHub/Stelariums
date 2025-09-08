-- Slider.lua - Advanced Slider Element
-- Handles numerical input with draggable slider interface

local Slider = {}
Slider.__index = Slider

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

function Slider.new(Info, Section)
    local self = setmetatable({}, Slider)
    
    self.Info = Info or {}
    self.Section = Section
    self.Window = Section.Window
    self.DoorLib = Section.DoorLib
    self.Theme = Section.Theme
    
    self.Name = self.Info.Name or "Slider"
    self.Description = self.Info.Description or ""
    self.Min = self.Info.Min or 0
    self.Max = self.Info.Max or 100
    self.Default = self.Info.Default or self.Min
    self.Increment = self.Info.Increment or 1
    self.Suffix = self.Info.Suffix or ""
    self.Callback = self.Info.Callback or function() end
    
    self.Value = self.Default
    self.Dragging = false
    
    self:CreateSlider()
    
    table.insert(self.Section.Elements, self)
    return self
end

function Slider:CreateSlider()
    -- Main Slider Container
    self.Container = Instance.new("Frame")
    self.Container.Name = self.Name
    self.Container.Size = UDim2.new(1, 0, 0, 50)
    self.Container.BackgroundTransparency = 1
    self.Container.Parent = self.Section:GetContentParent()
    
    -- Slider Background Frame
    self.SliderFrame = Instance.new("Frame")
    self.SliderFrame.Name = "SliderFrame"
    self.SliderFrame.Size = UDim2.new(1, 0, 1, 0)
    self.SliderFrame.BackgroundColor3 = self.Theme.Secondary
    self.SliderFrame.BackgroundTransparency = 0.1
    self.SliderFrame.BorderSizePixel = 0
    self.SliderFrame.Parent = self.Container
    
    -- Slider Styling
    self.DoorLib:CreateCorner(self.SliderFrame, 8)
    self.DoorLib:CreateStroke(self.SliderFrame, 1, self.Theme.Border)
    
    -- Slider Label
    self.SliderLabel = Instance.new("TextLabel")
    self.SliderLabel.Name = "SliderLabel"
    self.SliderLabel.Size = UDim2.new(0.6, 0, 0, 18)
    self.SliderLabel.Position = UDim2.new(0, 12, 0, 4)
    self.SliderLabel.BackgroundTransparency = 1
    self.SliderLabel.Text = self.Name
    self.SliderLabel.TextColor3 = self.Theme.Text
    self.SliderLabel.TextSize = 14
    self.SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.SliderLabel.Font = Enum.Font.GothamMedium
    self.SliderLabel.TextTruncate = Enum.TextTruncate.AtEnd
    self.SliderLabel.Parent = self.SliderFrame
    
    -- Value Display
    self.ValueLabel = Instance.new("TextLabel")
    self.ValueLabel.Name = "ValueLabel"
    self.ValueLabel.Size = UDim2.new(0.3, -12, 0, 18)
    self.ValueLabel.Position = UDim2.new(0.7, 0, 0, 4)
    self.ValueLabel.BackgroundTransparency = 1
    self.ValueLabel.Text = tostring(self.Value) .. self.Suffix
    self.ValueLabel.TextColor3 = self.Theme.Accent
    self.ValueLabel.TextSize = 13
    self.ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    self.ValueLabel.Font = Enum.Font.GothamBold
    self.ValueLabel.Parent = self.SliderFrame
    
    -- Description (if provided)
    if self.Description ~= "" then
        self.DescriptionLabel = Instance.new("TextLabel")
        self.DescriptionLabel.Name = "Description"
        self.DescriptionLabel.Size = UDim2.new(1, -24, 0, 12)
        self.DescriptionLabel.Position = UDim2.new(0, 12, 0, 22)
        self.DescriptionLabel.BackgroundTransparency = 1
        self.DescriptionLabel.Text = self.Description
        self.DescriptionLabel.TextColor3 = self.Theme.TextSecondary
        self.DescriptionLabel.TextSize = 10
        self.DescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
        self.DescriptionLabel.Font = Enum.Font.Gotham
        self.DescriptionLabel.TextTruncate = Enum.TextTruncate.AtEnd
        self.DescriptionLabel.Parent = self.SliderFrame
    end
    
    -- Slider Track Container
    self.TrackContainer = Instance.new("Frame")
    self.TrackContainer.Name = "TrackContainer"
    self.TrackContainer.Size = UDim2.new(1, -24, 0, 6)
    self.TrackContainer.Position = UDim2.new(0, 12, 1, -14)
    self.TrackContainer.BackgroundTransparency = 1
    self.TrackContainer.Parent = self.SliderFrame
    
    -- Slider Track Background
    self.TrackBackground = Instance.new("Frame")
    self.TrackBackground.Name = "TrackBackground"
    self.TrackBackground.Size = UDim2.new(1, 0, 1, 0)
    self.TrackBackground.BackgroundColor3 = self.Theme.Primary
    self.TrackBackground.BorderSizePixel = 0
    self.TrackBackground.Parent = self.TrackContainer
    
    self.DoorLib:CreateCorner(self.TrackBackground, 3)
    self.DoorLib:CreateStroke(self.TrackBackground, 1, self.Theme.Border)
    
    -- Slider Track Fill
    self.TrackFill = Instance.new("Frame")
    self.TrackFill.Name = "TrackFill"
    self.TrackFill.Size = UDim2.new(0, 0, 1, 0)
    self.TrackFill.BackgroundColor3 = self.Theme.Accent
    self.TrackFill.BorderSizePixel = 0
    self.TrackFill.Parent = self.TrackBackground
    
    self.DoorLib:CreateCorner(self.TrackFill, 3)
    
    -- Track Fill Gradient
    self.FillGradient = self.DoorLib:CreateGradient(self.TrackFill, {
        {0, self.Theme.Accent},
        {0.5, Color3.fromRGB(100, 200, 255)},
        {1, self.Theme.Accent}
    }, 0)
    
    -- Slider Handle
    self.Handle = Instance.new("Frame")
    self.Handle.Name = "Handle"
    self.Handle.Size = UDim2.new(0, 16, 0, 16)
    self.Handle.Position = UDim2.new(0, -8, 0.5, -8)
    self.Handle.BackgroundColor3 = Color3.new(1, 1, 1)
    self.Handle.BorderSizePixel = 0
    self.Handle.Parent = self.TrackContainer
    
    self.DoorLib:CreateCorner(self.Handle, 8)
    self.DoorLib:CreateStroke(self.Handle, 2, self.Theme.Accent)
    
    -- Handle shadow
    local handleShadow = Instance.new("Frame")
    handleShadow.Name = "HandleShadow"
    handleShadow.Size = UDim2.new(1, 4, 1, 4)
    handleShadow.Position = UDim2.new(0.5, 2, 0.5, 2)
    handleShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    handleShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    handleShadow.BackgroundTransparency = 0.7
    handleShadow.BorderSizePixel = 0
    handleShadow.ZIndex = -1
    handleShadow.Parent = self.Handle
    
    self.DoorLib:CreateCorner(handleShadow, 10)
    
    -- Invisible input detector
    self.InputDetector = Instance.new("TextButton")
    self.InputDetector.Name = "InputDetector"
    self.InputDetector.Size = UDim2.new(1, 0, 1, 0)
    self.InputDetector.BackgroundTransparency = 1
    self.InputDetector.Text = ""
    self.InputDetector.Parent = self.TrackContainer
    
    -- Setup interactions
    self:SetupInteractions()
    
    -- Initialize slider position
    self:UpdateSlider(false)
end

function Slider:SetupInteractions()
    -- Mouse interaction for dragging
    self.InputDetector.MouseButton1Down:Connect(function()
        self:StartDragging()
    end)
    
    -- Handle hover effects
    self.InputDetector.MouseEnter:Connect(function()
        self:OnHover(true)
    end)
    
    self.InputDetector.MouseLeave:Connect(function()
        if not self.Dragging then
            self:OnHover(false)
        end
    end)
    
    -- Global mouse release detection
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and self.Dragging then
            self:StopDragging()
        end
    end)
    
    -- Mouse movement for dragging
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and self.Dragging then
            self:UpdateDragging(input.Position)
        end
    end)
end

function Slider:OnHover(hovering)
    local targetSize = hovering and UDim2.new(0, 20, 0, 20) or UDim2.new(0, 16, 0, 16)
    local targetPosition = hovering and UDim2.new(0, -10, 0.5, -10) or UDim2.new(0, -8, 0.5, -8)
    
    self.DoorLib:CreateTween(self.Handle, {Duration = 0.2}, {
        Size = targetSize,
        Position = targetPosition
    }):Play()
end

function Slider:StartDragging()
    self.Dragging = true
    
    -- Visual feedback for dragging state
    self.DoorLib:CreateTween(self.Handle, {Duration = 0.1}, {
        Size = UDim2.new(0, 22, 0, 22),
        Position = UDim2.new(0, -11, 0.5, -11)
    }):Play()
    
    self.DoorLib:CreateTween(self.TrackFill, {Duration = 0.2}, {
        Size = self.TrackFill.Size + UDim2.new(0, 0, 0, 2)
    }):Play()
end

function Slider:StopDragging()
    if not self.Dragging then return end
    
    self.Dragging = false
    
    -- Return to normal size
    self.DoorLib:CreateTween(self.Handle, {Duration = 0.2}, {
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, -8, 0.5, -8)
    }):Play()
end

function Slider:UpdateDragging(mousePosition)
    local trackFrame = self.TrackContainer.AbsolutePosition
    local trackSize = self.TrackContainer.AbsoluteSize
    
    local relativeX = mousePosition.X - trackFrame.X
    local percentage = math.clamp(relativeX / trackSize.X, 0, 1)
    
    local rawValue = self.Min + (self.Max - self.Min) * percentage
    local newValue = math.floor((rawValue - self.Min) / self.Increment + 0.5) * self.Increment + self.Min
    newValue = math.clamp(newValue, self.Min, self.Max)
    
    if newValue ~= self.Value then
        self.Value = newValue
        self:UpdateSlider(true)
        
        -- Execute callback
        spawn(function()
            if self.Callback then
                self.Callback(self.Value)
            end
        end)
    end
end

function Slider:UpdateSlider(animate)
    local percentage = (self.Value - self.Min) / (self.Max - self.Min)
    local duration = animate and 0.2 or 0
    
    -- Update fill bar
    self.DoorLib:CreateTween(self.TrackFill, {Duration = duration}, {
        Size = UDim2.new(percentage, 0, 1, 0)
    }):Play()
    
    -- Update handle position
    local handlePos = percentage * self.TrackContainer.AbsoluteSize.X - 8
    self.DoorLib:CreateTween(self.Handle, {Duration = duration}, {
        Position = UDim2.new(0, handlePos, 0.5, -8)
    }):Play()
    
    -- Update value display
    self.ValueLabel.Text = tostring(self.Value) .. self.Suffix
    
    -- Value change animation
    if animate then
        self.DoorLib:CreateTween(self.ValueLabel, {Duration = 0.1}, {
            TextSize = 15
        }):Play()
        
        wait(0.1)
        
        self.DoorLib:CreateTween(self.ValueLabel, {Duration = 0.1}, {
            TextSize = 13
        }):Play()
    end
end

function Slider:SetValue(value, animate)
    value = math.clamp(value, self.Min, self.Max)
    value = math.floor((value - self.Min) / self.Increment + 0.5) * self.Increment + self.Min
    
    self.Value = value
    self:UpdateSlider(animate ~= false)
end

function Slider:GetValue()
    return self.Value
end

function Slider:SetText(newText)
    self.Name = newText
    self.SliderLabel.Text = newText
end

function Slider:SetDescription(newDescription)
    self.Description = newDescription
    if self.DescriptionLabel then
        self.DescriptionLabel.Text = newDescription
    end
end

function Slider:SetCallback(newCallback)
    self.Callback = newCallback
end

function Slider:SetMin(newMin)
    self.Min = newMin
    self.Value = math.max(self.Value, self.Min)
    self:UpdateSlider(true)
end

function Slider:SetMax(newMax)
    self.Max = newMax
    self.Value = math.min(self.Value, self.Max)
    self:UpdateSlider(true)
end

function Slider:SetEnabled(enabled)
    self.InputDetector.Active = enabled
    
    if enabled then
        self.DoorLib:CreateTween(self.SliderFrame, {Duration = 0.3}, {
            BackgroundTransparency = 0.1
        }):Play()
        self.DoorLib:CreateTween(self.SliderLabel, {Duration = 0.3}, {
            TextTransparency = 0
        }):Play()
        self.DoorLib:CreateTween(self.Handle, {Duration = 0.3}, {
            BackgroundTransparency = 0
        }):Play()
    else
        self.DoorLib:CreateTween(self.SliderFrame, {Duration = 0.3}, {
            BackgroundTransparency = 0.5
        }):Play()
        self.DoorLib:CreateTween(self.SliderLabel, {Duration = 0.3}, {
            TextTransparency = 0.5
        }):Play()
        self.DoorLib:CreateTween(self.Handle, {Duration = 0.3}, {
            BackgroundTransparency = 0.5
        }):Play()
    end
end

function Slider:Remove()
    if self.Container then
        self.Container:Destroy()
    end
    
    -- Remove from section elements
    for i, element in ipairs(self.Section.Elements) do
        if element == self then
            table.remove(self.Section.Elements, i)
            break
        end
    end
end

return Slider
