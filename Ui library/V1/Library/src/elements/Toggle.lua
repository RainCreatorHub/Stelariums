-- Toggle.lua - Advanced Toggle Element
-- Handles toggle switch creation, state management, and animations

local Toggle = {}
Toggle.__index = Toggle

-- Services
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

function Toggle.new(Info, Section)
    local self = setmetatable({}, Toggle)
    
    self.Info = Info or {}
    self.Section = Section
    self.Window = Section.Window
    self.DoorLib = Section.DoorLib
    self.Theme = Section.Theme
    
    self.Name = self.Info.Name or "Toggle"
    self.Description = self.Info.Description or ""
    self.Default = self.Info.Default or false
    self.Callback = self.Info.Callback or function() end
    self.Value = self.Default
    
    self:CreateToggle()
    
    table.insert(self.Section.Elements, self)
    return self
end

function Toggle:CreateToggle()
    -- Main Toggle Container
    self.Container = Instance.new("Frame")
    self.Container.Name = self.Name
    self.Container.Size = UDim2.new(1, 0, 0, 40)
    self.Container.BackgroundTransparency = 1
    self.Container.Parent = self.Section:GetContentParent()
    
    -- Toggle Background Frame
    self.ToggleFrame = Instance.new("Frame")
    self.ToggleFrame.Name = "ToggleFrame"
    self.ToggleFrame.Size = UDim2.new(1, 0, 1, 0)
    self.ToggleFrame.BackgroundColor3 = self.Theme.Secondary
    self.ToggleFrame.BackgroundTransparency = 0.1
    self.ToggleFrame.BorderSizePixel = 0
    self.ToggleFrame.Parent = self.Container
    
    -- Toggle Styling
    self.DoorLib:CreateCorner(self.ToggleFrame, 8)
    self.DoorLib:CreateStroke(self.ToggleFrame, 1, self.Theme.Border)
    
    -- Toggle Text Label
    self.ToggleLabel = Instance.new("TextLabel")
    self.ToggleLabel.Name = "ToggleLabel"
    self.ToggleLabel.Size = UDim2.new(1, -80, 0, 20)
    self.ToggleLabel.Position = UDim2.new(0, 12, 0, 4)
    self.ToggleLabel.BackgroundTransparency = 1
    self.ToggleLabel.Text = self.Name
    self.ToggleLabel.TextColor3 = self.Theme.Text
    self.ToggleLabel.TextSize = 14
    self.ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.ToggleLabel.Font = Enum.Font.GothamMedium
    self.ToggleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    self.ToggleLabel.Parent = self.ToggleFrame
    
    -- Description (if provided)
    if self.Description ~= "" then
        self.DescriptionLabel = Instance.new("TextLabel")
        self.DescriptionLabel.Name = "Description"
        self.DescriptionLabel.Size = UDim2.new(1, -80, 0, 14)
        self.DescriptionLabel.Position = UDim2.new(0, 12, 0, 22)
        self.DescriptionLabel.BackgroundTransparency = 1
        self.DescriptionLabel.Text = self.Description
        self.DescriptionLabel.TextColor3 = self.Theme.TextSecondary
        self.DescriptionLabel.TextSize = 11
        self.DescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
        self.DescriptionLabel.Font = Enum.Font.Gotham
        self.DescriptionLabel.TextTruncate = Enum.TextTruncate.AtEnd
        self.DescriptionLabel.Parent = self.ToggleFrame
    end
    
    -- Toggle Switch Container
    self.SwitchContainer = Instance.new("Frame")
    self.SwitchContainer.Name = "SwitchContainer"
    self.SwitchContainer.Size = UDim2.new(0, 50, 0, 24)
    self.SwitchContainer.Position = UDim2.new(1, -62, 0.5, -12)
    self.SwitchContainer.BackgroundColor3 = self.Value and self.Theme.Success or self.Theme.Primary
    self.SwitchContainer.BorderSizePixel = 0
    self.SwitchContainer.Parent = self.ToggleFrame
    
    self.DoorLib:CreateCorner(self.SwitchContainer, 12)
    self.DoorLib:CreateStroke(self.SwitchContainer, 1, self.Theme.Border)
    
    -- Toggle Switch Background Gradient
    self.SwitchGradient = self.DoorLib:CreateGradient(self.SwitchContainer, {
        {0, self.Value and self.Theme.Success or self.Theme.Primary},
        {0.5, self.Value and Color3.fromRGB(60, 220, 130) or self.Theme.Secondary},
        {1, self.Value and self.Theme.Success or self.Theme.Primary}
    }, 90)
    
    -- Toggle Switch Knob
    self.SwitchKnob = Instance.new("Frame")
    self.SwitchKnob.Name = "SwitchKnob"
    self.SwitchKnob.Size = UDim2.new(0, 18, 0, 18)
    self.SwitchKnob.Position = self.Value and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    self.SwitchKnob.BackgroundColor3 = Color3.new(1, 1, 1)
    self.SwitchKnob.BorderSizePixel = 0
    self.SwitchKnob.Parent = self.SwitchContainer
    
    self.DoorLib:CreateCorner(self.SwitchKnob, 9)
    self.DoorLib:CreateStroke(self.SwitchKnob, 1, Color3.fromRGB(220, 220, 220))
    
    -- Knob shadow effect
    local knobShadow = Instance.new("Frame")
    knobShadow.Name = "KnobShadow"
    knobShadow.Size = UDim2.new(1, 2, 1, 2)
    knobShadow.Position = UDim2.new(0.5, 1, 0.5, 1)
    knobShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    knobShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    knobShadow.BackgroundTransparency = 0.8
    knobShadow.BorderSizePixel = 0
    knobShadow.ZIndex = -1
    knobShadow.Parent = self.SwitchKnob
    
    self.DoorLib:CreateCorner(knobShadow, 10)
    
    -- Toggle Button (invisible clickable area)
    self.ToggleButton = Instance.new("TextButton")
    self.ToggleButton.Name = "ToggleButton"
    self.ToggleButton.Size = UDim2.new(1, 0, 1, 0)
    self.ToggleButton.BackgroundTransparency = 1
    self.ToggleButton.Text = ""
    self.ToggleButton.Parent = self.ToggleFrame
    
    -- Setup Interactions
    self:SetupInteractions()
    
    -- Initialize state
    self:UpdateToggleState(false)
end

function Toggle:SetupInteractions()
    -- Click to toggle
    self.ToggleButton.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    -- Hover effects
    self.ToggleButton.MouseEnter:Connect(function()
        self:OnHover(true)
    end)
    
    self.ToggleButton.MouseLeave:Connect(function()
        self:OnHover(false)
    end)
    
    -- Click effects
    self.ToggleButton.MouseButton1Down:Connect(function()
        self:OnClick()
    end)
    
    self.ToggleButton.MouseButton1Up:Connect(function()
        self:OnRelease()
    end)
end

function Toggle:OnHover(hovering)
    local targetScale = hovering and 1.05 or 1
    local targetStrokeTransparency = hovering and 0.3 or 0.7
    
    self.DoorLib:CreateTween(self.SwitchContainer, {Duration = 0.2}, {
        Size = UDim2.new(0, 50 * targetScale, 0, 24 * targetScale)
    }):Play()
    
    if self.SwitchContainer:FindFirstChild("UIStroke") then
        self.DoorLib:CreateTween(self.SwitchContainer.UIStroke, {Duration = 0.2}, {
            Transparency = targetStrokeTransparency
        }):Play()
    end
end

function Toggle:OnClick()
    self.DoorLib:CreateTween(self.SwitchKnob, {Duration = 0.1}, {
        Size = UDim2.new(0, 16, 0, 16)
    }):Play()
end

function Toggle:OnRelease()
    self.DoorLib:CreateTween(self.SwitchKnob, {Duration = 0.1}, {
        Size = UDim2.new(0, 18, 0, 18)
    }):Play()
end

function Toggle:Toggle()
    self.Value = not self.Value
    self:UpdateToggleState(true)
    
    -- Execute callback
    spawn(function()
        if self.Callback then
            self.Callback(self.Value)
        end
    end)
end

function Toggle:UpdateToggleState(animate)
    local duration = animate and 0.3 or 0
    local targetPosition = self.Value and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    local targetBackgroundColor = self.Value and self.Theme.Success or self.Theme.Primary
    local targetGradientEnd = self.Value and Color3.fromRGB(60, 220, 130) or self.Theme.Secondary
    
    -- Animate knob position
    self.DoorLib:CreateTween(self.SwitchKnob, {Duration = duration}, {
        Position = targetPosition
    }):Play()
    
    -- Animate background color
    self.DoorLib:CreateTween(self.SwitchContainer, {Duration = duration}, {
        BackgroundColor3 = targetBackgroundColor
    }):Play()
    
    -- Update gradient
    if animate then
        spawn(function()
            wait(duration * 0.5)
            self.SwitchGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, targetBackgroundColor),
                ColorSequenceKeypoint.new(0.5, targetGradientEnd),
                ColorSequenceKeypoint.new(1, targetBackgroundColor)
            })
        end)
    else
        self.SwitchGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, targetBackgroundColor),
            ColorSequenceKeypoint.new(0.5, targetGradientEnd),
            ColorSequenceKeypoint.new(1, targetBackgroundColor)
        })
    end
    
    -- Animate knob glow effect when toggled on
    if self.Value and animate then
        spawn(function()
            for i = 1, 3 do
                self.DoorLib:CreateTween(self.SwitchKnob, {Duration = 0.2}, {
                    Size = UDim2.new(0, 20, 0, 20)
                }):Play()
                wait(0.2)
                self.DoorLib:CreateTween(self.SwitchKnob, {Duration = 0.2}, {
                    Size = UDim2.new(0, 18, 0, 18)
                }):Play()
                wait(0.2)
            end
        end)
    end
end

function Toggle:SetValue(value, animate)
    self.Value = value
    self:UpdateToggleState(animate ~= false)
end

function Toggle:GetValue()
    return self.Value
end

function Toggle:SetText(newText)
    self.Name = newText
    self.ToggleLabel.Text = newText
end

function Toggle:SetDescription(newDescription)
    self.Description = newDescription
    if self.DescriptionLabel then
        self.DescriptionLabel.Text = newDescription
    end
end

function Toggle:SetCallback(newCallback)
    self.Callback = newCallback
end

function Toggle:SetEnabled(enabled)
    self.ToggleButton.Active = enabled
    
    if enabled then
        self.DoorLib:CreateTween(self.ToggleFrame, {Duration = 0.3}, {
            BackgroundTransparency = 0.1
        }):Play()
        self.DoorLib:CreateTween(self.ToggleLabel, {Duration = 0.3}, {
            TextTransparency = 0
        }):Play()
        self.DoorLib:CreateTween(self.SwitchContainer, {Duration = 0.3}, {
            BackgroundTransparency = 0
        }):Play()
    else
        self.DoorLib:CreateTween(self.ToggleFrame, {Duration = 0.3}, {
            BackgroundTransparency = 0.5
        }):Play()
        self.DoorLib:CreateTween(self.ToggleLabel, {Duration = 0.3}, {
            TextTransparency = 0.5
        }):Play()
        self.DoorLib:CreateTween(self.SwitchContainer, {Duration = 0.3}, {
            BackgroundTransparency = 0.5
        }):Play()
    end
end

function Toggle:Remove()
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

return Toggle
