local Window = {}
Window.__index = Window

function Window.new(config)
    local self = setmetatable({}, Window)
    
    -- Create ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "DoorLib"
    self.ScreenGui.Parent = game:GetService("CoreGui")
    
    -- Create main frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = config.DefaultSize or UDim2.new(0, 470, 0, 340)
    self.MainFrame.Position = UDim2.new(0.5, -235, 0.5, -170)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    self.MainFrame.Parent = self.ScreenGui
    
    -- Add title bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Size = UDim2.new(1, 0, 0, 30)
    self.TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    self.TitleBar.Parent = self.MainFrame
    
    -- Add title text
    self.Title = Instance.new("TextLabel")
    self.Title.Name = "Title"
    self.Title.Text = config.Title or "DoorLib Window"
    self.Title.Size = UDim2.new(1, -10, 1, 0)
    self.Title.Position = UDim2.new(0, 10, 0, 0)
    self.Title.BackgroundTransparency = 1
    self.Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.Title.TextXAlignment = Enum.TextXAlignment.Left
    self.Title.Parent = self.TitleBar
    
    return self
end

function Window:AddTab(name)
    -- Add tab functionality here
end

return Window
