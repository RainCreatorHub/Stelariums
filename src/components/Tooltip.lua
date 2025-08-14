local Tooltip = {}
Tooltip.__index = Tooltip

local UserInputService = game:GetService("UserInputService")

function Tooltip.new(target, text)
    local self = setmetatable({}, Tooltip)
    
    self.target = target
    self.text = text
    
    self:createTooltip()
    self:connectEvents()
    
    return self
end

function Tooltip:createTooltip()
    self.tooltipFrame = Instance.new("Frame")
    self.tooltipFrame.Name = "Tooltip"
    self.tooltipFrame.Size = UDim2.new(0, 0, 0, 25)
    self.tooltipFrame.AutomaticSize = Enum.AutomaticSize.X
    self.tooltipFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    self.tooltipFrame.BorderSizePixel = 1
    self.tooltipFrame.BorderColor3 = Color3.fromRGB(150, 20, 30)
    self.tooltipFrame.Visible = false
    self.tooltipFrame.ZIndex = 1000
    self.tooltipFrame.Parent = self.target.Parent.Parent.Parent -- Stell_Root ScreenGui

    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    padding.Parent = self.tooltipFrame

    local label = Instance.new("TextLabel")
    label.Name = "TooltipLabel"
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Text = self.text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Parent = self.tooltipFrame
end

function Tooltip:connectEvents()
    self.target.MouseEnter:Connect(function()
        self.tooltipFrame.Visible = true
    end)
    
    self.target.MouseLeave:Connect(function()
        self.tooltipFrame.Visible = false
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            self.tooltipFrame.Position = UDim2.new(0, input.Position.X + 15, 0, input.Position.Y + 15)
        end
    end)
end

return Tooltip
