local Window = {}
Window.__index = Window

local RunService = game:GetService("RunService")

function Window.new(config, dependencies)
    local self = setmetatable({}, Window)
    
    self.config = config or {}
    self.dependencies = dependencies
    self.tabs = {}
    self.pages = {}
    self.activeTab = nil
    self.isMinimized = false
    
    self:createBaseUI()
    self:createTitleBar()
    self:createGradientAnimation()
    
    return self
end

function Window:createBaseUI()
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "Stell_Root"
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.Parent = gethui and gethui() or game:GetService("CoreGui")

    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "WindowFrame"
    self.MainFrame.Size = UDim2.new(0, 550, 0, 420)
    self.MainFrame.Position = UDim2.new(0.5, -275, 0.5, -210)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.ClipsDescendants = true
    self.MainFrame.Parent = self.ScreenGui

    self.BackgroundFrame = Instance.new("Frame")
    self.BackgroundFrame.Name = "BackgroundAnimation"
    self.BackgroundFrame.Size = UDim2.new(1, 0, 1, 0)
    self.BackgroundFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    self.BackgroundFrame.ZIndex = 0
    self.BackgroundFrame.Parent = self.MainFrame

    self.TabsContainer = Instance.new("Frame")
    self.TabsContainer.Name = "TabsContainer"
    self.TabsContainer.Size = UDim2.new(1, 0, 0, 40)
    self.TabsContainer.Position = UDim2.new(0, 0, 0, 40)
    self.TabsContainer.BackgroundTransparency = 1
    self.TabsContainer.ZIndex = 2
    self.TabsContainer.Parent = self.MainFrame
    
    local tabsLayout = Instance.new("UIListLayout")
    tabsLayout.FillDirection = Enum.FillDirection.Horizontal
    tabsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    tabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    tabsLayout.Padding = UDim.new(0, 10)
    tabsLayout.Parent = self.TabsContainer
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.Parent = self.TabsContainer

    self.PagesContainer = Instance.new("Frame")
    self.PagesContainer.Name = "PagesContainer"
    self.PagesContainer.Size = UDim2.new(1, 0, 1, -80)
    self.PagesContainer.Position = UDim2.new(0, 0, 0, 80)
    self.PagesContainer.BackgroundTransparency = 1
    self.PagesContainer.ZIndex = 2
    self.PagesContainer.Parent = self.MainFrame
end

function Window:createTitleBar()
    local TitleBarModule = self.dependencies.FetchModule("components/TBar.lua")
    if TitleBarModule then
        self.titleBar = TitleBarModule.new({
            WindowFrame = self.MainFrame,
            Title = self.config.Title,
            SubTitle = self.config.SubTitle,
            Logo = self.config.Logo,
            Dependencies = self.dependencies,
            MinimizeCallback = function() self:ToggleMinimize() end,
            CloseCallback = function() self:ToggleMFVisibility() end
        })
    end
end

function Window:ToggleMinimize()
    self.isMinimized = not self.isMinimized
    self.MainFrame.Visible = not self.isMinimized
    
    if not self.RestoreButton then
        self.RestoreButton = Instance.new("TextButton")
        self.RestoreButton.Name = "RestoreButton"
        self.RestoreButton.Size = UDim2.new(0, 150, 0, 40)
        self.RestoreButton.Position = self.MainFrame.Position
        self.RestoreButton.Text = "Restaurar " .. self.config.Title
        self.RestoreButton.Font = Enum.Font.GothamBold
        self.RestoreButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        self.RestoreButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        self.RestoreButton.Parent = self.ScreenGui
        
        local gradient = Instance.new("UIGradient")
        gradient.Color = ColorSequence.new(Color3.fromRGB(80, 10, 20), Color3.fromRGB(15, 15, 15))
        gradient.Rotation = 0
        gradient.Parent = self.RestoreButton
        
        self.RestoreButton.MouseButton1Click:Connect(function() self:ToggleMinimize() end)
    end
    
    self.RestoreButton.Visible = self.isMinimized
end

function Window:MakeMF(info)
    info = info or {}
    local FloatingButtonModule = self.dependencies.FetchModule("components/MF.lua")
    if FloatingButtonModule then
        self.FloatingButtonInstance = FloatingButtonModule.new({
            Name = info.Name or "Stell",
            Format = info.Format or "Circle",
            Dependencies = self.dependencies,
            ToggleCallback = function() self:ToggleMFVisibility() end
        })
        self.FloatingButtonInstance.Visible = false
    end
end

function Window:ToggleMFVisibility()
    self.ScreenGui.Enabled = not self.ScreenGui.Enabled
    if self.FloatingButtonInstance then
        self.FloatingButtonInstance.Visible = not self.ScreenGui.Enabled
    end
end

function Window:createGradientAnimation()
    local gradient = Instance.new("UIGradient")
    gradient.Name = "AnimatedGradient"
    gradient.Rotation = 45
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 10, 10)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(150, 0, 20)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 20, 40)),
        ColorSequenceKeypoint.new(0.6, Color3.fromRGB(150, 0, 20)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 10))
    })
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.45, 0),
        NumberSequenceKeypoint.new(0.55, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    gradient.Parent = self.BackgroundFrame

    local speed = 0.3
    local connection
    connection = RunService.RenderStepped:Connect(function(dt)
        if not self.MainFrame or not self.MainFrame.Parent then
            connection:Disconnect()
            return
        end
        local cycle = (tick() % (1 / speed)) * speed
        local offset = (cycle * 2) - 1
        gradient.Offset = Vector2.new(offset, offset)
    end)
end

function Window:CreateTab(name, icon)
    local TabModule = self.dependencies.TabModule
    if not TabModule then
        warn("Stell Warning: Módulo de Aba (TB.lua) não carregado.")
        return
    end
    
    local page = Instance.new("ScrollingFrame")
    page.Name = name .. "_Page"
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.Visible = false
    page.CanvasSize = UDim2.new(0,0,0,0)
    page.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
    page.ScrollBarThickness = 6
    page.Parent = self.PagesContainer
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 15)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page

    local tabInstance = TabModule.new({
        Name = name,
        Icon = icon,
        Parent = self.TabsContainer,
        ContentPage = page,
        Dependencies = self.dependencies
    })
    
    table.insert(self.tabs, tabInstance)
    self.pages[name] = page
    
    if not self.activeTab then
        tabInstance:SetActive(true)
        self.activeTab = tabInstance
    end
    
    tabInstance.Button.MouseButton1Click:Connect(function()
        if self.activeTab == tabInstance then return end
        if self.activeTab then
            self.activeTab:SetActive(false)
        end
        tabInstance:SetActive(true)
        self.activeTab = tabInstance
    end)
    
    return tabInstance
end

return Window
