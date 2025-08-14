local Window = {}
Window.__index = Window

local TitleBarModule
local TabModule
local SectionModule
local ParagraphImageModule

function Window.new(config, dependencies)
    local self = setmetatable({}, Window)
    
    self.config = config or {}
    self.dependencies = dependencies
    self.tabs = {}
    self.activeTab = nil
    
    TitleBarModule = self.dependencies.FetchModule("components/TBar.lua")
    TabModule = self.dependencies.FetchModule("components/TB.lua")
    SectionModule = self.dependencies.FetchModule("elements/Section.lua")
    ParagraphImageModule = self.dependencies.FetchModule("elements/ImageElement/Paragraph.Image.lua")

    self:createBaseUI()
    self:createTitleBar()
    
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
    self.MainFrame.Size = UDim2.new(0, 520, 0, 380)
    self.MainFrame.Position = UDim2.new(0.5, -260, 0.5, -190)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Parent = self.ScreenGui

    self.TabsContainer = Instance.new("Frame")
    self.TabsContainer.Name = "TabsContainer"
    self.TabsContainer.Size = UDim2.new(0, 120, 1, -30)
    self.TabsContainer.Position = UDim2.new(0, 0, 0, 30)
    self.TabsContainer.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    self.TabsContainer.BorderSizePixel = 0
    self.TabsContainer.Parent = self.MainFrame
    
    local tabsLayout = Instance.new("UIListLayout")
    tabsLayout.Padding = UDim.new(0, 5)
    tabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabsLayout.Parent = self.TabsContainer

    self.ContentContainer = Instance.new("Frame")
    self.ContentContainer.Name = "ContentContainer"
    self.ContentContainer.Size = UDim2.new(1, -120, 1, -30)
    self.ContentContainer.Position = UDim2.new(0, 120, 0, 30)
    self.ContentContainer.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
    self.ContentContainer.BorderSizePixel = 0
    self.ContentContainer.Parent = self.MainFrame
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

function Window:CreateTab(name, icon)
    if not TabModule then
        warn("Stell Warning: Módulo de Aba (TB.lua) não carregado.")
        return
    end
    
    local tabInstance = TabModule.new({
        Name = name,
        Icon = icon,
        Parent = self.TabsContainer,
        ContentParent = self.ContentContainer,
        Dependencies = {
            Icons = self.dependencies.Icons,
            SectionModule = SectionModule,
            ParagraphImageModule = ParagraphImageModule
        }
    })
    
    table.insert(self.tabs, tabInstance)
    
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
