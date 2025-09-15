local library = {}

function library:CreateDropdown(title, options, callback)
    local Players = game:GetService("Players")
    local Player = Players.LocalPlayer
    local PlayerGui = Player:WaitForChild("PlayerGui")

    local screenGui = Instance.new("ScreenGui", PlayerGui)
    screenGui.ResetOnSpawn = true

    local dropdownFrame = Instance.new("TextButton", screenGui)
    dropdownFrame.Size = UDim2.new(0, 200, 0, 30)
    dropdownFrame.Position = UDim2.new(0.5, -100, 0.5, -15)
    dropdownFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    dropdownFrame.Text = ""

    Instance.new("UICorner", dropdownFrame).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", dropdownFrame).Color = Color3.fromRGB(0,0,0)

    local dropdownLabel = Instance.new("TextLabel", dropdownFrame)
    dropdownLabel.Size = UDim2.new(1, 0, 1, 0)
    dropdownLabel.Position = UDim2.new(0, 10, 0, 0)
    dropdownLabel.BackgroundTransparency = 1
    dropdownLabel.Text = title or "Dropdown"
    dropdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownLabel.Font = Enum.Font.Gotham
    dropdownLabel.TextSize = 14
    dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left

    local selectedContainer = Instance.new("Frame", dropdownFrame)
    selectedContainer.Size = UDim2.new(0, 50, 0, 20)
    selectedContainer.Position = UDim2.new(1, -55, 0.5, -10)
    selectedContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    selectedContainer.BorderSizePixel = 0
    Instance.new("UICorner", selectedContainer).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", selectedContainer).Color = Color3.fromRGB(0,0,0)

    local selectedLabel = Instance.new("TextLabel", selectedContainer)
    selectedLabel.Size = UDim2.new(1, 0, 1, 0)
    selectedLabel.BackgroundTransparency = 1
    selectedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    selectedLabel.Font = Enum.Font.Gotham
    selectedLabel.TextSize = 14
    selectedLabel.TextXAlignment = Enum.TextXAlignment.Center

    local optionsFrame = Instance.new("ScrollingFrame", dropdownFrame)
    optionsFrame.Size = UDim2.new(1, 0, 0, 0)
    optionsFrame.Position = UDim2.new(0, 0, 1, 5)
    optionsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    optionsFrame.Visible = false
    optionsFrame.ScrollBarThickness = 5
    optionsFrame.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
    Instance.new("UICorner", optionsFrame).CornerRadius = UDim.new(0, 8)

    local layout = Instance.new("UIListLayout", optionsFrame)
    layout.Padding = UDim.new(0, 4)

    local optionButtons = {}

    for _, option in ipairs(options) do
        local btn = Instance.new("TextButton", optionsFrame)
        btn.Size = UDim2.new(1, -10, 0, 25)
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        btn.Text = option
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.Position = UDim2.new(0, 5, 0, 0)
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        Instance.new("UIStroke", btn).Color = Color3.fromRGB(0,0,0)

        btn.MouseEnter:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end)
        btn.MouseLeave:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        end)

        btn.MouseButton1Click:Connect(function()
            for _, other in ipairs(optionButtons) do
                if other:FindFirstChild("selectedLine") then
                    other.selectedLine:Destroy()
                end
            end

            local line = Instance.new("Frame", btn)
            line.Name = "selectedLine"
            line.Size = UDim2.new(0, 3, 1, 0)
            line.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
            Instance.new("UICorner", line).CornerRadius = UDim.new(0, 2)

            selectedLabel.Text = btn.Text
            if callback then callback(btn.Text) end
        end)

        table.insert(optionButtons, btn)
    end

    local function updateCanvas()
        local h = 0
        for _, btn in ipairs(optionButtons) do
            if btn.Visible then h += btn.AbsoluteSize.Y end
        end
        optionsFrame.CanvasSize = UDim2.new(0, 0, 0, h)
    end

    optionsFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateCanvas)
    for _, btn in ipairs(optionButtons) do
        btn:GetPropertyChangedSignal("Visible"):Connect(updateCanvas)
    end

    local searchButton = Instance.new("TextButton", screenGui)
    searchButton.Size = UDim2.new(0, 30, 0, 30)
    searchButton.Position = UDim2.new(0.5, 105, 0.5, -15)
    searchButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    searchButton.Text = "🔍"
    Instance.new("UICorner", searchButton).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", searchButton).Color = Color3.fromRGB(0,0,0)

    local searchBox = Instance.new("TextBox", screenGui)
    searchBox.Size = UDim2.new(0, 0, 0, 25)
    searchBox.Position = UDim2.new(0.5, 105, 0.5, -12)
    searchBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    searchBox.TextSize = 14
    searchBox.Visible = false
    searchBox.ClearTextOnFocus = false
    Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", searchBox).Color = Color3.fromRGB(0,0,0)

    local dropdownOpen, searchOpen = false, false

    local function OpenDrop()
        if not dropdownOpen then
            dropdownOpen = true
            optionsFrame.Visible = true
            optionsFrame:TweenSize(UDim2.new(1,0,0,math.min(#optionButtons*27,150)), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
        end
    end

    local function CloseDrop()
        if dropdownOpen then
            dropdownOpen = false
            optionsFrame:TweenSize(UDim2.new(1,0,0,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
            task.delay(0.25,function() optionsFrame.Visible = false end)
        end
    end

    local function OpenSearch()
        if not searchOpen then
            searchOpen = true
            searchButton:TweenPosition(UDim2.new(0.5, 105, 0.5, -46), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
            searchBox.Visible = true
            searchBox.TextTransparency = 1
            searchBox:TweenSize(UDim2.new(0, 150, 0, 25), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
            task.spawn(function()
                for i = 1, 0, -0.1 do
                    searchBox.TextTransparency = i
                    task.wait(0.025)
                end
            end)
        end
    end

    local function CloseSearch()
        if searchOpen then
            searchOpen = false
            searchBox:TweenSize(UDim2.new(0,0,0,25), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
            task.spawn(function()
                for i = 0, 1, 0.1 do
                    searchBox.TextTransparency = i
                    task.wait(0.025)
                end
            end)
            task.delay(0.25,function()
            searchBox.Visible = false
                searchButton:TweenPosition(UDim2.new(0.5, 105, 0.5, -15), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
            end)
        end
    end

    -- Eventos de clique
    dropdownFrame.MouseButton1Click:Connect(function()
        if dropdownOpen then
            CloseDrop()
        else
            OpenDrop()
        end
    end)

    searchButton.MouseButton1Click:Connect(function()
        if searchOpen then
            CloseSearch()
        else
            OpenSearch()
        end
    end)

    -- Filtragem de opções
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local text = searchBox.Text:lower()
        for _, btn in ipairs(optionButtons) do
            btn.Visible = text == "" or btn.Text:lower():find(text)
        end
        updateCanvas()
    end)
end

return library
