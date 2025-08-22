local TitleBar = {}
TitleBar.__index = TitleBar

function TitleBar:new(Info)
    local self = setmetatable({}, TitleBar)

    local CurrentTheme = Info.Theme or {
        Text = "#FFFFFF", Placeholder = "#999999", Icon = "#a1a1aa"
    }

    local HeaderFrame = Instance.new("Frame")
    HeaderFrame.Name = "Header"
    HeaderFrame.Size = UDim2.new(1, 0, 0, 60)
    HeaderFrame.BackgroundTransparency = 1
    HeaderFrame.Parent = Info.Parent

    local Icon = Instance.new("ImageLabel")
    Icon.Name = "Icon"
    Icon.Size = UDim2.fromOffset(24, 24)
    Icon.Position = UDim2.fromOffset(15, 10)
    Icon.BackgroundTransparency = 1
    Icon.Image = Info.Icon or ""
    Icon.ImageColor3 = Color3.fromHex(CurrentTheme.Icon)
    Icon.Parent = HeaderFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(1, -50, 0, 24)
    TitleLabel.Position = UDim2.fromOffset(45, 8)
    TitleLabel.Text = Info.Title or "Fallback Title"
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextColor3 = Color3.fromHex(CurrentTheme.Text)
    TitleLabel.TextSize = 18
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = HeaderFrame

    local AuthorLabel = Instance.new("TextLabel")
    AuthorLabel.Name = "Author"
    AuthorLabel.Size = UDim2.new(1, -50, 0, 16)
    AuthorLabel.Position = UDim2.fromOffset(45, 32)
    AuthorLabel.Text = Info.Author or ""
    AuthorLabel.Font = Enum.Font.Gotham
    AuthorLabel.TextColor3 = Color3.fromHex(CurrentTheme.Placeholder)
    AuthorLabel.TextSize = 12
    AuthorLabel.TextXAlignment = Enum.TextXAlignment.Left
    AuthorLabel.BackgroundTransparency = 1
    AuthorLabel.Parent = HeaderFrame

    self.Frame = HeaderFrame

    return self
end

return TitleBar
