local Tab = {}
Tab.__index = Tab

function Tab.new(tabName, tabDescription, tabsContainer, contentContainer, dependencies)
    local fetchModule = dependencies.FetchModule
    
    local contentPage = Instance.new("ScrollingFrame")
    contentPage.Name = tabName .. "_Content"
    contentPage.Size = UDim2.new(1, 0, 1, 0)
    contentPage.BackgroundTransparency = 1
    contentPage.BorderSizePixel = 0
    contentPage.Visible = false
    contentPage.Parent = contentContainer
    contentPage.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentPage.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
    contentPage.ScrollBarThickness = 6

    local tabButton = Instance.new("TextButton")
    tabButton.Name = tabName .. "_Button"
    tabButton.Size = UDim2.new(1, -10, 0, 30)
    local numExistingTabs = #tabsContainer:GetChildren()
    tabButton.Position = UDim2.new(0.5, -tabButton.Size.X.Offset / 2, 0, 5 + (numExistingTabs * 35))
    tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabButton.Text = tabName
    tabButton.Font = Enum.Font.SourceSans
    tabButton.TextSize = 14
    tabButton.AutoButtonColor = false
    tabButton.Parent = tabsContainer

    if tabDescription ~= "" then
        tabButton.Tooltip = tabDescription
    end

    local tabInstance = {
        Button = tabButton,
        _contentPage = contentPage,
        _yPadding = 10,
        _currentY = 10,
        _fetchModule = fetchModule
    }

    return setmetatable(tabInstance, Tab)
end

function Tab:Activate()
    self._contentPage.Visible = true
    self.Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
end

function Tab:Deactivate()
    self._contentPage.Visible = false
    self.Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
end

function Tab:_addElementToLayout(elementInstance)
    elementInstance.Position = UDim2.new(0.5, -elementInstance.Size.X.Offset / 2, 0, self._currentY)
    self._currentY = self._currentY + elementInstance.Size.Y.Offset + self._yPadding
    self._contentPage.CanvasSize = UDim2.new(0, 0, 0, self._currentY)
    elementInstance.Parent = self._contentPage
end

function Tab:AddButton(options)
    local ButtonElement = self._fetchModule("elements/Button.lua")
    if ButtonElement then
        local newButton = ButtonElement.new(options)
        self:_addElementToLayout(newButton)
    end
    return self
end

return Tab
