local Tab = {}
Tab.__index = Tab

function Tab.new(name, description, dependencies)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "Stell_Tab_Container"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "Tab"
    mainFrame.Size = UDim2.new(0, 120, 0, 40)
    mainFrame.Position = UDim2.new(0, 0, 0, 50)
    mainFrame.BackgroundTransparency = 1
    mainFrame.Parent = screenGui

    local tabButton = Instance.new("TextButton")
    tabButton.Name = name or "Tab"
    tabButton.Size = UDim2.new(1, 0, 1, 0)
    tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabButton.Text = name or "Tab"
    tabButton.Font = Enum.Font.SourceSans
    tabButton.TextSize = 14
    tabButton.Parent = mainFrame

    if description and description ~= "" then
        tabButton.Tooltip = description
    end

    local tabInstance = {
        GUI = screenGui,
        Frame = mainFrame,
        Button = tabButton,
        _dependencies = dependencies
    }

    return setmetatable(tabInstance, Tab)
end

function Tab:AddButton(text, callback)
    local fetchModule = self._dependencies.FetchModule
    local ButtonElement = fetchModule("elements/Button.lua")
    
    if ButtonElement then
        local newButton = ButtonElement.new(text, callback)
        newButton.GUI.Parent = self.Frame
        newButton.GUI.Enabled = true
    end
    
    return self
end

function Tab:AddSection(info)
    local fetchModule = self._dependencies.FetchModule
    local SectionElement = fetchModule("elements/Section.lua")

    if SectionElement then
        local newSection = SectionElement.new(info)
        newSection.GUI.Parent = self.Frame
        newSection.GUI.Enabled = true
        return newSection
    end
end

return Tab
