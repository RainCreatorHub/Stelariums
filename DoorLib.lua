print("█▀▀ █▀█ █▄░█ █▀▀ █▀▄▀█ █▀█ █░█ █▀█ █▀▀")
print("█▄▄ █▄█ █░▀█ █▄█ █░▀░█ █▀▀ ░█░ █▄█ ██▄")
-- UI Library by You - Para uso com loadstring

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Lib = {}
Lib.__index = Lib

-- Armazena janelas criadas
Lib.Windows = {}

-- Função principal: MakeWindow
function Lib:MakeWindow(config)
    config = config or {}
    local title = config.Title or "Nova Janela"
    local subtitle = config.Subtitle or ""
    local keyEnabled = config.Key or false
    local keySystem = config.KeySystem or {}
    local sizeConfig = config.Size or {}

    -- Configurações de tamanho
    local minSize = sizeConfig.MinSize or {400, 300}
    local maxSize = sizeConfig.MaxSize or {600, 500}
    local defaultSize = sizeConfig.DefaultSize or {450, 330}
    local resizable = sizeConfig.Resizable or false

    -- KeySystem
    local validKeys = keySystem.Key or {}
    local getKeyUrl = keySystem.GetKey or ""
    local keyTitle = keySystem.Title or "Insira sua chave"
    local keyDesc = keySystem.Desc or "Chave necessária para acessar"
    local rainbowTitle = keySystem.Rainbow or false

    -- Verifica se precisa de chave
    if keyEnabled and #validKeys > 0 then
        local hasAccess = false
        for _, savedKey in pairs(getreg() or {}) do
            if table.find(validKeys, savedKey) then
                hasAccess = true
                break
            end
        end

        if not hasAccess then
            -- Mostra UI de inserção de chave
            local keyGui = Instance.new("ScreenGui")
            keyGui.Name = "KeyAuth"
            keyGui.ResetOnSpawn = false
            keyGui.Parent = PlayerGui

            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0, 300, 0, 200)
            frame.Position = UDim2.new(0.5, -150, 0.5, -100)
            frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            frame.BorderSizePixel = 0
            frame.Parent = keyGui

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 8)
            corner.Parent = frame

            local stroke = Instance.new("UIStroke")
            stroke.Thickness = 1
            stroke.Color = Color3.fromRGB(0,0,0)
            stroke.Parent = frame

            local titleLabel = Instance.new("TextLabel")
            titleLabel.Size = UDim2.new(1, 0, 0, 30)
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
            descLabel.Size = UDim2.new(1, -20, 0, 30)
            descLabel.Position = UDim2.new(0, 10, 0, 40)
            descLabel.BackgroundTransparency = 1
            descLabel.Text = keyDesc
            descLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            descLabel.Font = Enum.Font.Gotham
            descLabel.TextSize = 14
            descLabel.TextWrapped = true
            descLabel.Parent = frame

            local textBox = Instance.new("TextBox")
            textBox.Size = UDim2.new(1, -20, 0, 30)
            textBox.Position = UDim2.new(0, 10, 0, 90)
            textBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            textBox.PlaceholderText = "Digite sua chave..."
            textBox.ClearTextOnFocus = false
            textBox.Font = Enum.Font.Gotham
            textBox.TextSize = 14
            textBox.Parent = frame

            local boxCorner = Instance.new("UICorner")
            boxCorner.CornerRadius = UDim.new(0, 6)
            boxCorner.Parent = textBox

            local boxStroke = Instance.new("UIStroke")
            boxStroke.Thickness = 1
            boxStroke.Color = Color3.fromRGB(0,0,0)
            boxStroke.Parent = textBox

            local submitBtn = Instance.new("TextButton")
            submitBtn.Size = UDim2.new(1, -20, 0, 30)
            submitBtn.Position = UDim2.new(0, 10, 0, 130)
            submitBtn.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
            submitBtn.Text = "Verificar"
            submitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            submitBtn.Font = Enum.Font.GothamBold
            submitBtn.TextSize = 14
            submitBtn.Parent = frame

            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = submitBtn

            local btnStroke = Instance.new("UIStroke")
            btnStroke.Thickness = 1
            btnStroke.Color = Color3.fromRGB(0,0,0)
            btnStroke.Parent = submitBtn

            submitBtn.MouseButton1Click:Connect(function()
                local input = textBox.Text
                if table.find(validKeys, input) then
                    -- Salva chave (simulação)
                    local reg = getreg() or {}
                    table.insert(reg, input)
                    setreg(reg)

                    -- Fecha e continua
                    keyGui:Destroy()
                    hasAccess = true
                else
                    textBox.Text = ""
                    textBox.PlaceholderText = "Chave inválida!"
                    spawn(function()
                        task.wait(2)
                        textBox.PlaceholderText = "Digite sua chave..."
                    end)
                end
            end)

            -- Aguarda até ter acesso
            repeat task.wait(0.1) until hasAccess
        end
    end

    -- Cria a janela principal
    local window = {}

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "Window_" .. #Lib.Windows + 1
    screenGui.ResetOnSpawn = true
    screenGui.Parent = PlayerGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, defaultSize[1], 0, defaultSize[2])
    mainFrame.Position = UDim2.new(0.5, -defaultSize[1]/2, 0.5, -defaultSize[2]/2)
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
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame

    local titleBarCorner = Instance.new("UICorner")
    titleBarCorner.CornerRadius = UDim.new(0, 8)
    titleBarCorner.Parent = titleBar

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -70, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar

    local subtitleLabel = Instance.new("TextLabel")
    subtitleLabel.Size = UDim2.new(1, -20, 0, 15)
    subtitleLabel.Position = UDim2.new(0, 10, 0, 35)
    subtitleLabel.BackgroundTransparency = 1
    subtitleLabel.Text = subtitle
    subtitleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    subtitleLabel.Font = Enum.Font.Gotham
    subtitleLabel.TextSize = 12
    subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    subtitleLabel.Parent = mainFrame

    -- Botão de fechar
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 25, 0, 25)
    closeButton.Position = UDim2.new(1, -30, 0, 2)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    closeButton.Text = "✕"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 16
    closeButton.Parent = titleBar

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeButton

    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    -- Conteúdo da janela (onde os elementos serão adicionados)
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Size = UDim2.new(1, 0, 1, -60)
    contentFrame.Position = UDim2.new(0, 0, 0, 60)
    contentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    contentFrame.BorderSizePixel = 0
    contentFrame.ScrollBarThickness = 4
    contentFrame.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
    contentFrame.Parent = mainFrame

    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 5)
    contentLayout.Parent = contentFrame

    -- Sistema de Redimensionamento
    if resizable then
        local resizeHandle = Instance.new("TextButton")
        resizeHandle.Size = UDim2.new(0, 15, 0, 15)
        resizeHandle.Position = UDim2.new(1, -15, 1, -15)
        resizeHandle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        resizeHandle.Text = "⬍"
        resizeHandle.TextColor3 = Color3.fromRGB(200, 200, 200)
        resizeHandle.Font = Enum.Font.Gotham
        resizeHandle.TextSize = 12
        resizeHandle.BorderSizePixel = 0
        resizeHandle.Parent = mainFrame

        local isResizing = false
        local startPos, startSize

        resizeHandle.MouseButton1Down:Connect(function()
            isResizing = true
            startPos = UserInputService:GetMouseLocation()
            startSize = mainFrame.Size
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement and isResizing then
                local delta = Vector2.new(input.Position.X - startPos.X, input.Position.Y - startPos.Y)
                local newSizeX = math.clamp(startSize.X.Offset + delta.X, minSize[1], maxSize[1])
                local newSizeY = math.clamp(startSize.Y.Offset + delta.Y, minSize[2], maxSize[2])

                mainFrame.Size = UDim2.new(0, newSizeX, 0, newSizeY)
                contentFrame.Size = UDim2.new(1, 0, 1, -60) -- Ajusta automaticamente
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isResizing = false
            end
        end)
    end

    -- DRAG & DROP da janela
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

    -- Dropdown API (reutilizando o que você já tinha)
    function window:AddDropdown(config)
        config = config or {}
        local dropdownTitle = config.Title or "Dropdown"
        local options = config.Options or {"Opção 1", "Opção 2"}
        local onSelect = config.OnSelect or function() end

        -- Reutiliza o dropdown que você já fez, mas dentro do contentFrame
        -- Vamos adaptar para caber na janela

        local dropdownFrame = Instance.new("TextButton")
        dropdownFrame.Size = UDim2.new(1, -20, 0, 30)
        dropdownFrame.Position = UDim2.new(0, 10, 0, 0)
        dropdownFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        dropdownFrame.Text = ""
        dropdownFrame.Parent = contentFrame

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
        dropdownLabel.Text = dropdownTitle
        dropdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        dropdownLabel.Font = Enum.Font.Gotham
        dropdownLabel.TextSize = 14
        dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
        dropdownLabel.Parent = dropdownFrame

        local selectedContainer = Instance.new("Frame")
        selectedContainer.Size = UDim2.new(0, 50, 0, 20)
        selectedContainer.Position = UDim2.new(1, -60, 0.5, -10)
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
        selectedLabel.Text = ""
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

        for _, option in pairs(options) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -10, 0, 25)
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
                onSelect(btn.Text)
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
                optionsFrame:TweenSize(UDim2.new(1,0,0,math.min(#optionButtons*27,150)), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
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

        return {
            SetOptions = function(newOptions)
                for _, btn in ipairs(optionButtons) do
                    btn:Destroy()
                end
                optionButtons = {}

                for _, option in pairs(newOptions) do
                    local btn = Instance.new("TextButton")
                    btn.Size = UDim2.new(1, -10, 0, 25)
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
                        onSelect(btn.Text)
                    end)

                    table.insert(optionButtons, btn)
                end
                updateCanvasSize()
            end
        }
    end

    -- Adiciona janela ao registro
    table.insert(Lib.Windows, window)

    return window
end

-- Simula registro de chaves (em jogo real, use DataStore ou HttpService)
local fakeRegistry = {}
function getreg() return fakeRegistry end
function setreg(t) fakeRegistry = t end

-- Exporta globalmente
if not _G.Lib then
    _G.Lib = setmetatable({}, Lib)
end

print("✅ UI Library carregada! Use: Lib:MakeWindow({...})")
