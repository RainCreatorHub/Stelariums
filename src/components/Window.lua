local Window = {}
Window.__index = Window

function Window.new(config, dependencies)
    local fetchModule = dependencies.FetchModule

    local TitleBar = fetchModule("components/TitleBar.lua")
    local Tab = fetchModule("components/Tab.lua")

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "Stell"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = game:GetService("CoreGui")

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "Window"
    mainFrame.Size = config.Size
    mainFrame.Position = UDim2.new(0.5, -mainFrame.Size.X.Offset / 2, 0.5, -mainFrame.Size.Y.Offset / 2)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui

    local titleBarFrame = TitleBar.new(mainFrame, config)

    local tabsContainer = Instance.new("Frame")
    tabsContainer.Name = "TabsContainer"
    tabsContainer.Size = UDim2.new(0, 120, 1, -titleBarFrame.Size.Y.Offset)
    tabsContainer.Position = UDim2.new(0, 0, 0, titleBarFrame.Size.Y.Offset)
    tabsContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    tabsContainer.BorderSizePixel = 0
    tabsContainer.Parent = mainFrame

    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, -tabsContainer.Size.X.Offset, 1, -titleBarFrame.Size.Y.Offset)
    contentContainer.Position = UDim2.new(0, tabsContainer.Size.X.Offset, 0, titleBarFrame.Size.Y.Offset)
    contentContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    contentContainer.BorderSizePixel = 0
    contentContainer.Parent = mainFrame

    local windowInstance = {
        _activeTabs = {},
        _activeTab = nil,
        _dependencies = dependencies,
        _containers = {
            Tabs = tabsContainer,
            Content = contentContainer
        },
        _modules = {
            Tab = Tab
        }
    }
    
    return setmetatable(windowInstance, Window)
end

function Window:MakeTab(tabInfo)
    tabInfo = tabInfo or {}
    local tabName = tabInfo.Name or "Tab"
    local tabDescription = tabInfo.Description or ""

    local TabModule = self._modules.Tab
    local newTab = TabModule.new(tabName, tabDescription, self._containers.Tabs, self._containers.Content, self._dependencies)
    
    table.insert(self._activeTabs, newTab)

    newTab.Button.MouseButton1Click:Connect(function()
        if self._activeTab then
            self._activeTab:Deactivate()
        end
        newTab:Activate()
        self._activeTab = newTab
    end)

    if #self._activeTabs == 1 then
        newTab:Activate()
        self._activeTab = newTab
    end

    return newTab
end

return Window
