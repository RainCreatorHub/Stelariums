local Window = {}
Window.__index = Window

function Window:new(Info)
    local self = setmetatable({}, Window)

    local CurrentTheme = Info.Theme or {
        Background = "#101010", SideBar = "#18181b", Outline = "#FFFFFF"
    }

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Stell"
    ScreenGui.Parent = gethui and gethui() or game:GetService("CoreGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = Info.Size or UDim2.fromOffset(580, 460)
    MainFrame.Position = UDim2.fromOffset(
        (ScreenGui.AbsoluteSize.X - MainFrame.Size.X.Offset) / 2,
        (ScreenGui.AbsoluteSize.Y - MainFrame.Size.Y.Offset) / 2
    )
    MainFrame.ClipsDescendants = true
    MainFrame.BorderSizePixel = 0
    MainFrame.BackgroundColor3 = Color3.fromHex(CurrentTheme.Background)
    MainFrame.Parent = ScreenGui

    if Info.Transparent and Info.Transparent == true then
        MainFrame.BackgroundTransparency = Info.BackgroundImageTransparency or 0.5
    else
        MainFrame.BackgroundTransparency = 0
    end

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = MainFrame

    local Stroke = Instance.new("UIStroke")
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.Thickness = 1
    Stroke.LineJoinMode = Enum.LineJoinMode.Round
    Stroke.Color = Color3.fromHex(CurrentTheme.Outline)
    Stroke.Transparency = 0.8
    Stroke.Parent = MainFrame

    local SideBar = Instance.new("Frame")
    SideBar.Name = "SideBar"
    SideBar.Size = UDim2.fromOffset(Info.SideBarWidth or 180, MainFrame.AbsoluteSize.Y)
    SideBar.Position = UDim2.fromOffset(0, 0)
    SideBar.BackgroundColor3 = Color3.fromHex(CurrentTheme.SideBar)
    SideBar.BorderSizePixel = 0
    SideBar.Parent = MainFrame
    
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -(Info.SideBarWidth or 180), 1, 0)
    ContentArea.Position = UDim2.fromOffset(Info.SideBarWidth or 180, 0)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = MainFrame

    self.ScreenGui = ScreenGui
    self.MainFrame = MainFrame
    self.SideBar = SideBar
    self.ContentArea = ContentArea
    
    return self
end

return Window
