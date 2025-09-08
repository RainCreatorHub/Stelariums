-- Button.lua - Advanced Button Element
-- Handles button creation, animations, and callback functionality

local Button = {}
Button.__index = Button

-- Services
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

function Button.new(Info, Section)
    local self = setmetatable({}, Button)
    
    self.Info = Info or {}
    self.Section = Section
    self.Window = Section.Window
    self.DoorLib = Section.DoorLib
    self.Theme = Section.Theme
    
    self.Name = self.Info.Name or "Button"
    self.Description = self.Info.Description or ""
    self.Callback = self.Info.Callback or function() end
    self.Icon = self.Info.Icon or ""
    
    self:CreateButton()
    
    table.insert(self.Section.Elements, self)
    return self
end

function Button:CreateButton()
    -- Main Button Container
    self.Container = Instance.new("Frame")
    self.Container.Name = self.Name
    self.Container.Size = UDim2.new(1, 0, 0, 40)
    self.Container.BackgroundTransparency = 1
    self.Container.Parent = self.Section:GetContentParent()
    
    -- Button Frame
    self.ButtonFrame = Instance.new("TextButton")
    self.ButtonFrame.Name = "ButtonFrame"
    self.ButtonFrame.Size = UDim2.new(1, 0, 1, 0)
    self.ButtonFrame.BackgroundColor3 = self.Theme.Secondary
    self.ButtonFrame.BorderSizePixel = 0
    self.ButtonFrame.Text = ""
    self.ButtonFrame.AutoButtonColor = false
    self.ButtonFrame.Parent = self.Container
    
    -- Button Styling
    self.DoorLib:CreateCorner(self.ButtonFrame, 8)
    self.DoorLib:CreateStroke(self.ButtonFrame, 1, self.Theme.Border)
    
    -- Button Gradient
    self.ButtonGradient = self.DoorLib:CreateGradient(self.ButtonFrame, {
        {0, self.Theme.Secondary},
        {0.5, self.Theme.Primary},
        {1, self.Theme.Secondary}
    }, 90)
    
    -- Icon (if provided)
    if self.Icon and self.Icon ~= "" then
        self.IconLabel = Instance.new("ImageLabel")
        self.IconLabel.Name = "Icon"
        self.IconLabel.Size = UDim2.new(0, 20, 0, 20)
        self.IconLabel.Position = UDim2.new(0, 12, 0.5, -10)
        self.IconLabel.BackgroundTransparency = 1
        self.IconLabel.Image = self.Icon
        self.IconLabel.ImageColor3 = self.Theme.Accent
        self.IconLabel.Parent = self.ButtonFrame
    end
    
    -- Button Text
    self.ButtonText = Instance.new("TextLabel")
    self.ButtonText.Name = "ButtonText"
    self.ButtonText.Size = UDim2.new(1, self.Icon ~= "" and -40 or -24, 0, 20)
    self.ButtonText.Position = UDim2.new(0, self.Icon ~= "" and 40 or 12, 0, 4)
    self.ButtonText.BackgroundTransparency = 1
    self.ButtonText.Text = self.Name
    self.ButtonText.TextColor3 = self.Theme.Text
    self.ButtonText.TextSize = 14
    self.ButtonText.TextXAlignment = Enum.TextXAlignment.Left
    self.ButtonText.Font = Enum.Font.GothamMedium
    self.ButtonText.TextTruncate = Enum.TextTruncate.AtEnd
    self.ButtonText.Parent = self.ButtonFrame
    
    -- Description (if provided)
    if self.Description ~= "" then
        self.DescriptionText = Instance.new("TextLabel")
        self.DescriptionText.Name = "Description"
        self.DescriptionText.Size = UDim2.new(1, self.Icon ~= "" and -40 or -24, 0, 14)
        self.DescriptionText.Position = UDim2.new(0, self.Icon ~= "" and 40 or 12, 0, 22)
        self.DescriptionText.BackgroundTransparency = 1
        self.DescriptionText.Text = self.Description
        self.DescriptionText.TextColor3 = self.Theme.TextSecondary
        self.DescriptionText.TextSize = 11
        self.DescriptionText.TextXAlignment = Enum.TextXAlignment.Left
        self.DescriptionText.Font = Enum.Font.Gotham
        self.DescriptionText.TextTruncate = Enum.TextTruncate.AtEnd
        self.DescriptionText.Parent = self.ButtonFrame
    end
    
    -- Click Effect Frame
    self.ClickEffect = Instance.new("Frame")
    self.ClickEffect.Name = "ClickEffect"
    self.ClickEffect.Size = UDim2.new(0, 0, 0, 0)
    self.ClickEffect.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.ClickEffect.AnchorPoint = Vector2.new(0.5, 0.5)
    self.ClickEffect.BackgroundColor3 = self.Theme.Accent
    self.ClickEffect.BackgroundTransparency = 0.8
    self.ClickEffect.BorderSizePixel = 0
    self.ClickEffect.ZIndex = 2
    self.ClickEffect.Parent = self.ButtonFrame
    
    self.DoorLib:CreateCorner(self.ClickEffect, 50)
    
    -- Ripple Effect
    self.RippleEffect = Instance.new("Frame")
    self.RippleEffect.Name = "RippleEffect"
    self.RippleEffect.Size = UDim2.new(0, 0, 0, 0)
    self.RippleEffect.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.RippleEffect.AnchorPoint = Vector2.new(0.5, 0.5)
    self.RippleEffect.BackgroundColor3 = self.Theme.Accent
    self.RippleEffect.BackgroundTransparency = 1
    self.RippleEffect.BorderSizePixel = 0
    self.RippleEffect.ZIndex = 1
    self.RippleEffect.Parent = self.ButtonFrame
    
    self.DoorLib:CreateCorner(self.RippleEffect, 8)
    
    -- Setup Interactions
    self:SetupInteractions()
end

function Button:SetupInteractions()
    -- Hover Effects
    self.ButtonFrame.MouseEnter:Connect(function()
        self:OnHover(true)
    end)
    
    self.ButtonFrame.MouseLeave:Connect(function()
        self:OnHover(false)
    end)
    
    -- Click Effects
    self.ButtonFrame.MouseButton1Down:Connect(function()
        self:OnClick()
    end)
    
    self.ButtonFrame.MouseButton1Up:Connect(function()
        self:OnRelease()
    end)
    
    self.ButtonFrame.MouseButton1Click:Connect(function()
        self:OnButtonClick()
    end)
end

function Button:OnHover(hovering)
    local targetColor = hovering and self.Theme.Accent or self.Theme.Secondary
    local targetStrokeColor = hovering and self.Theme.Accent or self.Theme.Border
    local targetTextColor = hovering and Color3.new(1, 1, 1) or self.Theme.Text
    local targetIconColor = hovering and Color3.new(1, 1, 1) or self.Theme.Accent
    
    -- Button background color transition
    self.DoorLib:CreateTween(self.ButtonFrame, {Duration = 0.25}, {
        BackgroundColor3 = targetColor
    }):Play()
    
    -- Stroke color transition
    if self.ButtonFrame:FindFirstChild("UIStroke") then
        self.DoorLib:CreateTween(self.ButtonFrame.UIStroke, {Duration = 0.25}, {
            Color = targetStrokeColor
        }):Play()
    end
    
    -- Text color transition
    self.DoorLib:CreateTween(self.ButtonText, {Duration = 0.25}, {
        TextColor3 = targetTextColor
    }):Play()
    
    -- Icon color transition
    if self.IconLabel then
        self.DoorLib:CreateTween(self.IconLabel, {Duration = 0.25}, {
            ImageColor3 = targetIconColor
        }):Play()
    end
    
    -- Gradient animation
    if hovering then
        self.ButtonGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, self.Theme.Accent),
            ColorSequenceKeypoint.new(0.5, self.Theme.Secondary),
            ColorSequenceKeypoint.new(1, self.Theme.Accent)
        })
    else
        self.ButtonGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, self.Theme.Secondary),
            ColorSequenceKeypoint.new(0.5, self.Theme.Primary),
            ColorSequenceKeypoint.new(1, self.Theme.Secondary)
        })
    end
end

function Button:OnClick()
    -- Shrink animation
    self.DoorLib:CreateTween(self.ButtonFrame, {Duration = 0.1}, {
        Size = UDim2.new(1, -2, 1, -2)
    }):Play()
    
    -- Click effect animation
    self.ClickEffect.Size = UDim2.new(0, 0, 0, 0)
    self.ClickEffect.BackgroundTransparency = 0.3
    
    self.DoorLib:CreateTween(self.ClickEffect, {Duration = 0.3}, {
        Size = UDim2.new(0, 100, 0, 100),
        BackgroundTransparency = 1
    }):Play()
end

function Button:OnRelease()
    -- Return to normal size
    self.DoorLib:CreateTween(self.ButtonFrame, {Duration = 0.1}, {
        Size = UDim2.new(1, 0, 1, 0)
    }):Play()
end

function Button:OnButtonClick()
    -- Ripple effect
    self.RippleEffect.Size = UDim2.new(0, 0, 0, 0)
    self.RippleEffect.BackgroundTransparency = 0.5
    
    local rippleTween = self.DoorLib:CreateTween(self.RippleEffect, {Duration = 0.6}, {
        Size = UDim2.new(2, 0, 2, 0),
        BackgroundTransparency = 1
    })
    rippleTween:Play()
    
    -- Execute callback
    spawn(function()
        if self.Callback then
            self.Callback()
        end
    end)
    
    -- Visual feedback for successful execution
    self:ShowSuccessFeedback()
end

function Button:ShowSuccessFeedback()
    -- Brief color flash to indicate successful action
    local originalColor = self.ButtonFrame.BackgroundColor3
    
    self.DoorLib:CreateTween(self.ButtonFrame, {Duration = 0.1}, {
        BackgroundColor3 = self.Theme.Success
    }):Play()
    
    wait(0.1)
    
    self.DoorLib:CreateTween(self.ButtonFrame, {Duration = 0.2}, {
        BackgroundColor3 = originalColor
    }):Play()
end

function Button:SetText(newText)
    self.Name = newText
    self.ButtonText.Text = newText
end

function Button:SetDescription(newDescription)
    self.Description = newDescription
    if self.DescriptionText then
        self.DescriptionText.Text = newDescription
    end
end

function Button:SetCallback(newCallback)
    self.Callback = newCallback
end

function Button:SetIcon(newIcon)
    if self.IconLabel then
        self.IconLabel.Image = newIcon
    end
end

function Button:SetEnabled(enabled)
    self.ButtonFrame.Active = enabled
    
    if enabled then
        self.DoorLib:CreateTween(self.ButtonFrame, {Duration = 0.3}, {
            BackgroundTransparency = 0
        }):Play()
        self.DoorLib:CreateTween(self.ButtonText, {Duration = 0.3}, {
            TextTransparency = 0
        }):Play()
        if self.IconLabel then
            self.DoorLib:CreateTween(self.IconLabel, {Duration = 0.3}, {
                ImageTransparency = 0
            }):Play()
        end
    else
        self.DoorLib:CreateTween(self.ButtonFrame, {Duration = 0.3}, {
            BackgroundTransparency = 0.5
        }):Play()
        self.DoorLib:CreateTween(self.ButtonText, {Duration = 0.3}, {
            TextTransparency = 0.5
        }):Play()
        if self.IconLabel then
            self.DoorLib:CreateTween(self.IconLabel, {Duration = 0.3}, {
                ImageTransparency = 0.5
            }):Play()
        end
    end
end

function Button:Remove()
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

return Button
