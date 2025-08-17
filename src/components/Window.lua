local Window = {}
Window.__index = Window

function Window.new(title, subTitle, logo, size, dependencies)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "Stell_Window_Container"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "Window"
    mainFrame.Size = size or UDim2.new(0, 500, 0, 350)
    mainFrame.Position = UDim2.new(0.5, -mainFrame.Size.X.Offset / 2, 0.5, -mainFrame.Size.Y.Offset / 2)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui

    local windowInstance = {
        GUI = screenGui,
        Frame = mainFrame,
        _dependencies = dependencies,
        _title = title or "Window",
        _subTitle = subTitle or "",
        _logo = logo or ""
    }
    
    setmetatable(windowInstance, Window)
    windowInstance:_initSubComponents()
    return windowInstance
end

function Window:_initSubComponents()
    local fetchModule = self._dependencies.FetchModule
    local TitleBar = fetchModule("components/TitleBar.lua")
    
    local titleBarInstance = TitleBar.new(self._title, self._subTitle, self._logo)
    titleBarInstance.GUI.Parent = self.Frame
end

function Window:MakeTab(name, description)
    local fetchModule = self._dependencies.FetchModule
    local Tab = fetchModule("components/Tab.lua")

    local tabInstance = Tab.new(name, description, self._dependencies)
    tabInstance.GUI.Parent = self.Frame 
    return tabInstance
end

return Window
