local Section = {}

function Section.new(info)
    info = info or {}
    local name = info.Name or "Section"

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "Stell_Section_Container"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Enabled = false

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "Section"
    mainFrame.Size = UDim2.new(1, -20, 0, 150)
    mainFrame.Position = UDim2.new(0.5, -mainFrame.Size.X.Offset / 2, 0, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, -10, 0, 20)
    nameLabel.Position = UDim2.new(0.5, -nameLabel.Size.X.Offset / 2, 0, 5)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.Text = name
    nameLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    nameLabel.TextSize = 14
    nameLabel.Parent = mainFrame

    local sectionInstance = {
        GUI = screenGui,
        Frame = mainFrame,
        Container = mainFrame
    }

    return sectionInstance
end

return Section
