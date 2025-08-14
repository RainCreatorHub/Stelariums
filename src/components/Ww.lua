local Window = {}
Window.__index = Window

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

if Window then
  ScreenGui:Destroy()
end

function Window.new(config, dependencies)
    local self = setmetatable({}, Window)
    
    self.config = config or {}
    self.config.Title = self.config.Title or "Stell"
    self.config.SubTitle = self.config.SubTitle or ""
    self.config.Logo = self.config.Logo or ""
    self.config.Theme = self.config.Theme or "Dark"
    
    self.dependencies = dependencies
    self.tabs = {}
    self.pages = {}
    self.activeTab = nil
    self.isMinimized = false
    self.connections = {}

    self.theme = {
        Dark = {
            Primary = Color3.fromRGB(10, 10, 10),
            Secondary = Color3.fromRGB(20, 20, 20),
            Accent = Color3.fromRGB(150, 0, 20),
            Text = Color3.fromRGB(255, 255, 255),
            SubText = Color3.fromRGB(180, 180, 180),
            ButtonHover = Color3.fromRGB(255, 60, 70)
        },
        Light = {
            Primary = Color3.fromRGB(240, 240, 240),
            Secondary = Color3.fromRGB(220, 220, 220),
            Accent = Color3.fromRGB(200, 50, 50),
            Text = Color3.fromRGB(0, 0, 0),
            SubText = Color3.fromRGB(100, 100, 100),
            ButtonHover = Color3.fromRGB(255, 80, 80)
        }
    }
    
    self:createBaseUI()
    self:createTitleBar()
    self:createGradientAnimation()
    self:addShadowEffect()
    
    return self
end

function Window:getThemeColor(key)
    return self.theme[self.config.Theme][key]
end

function Window:addShadowEffect()
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.7
    shadow.ZIndex = -1
    shadow.Parent = self.MainFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = shadow
end

function Window:addHoverEffect(button, hoverColor, duration)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(duration or 0.2), {
            BackgroundColor3 = hoverColor,
            Size = UDim2.new(0, button.Size.X.Offset + 2, 0, button.Size.Y.Offset + 2)
        }):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(duration or 0.2), {
            BackgroundColor3 = self:getThemeColor("Secondary"),
            Size = UDim2.new(0, button.Size.X.Offset - 2, 0, button.Size.Y.Offset - 2)
        }):Play()
    end)
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
    self.MainFrame.BackgroundColor3 = self:getThemeColor("Primary")
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.ClipsDescendants = true
    self.MainFrame.Parent = self.ScreenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = self.MainFrame

    self.BackgroundFrame = Instance.new("Frame")
    self.BackgroundFrame.Name = "BackgroundAnimation"
    self.BackgroundFrame.Size = UDim2.new(1, 0, 1, 0)
    self.BackgroundFrame.BackgroundColor3 = self:getThemeColor("Primary")
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
            CloseCallback = function() self:ToggleMFVisibility() end,
            Theme = self.config.Theme
        })
    end
end

function Window:ToggleMinimize()
    self.isMinimized = not self.isMinimized
    
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    if self.isMinimized then
        TweenService:Create(self.MainFrame, tweenInfo, {Size = UDim2.new(0, 550, 0, 0), BackgroundTransparency = 1}):Play()
    else
        TweenService:Create(self.MainFrame, tweenInfo, {Size = UDim2.new(0, 550, 0, 420), BackgroundTransparency = 0}):Play()
    end
    
    self.MainFrame.Visible = not self.isMinimized
    
    if not self.RestoreButton then
        self.RestoreButton = Instance.new("TextButton")
        self.RestoreButton.Name = "RestoreButton"
        self.RestoreButton.Size = UDim2.new(0, 150, 0, 40)
        self.RestoreButton.Position = self.MainFrame.Position
        self.RestoreButton.Text = "Restaurar " .. self.config.Title
        self.RestoreButton.Font = Enum.Font.GothamBold
        self.RestoreButton.TextColor3 = self:getThemeColor("Text")
        self.RestoreButton.BackgroundColor3 = self:getThemeColor("Secondary")
        self.RestoreButton.Parent = self.ScreenGui
        
        local gradient = Instance.new("UIGradient")
        gradient.Color = ColorSequence.new(self:getThemeColor("Accent"), self:getThemeColor("Primary"))
        gradient.Rotation = 0
        gradient.Parent = self.RestoreButton
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = self.RestoreButton
        
        self.RestoreButton.MouseButton1Click:Connect(function() self:ToggleMinimize() end)
        self:addHoverEffect(self.RestoreButton, self:getThemeColor("ButtonHover"))
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
    local targetTransparency = self.ScreenGui.Enabled and 1 or 0
    TweenService:Create(self.ScreenGui, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Enabled = not self.ScreenGui.Enabled}):Play()
    if self.FloatingButtonInstance then
        self.FloatingButtonInstance.Visible = not self.ScreenGui.Enabled
    end
end

function Window:createGradientAnimation()
    local gradient = Instance.new("UIGradient")
    gradient.Name = "AnimatedGradient"
    gradient.Rotation = 45
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, self:getThemeColor("Primary")),
        ColorSequenceKeypoint.new(0.3, self:getThemeColor("Accent")),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 20, 40)),
        ColorSequenceKeypoint.new(0.7, self:getThemeColor("Accent")),
        ColorSequenceKeypoint.new(1, self:getThemeColor("Primary"))
    })
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.4, 0),
        NumberSequenceKeypoint.new(0.6, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    gradient.Parent = self.BackgroundFrame
    local tweenInfo = TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true)
    TweenService:Create(gradient, tweenInfo, {Offset = Vector2.new(-2, -2)}):Play()
end

function Window:MakeT(info)
    info = info or {}
    local TabModule = self.dependencies.TabModule
    if not TabModule then
        warn("Stell Warning: Módulo de Aba (TB.lua) não carregado.")
        return
    end
    
    local page = Instance.new("ScrollingFrame")
    page.Name = (info.Name or "Tab") .. "_Page"
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.Visible = false
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
    page.ScrollBarThickness = 6
    page.Parent = self.PagesContainer
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 15)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page

    local tabInstance = TabModule.new({
        Name = info.Name,
        Icon = info.Icon,
        Content = info.Content,
        Parent = self.TabsContainer,
        ContentPage = page,
        Dependencies = self.dependencies,
        Theme = self.config.Theme
    })
    
    table.insert(self.tabs, tabInstance)
    self.pages[info.Name] = page
    
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
        TweenService:Create(page, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundTransparency = 0}):Play()
    end)
    
    return tabInstance
end

function Window:Destroy()
    for _, conn in ipairs(self.connections) do
        conn:Disconnect()
    end
    self.ScreenGui:Destroy()
end

return Window
