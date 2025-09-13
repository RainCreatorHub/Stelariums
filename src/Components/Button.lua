local Button = {}
Button.__index = Button

function Button.new(text)
    local self = setmetatable({}, Button)
    
    -- Create button instance
    self.Instance = Instance.new("TextButton")
    self.Instance.Text = text or "Button"
    self.Instance.Size = UDim2.new(0, 200, 0, 40)
    self.Instance.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    self.Instance.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.Instance.Font = Enum.Font.SourceSansBold
    self.Instance.TextSize = 14
    self.Instance.BorderSizePixel = 0
    
    -- Add hover effect
    self.Instance.MouseEnter:Connect(function()
        self.Instance.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    end)
    
    self.Instance.MouseLeave:Connect(function()
        self.Instance.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    end)
    
    return self
end

function Button:SetCallback(callback)
    self.Instance.MouseButton1Click:Connect(callback)
end

return Button
