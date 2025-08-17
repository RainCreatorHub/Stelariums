local Button = {}

function Button.new(options)
    options = options or {}
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "Stell_Button_Container"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local frame = Instance.new("Frame")
    frame.Name = "Button_Frame"
    frame.Size = UDim2.new(0, 120, 0, 35)
    frame.Position = UDim2.new(0, 140, 0, 10)
    frame.BackgroundTransparency = 1
    frame.Parent = screenGui

    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.TextColor3 = Color3.fromRGB(225, 225, 225)
    button.Text = options.Text or "Button"
    button.Font = Enum.Font.SourceSans
    button.TextSize = 14
    button.Parent = frame

    if options.Callback then
        button.MouseButton1Click:Connect(options.Callback)
    end

    local buttonInstance = {
        GUI = screenGui,
        Frame = frame,
        Button = button
    }

    return buttonInstance
end

return Button
