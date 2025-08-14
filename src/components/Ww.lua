local Window = {}
Window.__index = Window

local RunService = game:GetService("RunService")

local TitleBarModule
local TabModule

function Window.new(config, dependencies)
    local self = setmetatable({}, Window)
    
    self.config = config or {}
    self.dependencies = dependencies
    self.tabs = {}
    self.pages = {}
    self.activeTab = nil
    
    TitleBarModule = self.dependencies.FetchModule("components/TBar.lua")
    TabModule = self.dependencies.FetchModule("components/TB.lua")

    self:createBaseUI()
    self:createTitleBar()
    self:createGradientAnimation() -- A nova função que cria a mágica
    
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
    self.MainFrame.Size = UDim2.new(0, 550, 0, 400)
    self.MainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10) -- Base preta sólida
    self.MainFrame.BorderSizePixel = 1 -- Borda sutil para definição
    self.MainFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
    self.MainFrame.ClipsDescendants = true
    self.MainFrame.Parent = self.ScreenGui

    self.TabsContainer = Instance.new("Frame")
    self.TabsContainer.Name = "TabsContainer"
    self.TabsContainer.Size = UDim2.new(1, 0, 0, 40)
    self.TabsContainer.Position = UDim2.new(0, 0, 0, 30)
    self.TabsContainer.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    self.TabsContainer.BorderSizePixel = 0
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
    self.PagesContainer.Size = UDim2.new(1, 0, 1, -70)
    self.PagesContainer.Position = UDim2.new(0, 0, 0, 70)
    self.PagesContainer.BackgroundTransparency = 1
    self.PagesContainer.Parent = self.MainFrame
end

function Window:createTitleBar()
    if TitleBarModule then
        self.titleBar = TitleBarModule.new({
            WindowFrame = self.MainFrame,
            Title = self.config.Title,
            SubTitle = self.config.SubTitle,
            Logo = self.config.Logo,
            Dependencies = self.dependencies
        })
    end
end

function Window:createGradientAnimation()
    local gradient = Instance.new("UIGradient")
    gradient.Name = "AnimatedGradient"
    gradient.Rotation = 45 -- Rotação diagonal para o efeito "subir para os cantos"
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 10, 10)),      -- Preto (início, invisível)
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(150, 0, 20)),    -- Vermelho escuro, núcleo da animação
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 20, 40)),   -- Vermelho brilhante, pico
        ColorSequenceKeypoint.new(0.6, Color3.fromRGB(150, 0, 20)),    -- Vermelho escuro novamente
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 10))       -- Preto (fim, invisível)
    })
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),   -- Transparente no início
        NumberSequenceKeypoint.new(0.4, 0), -- Opaco no meio
        NumberSequenceKeypoint.new(0.6, 0), -- Opaco no meio
        NumberSequenceKeypoint.new(1, 1)    -- Transparente no fim
    })
    gradient.Parent = self.MainFrame

    -- A animação em si
    local speed = 0.3 -- Velocidade da animação (menor = mais rápido)
    local connection
    connection = RunService.RenderStepped:Connect(function(dt)
        if not self.MainFrame or not self.MainFrame.Parent then
            connection:Disconnect() -- Para o loop se a UI for destruída
            return
        end
        
        -- Usa o tempo (tick) para criar um loop contínuo e suave
        local cycle = (tick() % (1 / speed)) * speed
        local offset = (cycle * 2) - 1 -- Mapeia o ciclo de [0, 1] para [-1, 1]
        
        gradient.Offset = Vector2.new(offset, offset)
    end)
end

function Window:CreateTab(name, icon)
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
