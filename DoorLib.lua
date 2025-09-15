-- 🌌 STELARIUM UI LIBRARY v4 - CORRETO E FUNCIONAL
-- Coloque isso em ServerScriptService ou ReplicatedStorage

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Lib = {}
Lib.__index = Lib

-- Armazena janelas criadas
Lib.Windows = {}

-- Simulação de registro
local fakeRegistry = {}
function getreg() return fakeRegistry end
function setreg(t) fakeRegistry = t end

-- Função de Tooltip
local function CreateTooltip(text, parent)
    if not text or text == "" then return nil end
    local tooltip = Instance.new("Frame")
    tooltip.Size = UDim2.new(0, 180, 0, 35)
    tooltip.BackgroundTransparency = 0.4
    tooltip.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    tooltip.BorderSizePixel = 0
    tooltip.Visible = false
    tooltip.ZIndex = 1000
    tooltip.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = tooltip

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Parent = tooltip

    local triangle = Instance.new("ImageLabel")
    triangle.Size = UDim2.new(0, 15, 0, 8)
    triangle.BackgroundTransparency = 1
    triangle.Image = "rbxassetid://3926305904"
    triangle.ImageRectSize = Vector2.new(36, 18)
    triangle.ImageRectOffset = Vector2.new(144, 72)
    triangle.Position = UDim2.new(0.1, 0, 1, 0)
    triangle.Parent = tooltip

    table.insert(Lib.Tooltips, tooltip)

    return {
        Show = function()
            tooltip.Visible = true
        end,
        Hide = function()
            tooltip.Visible = false
        end,
        Destroy = function()
            tooltip:Destroy()
        end
    }
end

-- MakeWindow
function Lib:MakeWindow(config)
    config = config or {}
    local Title = config.Title or "Stelarium Window"
    local Subtitle = config.Subtitle or ""
    local Key = config.Key or false
    local KeySystem = config.KeySystem or {}
    local Size = config.Size or {}

    local MinSize = Size.MinSize or {400, 300}
    local MaxSize = Size.MaxSize or {600, 500}
    local DefaultSize = Size.DefaultSize or {450, 330}
    local Resizable = Size.Resizable or false
    local Blur = config.Blur or false

    -- KeySystem
    local validKeys = KeySystem.Key or {}
    local keyTitle = KeySystem.Title or "🔑 Acesso Restrito"
    local keyDesc = KeySystem.Desc or "Insira a chave."
    local rainbowTitle = KeySystem.Rainbow or false

    if Key and #validKeys > 0 then
        local hasAccess = false
        for _, savedKey in pairs(getreg() or {}) do
            if table.find(validKeys, savedKey) then
                hasAccess = true
                break
            end
        end

        if not hasAccess then
            local keyGui = Instance.new("ScreenGui")
            keyGui.Name = "KeyAuth_" .. tick()
            keyGui.ResetOnSpawn = false
            keyGui.Parent = PlayerGui

            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0, 340, 0, 240)
            frame.Position = UDim2.new(0.5, -170, 0.5, -120)
            frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            frame.BorderSizePixel = 0
            frame.Parent = keyGui

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 8)
            corner.Parent = frame

            local titleLabel = Instance.new("TextLabel")
            titleLabel.Size = UDim2.new(1, 0, 0, 40)
            titleLabel.Position = UDim2.new(0, 0, 0, 0)
            titleLabel.BackgroundTransparency = 1
            titleLabel.Text = keyTitle
            titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            titleLabel.Font = Enum.Font.GothamBold
            titleLabel.TextSize = 18
            titleLabel.Parent = frame

            if rainbowTitle then
                spawn(function()
                    while task.wait(0.05) and titleLabel.Parent do
                        titleLabel.TextColor3 = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                    end
                end)
            end

            local descLabel = Instance.new("TextLabel")
            descLabel.Size = UDim2.new(1, -20, 0, 45)
            descLabel.Position = UDim2.new(0, 10, 0, 50)
            descLabel.BackgroundTransparency = 1
            descLabel.Text = keyDesc
            descLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            descLabel.Font = Enum.Font.Gotham
            descLabel.TextSize = 14
            descLabel.TextWrapped = true
            descLabel.Parent = frame

            local textBox = Instance.new("TextBox")
            textBox.Size = UDim2.new(1, -20, 0, 40)
            textBox.Position = UDim2.new(0, 10, 0, 110)
            textBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            textBox.PlaceholderText = "Digite a chave..."
            textBox.ClearTextOnFocus = false
            textBox.Font = Enum.Font.Gotham
            textBox.TextSize = 14
            textBox.Parent = frame

            local boxCorner = Instance.new("UICorner")
            boxCorner.CornerRadius = UDim.new(0, 6)
            boxCorner.Parent = textBox

            local submitBtn = Instance.new("TextButton")
            submitBtn.Size = UDim2.new(1, -20, 0, 40)
            submitBtn.Position = UDim2.new(0, 10, 0, 170)
            submitBtn.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
            submitBtn.Text = "🔓 ACESSAR"
            submitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            submitBtn.Font = Enum.Font.GothamBold
            submitBtn.TextSize = 14
            submitBtn.Parent = frame

            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = submitBtn

            submitBtn.MouseButton1Click:Connect(function()
                local input = textBox.Text
                if table.find(validKeys, input) then
                    local reg = getreg() or {}
                    table.insert(reg, input)
                    setreg(reg)
                    keyGui:Destroy()
                    hasAccess = true
                else
                    textBox.Text = ""
                    textBox.PlaceholderText = "❌ Chave inválida!"
                    spawn(function()
                        task.wait(2)
                        textBox.PlaceholderText = "Digite a chave..."
                    end)
                end
            end)

            repeat task.wait(0.1) until hasAccess
        end
    end

    -- Janela principal
    local window = {}
    window.Tabs = {}
    window.Elements = {}

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "StelariumWindow_" .. #Lib.Windows + 1
    screenGui.ResetOnSpawn = true
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = PlayerGui

    if Blur then
        local blur = Instance.new("BlurEffect")
        blur.Size = 12
        blur.Parent = game.Lighting
        window.BlurEffect = blur
    end

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, DefaultSize[1], 0, DefaultSize[2])
    mainFrame.Position = UDim2.new(0.5, -DefaultSize[1]/2, 0.5, -DefaultSize[2]/2)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui

    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = mainFrame

    local frameStroke = Instance.new("UIStroke")
    frameStroke.Thickness = 1
    frameStroke.Color = Color3.fromRGB(0,0,0)
    frameStroke.Parent = mainFrame

    -- Barra de título
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -100, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = Title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar

    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Size = UDim2.new(0, 25, 0, 25)
    minimizeBtn.Position = UDim2.new(1, -85, 0, 5)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    minimizeBtn.Text = "—"
    minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeBtn.Font = Enum.Font.SourceSans
    minimizeBtn.TextSize = 20
    minimizeBtn.Parent = titleBar

    local maximizeBtn = Instance.new("TextButton")
    maximizeBtn.Size = UDim2.new(0, 25, 0, 25)
    maximizeBtn.Position = UDim2.new(1, -55, 0, 5)
    maximizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    maximizeBtn.Text = "□"
    maximizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    maximizeBtn.Font = Enum.Font.SourceSans
    maximizeBtn.TextSize = 16
    maximizeBtn.Parent = titleBar

    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 25, 0, 25)
    closeButton.Position = UDim2.new(1, -25, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    closeButton.Text = "✕"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Font = Enum.Font.SourceSans
    closeButton.TextSize = 16
    closeButton.Parent = titleBar

    for _, btn in pairs({minimizeBtn, maximizeBtn, closeButton}) do
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 4)
        c.Parent = btn
    end

    closeButton.MouseButton1Click:Connect(function()
        if window.BlurEffect then window.BlurEffect:Destroy() end
        screenGui:Destroy()
    end)

    minimizeBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
        task.delay(0.1, function()
            Lib:CreateToast(Title .. " minimizada.", 4)
        end)
    end)

    maximizeBtn.MouseButton1Click:Connect(function()
        if mainFrame.Size == UDim2.new(0, DefaultSize[1], 0, DefaultSize[2]) then
            mainFrame:TweenSize(UDim2.new(0, MaxSize[1], 0, MaxSize[2]), "Out", "Quad", 0.3)
        else
            mainFrame:TweenSize(UDim2.new(0, DefaultSize[1], 0, DefaultSize[2]), "Out", "Quad", 0.3)
        end
    end)

    if Subtitle ~= "" then
        local subtitleLabel = Instance.new("TextLabel")
        subtitleLabel.Size = UDim2.new(1, -20, 0, 20)
        subtitleLabel.Position = UDim2.new(0, 10, 0, 40)
        subtitleLabel.BackgroundTransparency = 1
        subtitleLabel.Text = Subtitle
        subtitleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        subtitleLabel.Font = Enum.Font.Gotham
        subtitleLabel.TextSize = 12
        subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        subtitleLabel.Parent = mainFrame
    end

    local tabFrame = Instance.new("Frame")
    tabFrame.Size = UDim2.new(1, 0, 0, 35)
    tabFrame.Position = UDim2.new(0, 0, 0, 75)
    tabFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    tabFrame.BorderSizePixel = 0
    tabFrame.Parent = mainFrame

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.Parent = tabFrame

    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Size = UDim2.new(1, 0, 1, -120)
    contentFrame.Position = UDim2.new(0, 0, 0, 120)
    contentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    contentFrame.BorderSizePixel = 0
    contentFrame.ScrollBarThickness = 4
    contentFrame.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
    contentFrame.Parent = mainFrame

    -- AddTab
    function window:AddTab(config)
        config = config or {}
        local Name = config.Name or "Nova Aba"
        local Desc = config.Desc or ""

        local tab = {
            Name = Name,
            Elements = {},
            Content = nil
        }

        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(0, 120, 1, 0)
        tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        tabButton.Text = Name
        tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        tabButton.Font = Enum.Font.Gotham
        tabButton.TextSize = 14
        tabButton.Parent = tabFrame

        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 4)
        tabCorner.Parent = tabButton

        local tabContent = Instance.new("Frame")
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.Visible = false
        tabContent.Parent = contentFrame

        local contentLayout = Instance.new("UIListLayout")
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Padding = UDim.new(0, 8)
        contentLayout.Parent = tabContent

        -- Tooltip
        if Desc ~= "" then
            local tooltip = CreateTooltip(Desc, tabButton)
            tabButton.MouseEnter:Connect(tooltip.Show)
            tabButton.MouseLeave:Connect(tooltip.Hide)
        end

        tabButton.MouseButton1Click:Connect(function()
            for _, t in ipairs(window.Tabs) do
                t.Content.Visible = false
                t.Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                t.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
            tabContent.Visible = true
            tabButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
            tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            table.insert(Lib.UsageHistory, {tab = Name, time = tick()})
        end)

        if #window.Tabs == 0 then
            tabContent.Visible = true
            tabButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
            tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        end

        tab.Button = tabButton
        tab.Content = tabContent

        -- Elementos do Tab
        function tab:Label(config)
            config = config or {}
            local Text = config.Text or "Novo Rótulo"
            local Name = config.Name or "Label"
            local Desc = config.Desc or ""
            local Size = config.Size or 14
            local Color = config.Color or Color3.fromRGB(255, 255, 255)
            local Position = config.Position or UDim2.new(0, 0, 0, 0)
            local Font = config.Font or Enum.Font.Gotham

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 0, 25)
            label.Position = Position
            label.BackgroundTransparency = 1
            label.Text = Text
            label.TextColor3 = Color
            label.Font = Font
            label.TextSize = Size
            label.Name = Name
            label.Parent = tabContent

            if Desc ~= "" then
                local tooltip = CreateTooltip(Desc, label)
                label.MouseEnter:Connect(tooltip.Show)
                label.MouseLeave:Connect(tooltip.Hide)
            end

            table.insert(tab.Elements, label)
            table.insert(Lib.Elements, {type = "Label", name = Name, obj = label})

            return {
                SetText = function(newText)
                    label.Text = newText
                end,
                SetColor = function(newColor)
                    label.TextColor3 = newColor
                end,
                Destroy = function()
                    label:Destroy()
                end,
                Show = function()
                    label.Visible = true
                end,
                Hide = function()
                    label.Visible = false
                end
            }
        end

        function tab:Button(config)
            config = config or {}
            local Text = config.Text or "Botão"
            local Name = config.Name or "Button"
            local Desc = config.Desc or ""
            local Callback = config.Callback or function() end
            local Color = config.Color or Color3.fromRGB(0, 162, 255)
            local TextColor = config.TextColor or Color3.fromRGB(255, 255, 255)
            local Size = config.Size or UDim2.new(1, 0, 0, 35)
            local Position = config.Position or UDim2.new(0, 0, 0, 0)

            local btn = Instance.new("TextButton")
            btn.Size = Size
            btn.Position = Position
            btn.BackgroundColor3 = Color
            btn.Text = Text
            btn.TextColor3 = TextColor
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 14
            btn.Name = Name
            btn.Parent = tabContent

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 6)
            corner.Parent = btn

            if Desc ~= "" then
                local tooltip = CreateTooltip(Desc, btn)
                btn.MouseEnter:Connect(tooltip.Show)
                btn.MouseLeave:Connect(tooltip.Hide)
            end

            btn.MouseButton1Click:Connect(function()
                Lib:CreateToast("'" .. Text .. "' clicado!", 2)
                Callback()
                table.insert(Lib.UsageHistory, {element = "Button", name = Name, text = Text, time = tick()})
            end)

            table.insert(tab.Elements, btn)
            table.insert(Lib.Elements, {type = "Button", name = Name, obj = btn})

            return {
                SetText = function(newText)
                    btn.Text = newText
                end,
                SetColor = function(newColor)
                    btn.BackgroundColor3 = newColor
                end,
                Destroy = function()
                    btn:Destroy()
                end,
                Show = function()
                    btn.Visible = true
                end,
                Hide = function()
                    btn.Visible = false
                end
            }
        end

        function tab:Toggle(config)
            config = config or {}
            local Text = config.Text or "Toggle"
            local Name = config.Name or "Toggle"
            local Desc = config.Desc or ""
            local Default = config.Default or false
            local Callback = config.Callback or function() end
            local TrueColor = config.TrueColor or Color3.fromRGB(0, 162, 255)
            local FalseColor = config.FalseColor or Color3.fromRGB(50, 50, 50)
            local Size = config.Size or UDim2.new(1, 0, 0, 35)
            local Position = config.Position or UDim2.new(0, 0, 0, 0)

            local toggleFrame = Instance.new("Frame")
            toggleFrame.Size = Size
            toggleFrame.Position = Position
            toggleFrame.BackgroundTransparency = 1
            toggleFrame.Name = Name
            toggleFrame.Parent = tabContent

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -60, 1, 0)
            label.Position = UDim2.new(0, 0, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = Text
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.Font = Enum.Font.Gotham
            label.TextSize = 14
            label.Parent = toggleFrame

            local toggle = Instance.new("TextButton")
            toggle.Size = UDim2.new(0, 50, 0, 25)
            toggle.Position = UDim2.new(1, -55, 0.5, -12)
            toggle.BackgroundColor3 = Default and TrueColor or FalseColor
            toggle.Text = ""
            toggle.Parent = toggleFrame

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 25)
            corner.Parent = toggle

            local circle = Instance.new("Frame")
            circle.Size = UDim2.new(0, 20, 0, 20)
            circle.Position = UDim2.new(Default and 1 or 0, Default and -22 or 2, 0.5, -10)
            circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            circle.BorderSizePixel = 0
            circle.Parent = toggle

            local circleCorner = Instance.new("UICorner")
            circleCorner.CornerRadius = UDim.new(0, 1)
            circleCorner.Parent = circle

            local State = Default

            if Desc ~= "" then
                local tooltip = CreateTooltip(Desc, toggleFrame)
                toggleFrame.MouseEnter:Connect(tooltip.Show)
                toggleFrame.MouseLeave:Connect(tooltip.Hide)
            end

            toggle.MouseButton1Click:Connect(function()
                State = not State
                toggle.BackgroundColor3 = State and TrueColor or FalseColor
                circle:TweenPosition(State and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10), "Out", "Quad", 0.2)
                Callback(State)
                table.insert(Lib.UsageHistory, {element = "Toggle", name = Name, state = State, time = tick()})
            end)

            table.insert(tab.Elements, toggleFrame)
            table.insert(Lib.Elements, {type = "Toggle", name = Name, obj = toggleFrame, getState = function() return State end})

            return {
                Set = function(newState)
                    State = newState
                    toggle.BackgroundColor3 = State and TrueColor or FalseColor
                    circle:TweenPosition(State and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10), "Out", "Quad", 0.2)
                end,
                Get = function() return State end,
                Toggle = function()
                    State = not State
                    toggle.BackgroundColor3 = State and TrueColor or FalseColor
                    circle:TweenPosition(State and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10), "Out", "Quad", 0.2)
                    Callback(State)
                end,
                Destroy = function()
                    toggleFrame:Destroy()
                end,
                Show = function()
                    toggleFrame.Visible = true
                end,
                Hide = function()
                    toggleFrame.Visible = false
                end
            }
        end

        function tab:Slider(config)
            config = config or {}
            local Text = config.Text or "Slider"
            local Name = config.Name or "Slider"
            local Desc = config.Desc or ""
            local Min = config.Min or 0
            local Max = config.Max or 100
            local Default = config.Default or 50
            local Callback = config.Callback or function() end
            local Size = config.Size or UDim2.new(1, 0, 0, 50)
            local Position = config.Position or UDim2.new(0, 0, 0, 0)

            local sliderFrame = Instance.new("Frame")
            sliderFrame.Size = Size
            sliderFrame.Position = Position
            sliderFrame.BackgroundTransparency = 1
            sliderFrame.Name = Name
            sliderFrame.Parent = tabContent

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 0, 20)
            label.BackgroundTransparency = 1
            label.Text = Text .. ": " .. math.floor(Default)
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.Font = Enum.Font.Gotham
            label.TextSize = 14
            label.Parent = sliderFrame

            local bar = Instance.new("Frame")
            bar.Size = UDim2.new(1, -20, 0, 8)
            bar.Position = UDim2.new(0, 10, 0, 25)
            bar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            bar.BorderSizePixel = 0
            bar.Parent = sliderFrame

            local barCorner = Instance.new("UICorner")
            barCorner.CornerRadius = UDim.new(0, 4)
            barCorner.Parent = bar

            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 16, 0, 16)
            knob.Position = UDim2.new((Default - Min) / (Max - Min), -8, 0.5, -8)
            knob.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
            knob.BorderSizePixel = 0
            knob.Parent = bar

            local knobCorner = Instance.new("UICorner")
            knobCorner.CornerRadius = UDim.new(0, 1)
            knobCorner.Parent = knob

            local Value = Default

            if Desc ~= "" then
                local tooltip = CreateTooltip(Desc, sliderFrame)
                sliderFrame.MouseEnter:Connect(tooltip.Show)
                sliderFrame.MouseLeave:Connect(tooltip.Hide)
            end

            local dragging = false
            knob.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local rel = (input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X
                    rel = math.clamp(rel, 0, 1)
                    Value = Min + (Max - Min) * rel
                    knob.Position = UDim2.new(rel, -8, 0.5, -8)
                    label.Text = Text .. ": " .. math.floor(Value)
                    Callback(Value)
                end
            end)

            table.insert(tab.Elements, sliderFrame)
            table.insert(Lib.Elements, {type = "Slider", name = Name, obj = sliderFrame, getValue = function() return Value end})

            return {
                SetValue = function(newValue)
                    Value = math.clamp(newValue, Min, Max)
                    local rel = (Value - Min) / (Max - Min)
                    knob.Position = UDim2.new(rel, -8, 0.5, -8)
                    label.Text = Text .. ": " .. math.floor(Value)
                end,
                GetValue = function() return Value end,
                Destroy = function()
                    sliderFrame:Destroy()
                end,
                Show = function()
                    sliderFrame.Visible = true
                end,
                Hide = function()
                    sliderFrame.Visible = false
                end
            }
        end

        function tab:Dropdown(config)
            config = config or {}
            local Title = config.Title or "Selecione"
            local Name = config.Name or "Dropdown"
            local Desc = config.Desc or ""
            local Options = config.Options or {"Opção 1", "Opção 2"}
            local Default = config.Default or Options[1] or ""
            local Callback = config.Callback or function() end
            local Size = config.Size or UDim2.new(1, -20, 0, 35)
            local Position = config.Position or UDim2.new(0, 10, 0, 0)

            local dropdownFrame = Instance.new("TextButton")
            dropdownFrame.Size = Size
            dropdownFrame.Position = Position
            dropdownFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            dropdownFrame.Text = ""
            dropdownFrame.Name = Name
            dropdownFrame.Parent = tabContent

            local dropdownUICorner = Instance.new("UICorner")
            dropdownUICorner.CornerRadius = UDim.new(0, 8)
            dropdownUICorner.Parent = dropdownFrame

            local dropdownStroke = Instance.new("UIStroke")
            dropdownStroke.Thickness = 1
            dropdownStroke.Color = Color3.fromRGB(0,0,0)
            dropdownStroke.Parent = dropdownFrame

            local dropdownLabel = Instance.new("TextLabel")
            dropdownLabel.Size = UDim2.new(1, -60, 1, 0)
            dropdownLabel.Position = UDim2.new(0, 10, 0, 0)
            dropdownLabel.BackgroundTransparency = 1
            dropdownLabel.Text = Title
            dropdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            dropdownLabel.Font = Enum.Font.Gotham
            dropdownLabel.TextSize = 14
            dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            dropdownLabel.Parent = dropdownFrame

            local selectedContainer = Instance.new("Frame")
            selectedContainer.Size = UDim2.new(0, 60, 0, 25)
            selectedContainer.Position = UDim2.new(1, -70, 0.5, -12)
            selectedContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            selectedContainer.BorderSizePixel = 0
            selectedContainer.Parent = dropdownFrame

            local selectedCorner = Instance.new("UICorner")
            selectedCorner.CornerRadius = UDim.new(0, 6)
            selectedCorner.Parent = selectedContainer

            local selectedStroke = Instance.new("UIStroke")
            selectedStroke.Thickness = 1
            selectedStroke.Color = Color3.fromRGB(0,0,0)
            selectedStroke.Parent = selectedContainer

            local selectedLabel = Instance.new("TextLabel")
            selectedLabel.Size = UDim2.new(1, 0, 1, 0)
            selectedLabel.Position = UDim2.new(0, 0, 0, 0)
            selectedLabel.BackgroundTransparency = 1
            selectedLabel.Text = Default
            selectedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            selectedLabel.Font = Enum.Font.Gotham
            selectedLabel.TextSize = 14
            selectedLabel.TextXAlignment = Enum.TextXAlignment.Center
            selectedLabel.Parent = selectedContainer

            local optionsFrame = Instance.new("ScrollingFrame")
            optionsFrame.Size = UDim2.new(1, 0, 0, 0)
            optionsFrame.Position = UDim2.new(0, 0, 1, 5)
            optionsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            optionsFrame.BorderSizePixel = 0
            optionsFrame.Visible = false
            optionsFrame.ScrollBarThickness = 5
            optionsFrame.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
            optionsFrame.ClipsDescendants = true
            optionsFrame.Parent = dropdownFrame

            local optionsCorner = Instance.new("UICorner")
            optionsCorner.CornerRadius = UDim.new(0, 8)
            optionsCorner.Parent = optionsFrame

            local optionsLayout = Instance.new("UIListLayout")
            optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
            optionsLayout.Padding = UDim.new(0, 4)
            optionsLayout.FillDirection = Enum.FillDirection.Vertical
            optionsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            optionsLayout.VerticalAlignment = Enum.VerticalAlignment.Top
            optionsLayout.Parent = optionsFrame

            local optionButtons = {}

            for _, option in pairs(Options) do
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, -10, 0, 30)
                btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                btn.Text = option
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                btn.Font = Enum.Font.Gotham
                btn.TextSize = 14
                btn.Position = UDim2.new(0, 5, 0, 0)
                btn.Parent = optionsFrame

                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 6)
                btnCorner.Parent = btn

                local btnStroke = Instance.new("UIStroke")
                btnStroke.Thickness = 1
                btnStroke.Color = Color3.fromRGB(0,0,0)
                btnStroke.Parent = btn

                btn.MouseEnter:Connect(function()
                    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                end)
                btn.MouseLeave:Connect(function()
                    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                end)

                btn.MouseButton1Click:Connect(function()
                    for _, otherBtn in ipairs(optionButtons) do
                        if otherBtn:FindFirstChild("selectedLine") then
                            otherBtn.selectedLine:Destroy()
                        end
                    end

                    local selectedLine = Instance.new("Frame")
                    selectedLine.Name = "selectedLine"
                    selectedLine.Size = UDim2.new(0, 3, 1, 0)
                    selectedLine.Position = UDim2.new(0, 0, 0, 0)
                    selectedLine.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
                    selectedLine.BorderSizePixel = 0
                    selectedLine.Parent = btn

                    local lineCorner = Instance.new("UICorner")
                    lineCorner.CornerRadius = UDim.new(0, 2)
                    lineCorner.Parent = selectedLine

                    selectedLabel.Text = btn.Text
                    Callback(btn.Text)
                    table.insert(Lib.UsageHistory, {element = "Dropdown", name = Name, option = btn.Text, time = tick()})
                end)

                table.insert(optionButtons, btn)
            end

            local function updateCanvasSize()
                local totalHeight = 0
                for _, btn in ipairs(optionButtons) do
                    if btn.Visible then
                        totalHeight = totalHeight + btn.AbsoluteSize.Y
                    end
                end
                optionsFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
            end

            optionsFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateCanvasSize)
            for _, btn in ipairs(optionButtons) do
                btn:GetPropertyChangedSignal("Visible"):Connect(updateCanvasSize)
            end

            local dropdownOpen = false

            local function OpenDrop()
                if not dropdownOpen then
                    dropdownOpen = true
                    optionsFrame.Visible = true
                    optionsFrame:TweenSize(UDim2.new(1,0,0,math.min(#optionButtons*32,180)), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
                end
            end

            local function CloseDrop()
                if dropdownOpen then
                    dropdownOpen = false
                    optionsFrame:TweenSize(UDim2.new(1,0,0,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
                    task.delay(0.25,function()
                        optionsFrame.Visible = false
                    end)
                end
            end

            dropdownFrame.MouseButton1Click:Connect(function()
                if dropdownOpen then
                    CloseDrop()
                else
                    OpenDrop()
                end
            end)

            if Desc ~= "" then
                local tooltip = CreateTooltip(Desc, dropdownFrame)
                dropdownFrame.MouseEnter:Connect(tooltip.Show)
                dropdownFrame.MouseLeave:Connect(tooltip.Hide)
            end

            table.insert(tab.Elements, dropdownFrame)
            table.insert(Lib.Elements, {type = "Dropdown", name = Name, obj = dropdownFrame, getSelected = function() return selectedLabel.Text end})

            return {
                SetOptions = function(newOptions)
                    for _, btn in ipairs(optionButtons) do
                        btn:Destroy()
                    end
                    optionButtons = {}

                    for _, option in pairs(newOptions) do
                        local btn = Instance.new("TextButton")
                        btn.Size = UDim2.new(1, -10, 0, 30)
                        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                        btn.Text = option
                        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                        btn.Font = Enum.Font.Gotham
                        btn.TextSize = 14
                        btn.Position = UDim2.new(0, 5, 0, 0)
                        btn.Parent = optionsFrame

                        local btnCorner = Instance.new("UICorner")
                        btnCorner.CornerRadius = UDim.new(0, 6)
                        btnCorner.Parent = btn

                        local btnStroke = Instance.new("UIStroke")
                        btnStroke.Thickness = 1
                        btnStroke.Color = Color3.fromRGB(0,0,0)
                        btnStroke.Parent = btn

                        btn.MouseEnter:Connect(function()
                            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                        end)
                        btn.MouseLeave:Connect(function()
                            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                        end)

                        btn.MouseButton1Click:Connect(function()
                            for _, otherBtn in ipairs(optionButtons) do
                                if otherBtn:FindFirstChild("selectedLine") then
                                    otherBtn.selectedLine:Destroy()
                                end
                            end

                            local selectedLine = Instance.new("Frame")
                            selectedLine.Name = "selectedLine"
                            selectedLine.Size = UDim2.new(0, 3, 1, 0)
                            selectedLine.Position = UDim2.new(0, 0, 0, 0)
                            selectedLine.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
                            selectedLine.BorderSizePixel = 0
                            selectedLine.Parent = btn

                            local lineCorner = Instance.new("UICorner")
                            lineCorner.CornerRadius = UDim.new(0, 2)
                            lineCorner.Parent = selectedLine

                            selectedLabel.Text = btn.Text
                            Callback(btn.Text)
                            table.insert(Lib.UsageHistory, {element = "Dropdown", name = Name, option = btn.Text, time = tick()})
                        end)

                        table.insert(optionButtons, btn)
                    end
                    updateCanvasSize()
                end,
                SetSelected = function(text)
                    selectedLabel.Text = text
                end,
                GetSelected = function()
                    return selectedLabel.Text
                end,
                Destroy = function()
                    dropdownFrame:Destroy()
                end,
                Show = function()
                    dropdownFrame.Visible = true
                end,
                Hide = function()
                    dropdownFrame.Visible = false
                end
            }
        end

        table.insert(window.Tabs, tab)
        return tab
    end

    -- Drag & Drop
    local dragging = false
    local dragStart = nil
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position - mainFrame.AbsolutePosition
        end
    end)
    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local newPos = input.Position - dragStart
            mainFrame.Position = UDim2.new(0, newPos.X, 0, newPos.Y)
        end
    end)

    table.insert(Lib.Windows, window)
    return window
end

-- Exporta globalmente
if not _G.Lib then
    _G.Lib = setmetatable({}, Lib)
end

print("✅ Stelarium UI Library v4 carregada!")
