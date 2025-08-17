local Tab = {}

function Tab.new(tabName, tabsContainer, contentContainer, dependencies)
    local fetchModule = dependencies.FetchModule
    local tabObject = {}
    local yPadding = 10
    local currentY = yPadding

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

    tabObject.Button = tabButton

    function tabObject:Activate()
        contentPage.Visible = true
        tabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end

    function tabObject:Deactivate()
        contentPage.Visible = false
        tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end

    local function AddElementToLayout(elementInstance)
        elementInstance.Position = UDim2.new(0.5, -elementInstance.Size.X.Offset / 2, 0, currentY)
        currentY = currentY + elementInstance.Size.Y.Offset + yPadding
        contentPage.CanvasSize = UDim2.new(0, 0, 0, currentY)
        elementInstance.Parent = contentPage
    end

    function tabObject:AddButton(options)
        local ButtonElement = fetchModule("elements/Button.lua")
        if ButtonElement then
            local newButton = ButtonElement.new(options)
            AddElementToLayout(newButton)
        end
        return tabObject
    end

    return tabObject
end

return Tab
