--[[
Ia: Qwen
Model: Mais avançado
Tipo: Grátis
]]
--// DoorLib — Biblioteca UI Moderna para Roblox — v1.0

local DoorLib = {}

-- Serviços
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Util
local function create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        obj[k] = v
    end
    return obj
end

-- Temas
local Themes = {
    Dark = {
        Main = Color3.fromRGB(25, 25, 35),
        TitleBar = Color3.fromRGB(20, 20, 30),
        TabContainer = Color3.fromRGB(30, 30, 40),
        TabButton = Color3.fromRGB(35, 35, 45),
        Content = Color3.fromRGB(30, 30, 45),
        PlayerInfo = Color3.fromRGB(35, 35, 45),
        Accent = Color3.fromRGB(0, 122, 255),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(190, 190, 210),
        DisabledText = Color3.fromRGB(180, 180, 180),
        Border = Color3.fromRGB(60, 60, 80),
        Scrollbar = Color3.fromRGB(60, 60, 70)
    },
    Light = {
        Main = Color3.fromRGB(240, 240, 245),
        TitleBar = Color3.fromRGB(230, 230, 240),
        TabContainer = Color3.fromRGB(220, 220, 230),
        TabButton = Color3.fromRGB(210, 210, 220),
        Content = Color3.fromRGB(215, 215, 225),
        PlayerInfo = Color3.fromRGB(210, 210, 220),
        Accent = Color3.fromRGB(0, 102, 204),
        Text = Color3.fromRGB(30, 30, 30),
        SubText = Color3.fromRGB(80, 80, 90),
        DisabledText = Color3.fromRGB(150, 150, 150),
        Border = Color3.fromRGB(180, 180, 190),
        Scrollbar = Color3.fromRGB(170, 170, 180)
    },
    Blue = {
        Main = Color3.fromRGB(15, 25, 45),
        TitleBar = Color3.fromRGB(20, 30, 50),
        TabContainer = Color3.fromRGB(25, 35, 55),
        TabButton = Color3.fromRGB(30, 40, 60),
        Content = Color3.fromRGB(25, 35, 55),
        PlayerInfo = Color3.fromRGB(30, 40, 60),
        Accent = Color3.fromRGB(0, 162, 255),
        Text = Color3.fromRGB(240, 245, 255),
        SubText = Color3.fromRGB(190, 200, 220),
        DisabledText = Color3.fromRGB(160, 170, 190),
        Border = Color3.fromRGB(50, 70, 100),
        Scrollbar = Color3.fromRGB(60, 80, 110)
    }
}

-- Armazenamento
DoorLib.Windows = {}

-- Função principal: MakeWindow
function DoorLib:MakeWindow(config)
    config = config or {}
    local theme = Themes[config.Theme or "Dark"]
    local player = Players.LocalPlayer

    -- Remove GUI anterior (se tiver mesmo nome)
    local existing = CoreGui:FindFirstChild("DoorLib_" .. (config.Title or "Window"))
    if existing then
        existing:Destroy()
    end

    -- ScreenGui
    local screenGui = create("ScreenGui", {
        Name = "DoorLib_" .. (config.Title or "Window"),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = CoreGui
    })

    -- Tamanhos
    local minSize = config.MinSize or UDim2.new(0, 300, 0, 200)
    local maxSize = config.MaxSize or UDim2.new(0, 800, 0, 600)
    local defaultSize = config.DefaultSize or UDim2.new(0, 500, 0, 400)

    -- Frame principal
    local mainFrame = create("Frame", {
        Size = defaultSize,
        Position = UDim2.new(0.5, -defaultSize.X.Offset/2, 0.5, -defaultSize.Y.Offset/2),
        BackgroundTransparency = 0.7,
        BackgroundColor3 = theme.Main,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = 1,
        Parent = screenGui
    })

    create("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = mainFrame
    })

    create("UIStroke", {
        Color = Color3.fromRGB(0, 0, 0),
        Thickness = 1.5,
        Transparency = 0.65,
        Parent = mainFrame
    })

    -- Barra de título (42px)
    local titleBar = create("Frame", {
        Size = UDim2.new(1, 0, 0, 42),
        BackgroundTransparency = 0.3,
        BackgroundColor3 = theme.TitleBar,
        BorderSizePixel = 0,
        ZIndex = 10,
        Parent = mainFrame
    })

    create("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = titleBar
    })

    -- Ícone
    local icon = create("Frame", {
        Size = UDim2.new(0, 14, 0, 14),
        Position = UDim2.new(0, 12, 0, 10),
        BackgroundTransparency = 0,
        BackgroundColor3 = theme.Accent,
        BorderSizePixel = 0,
        Parent = titleBar
    })

    create("UICorner", {
        CornerRadius = UDim.new(0, 7),
        Parent = icon
    })

    -- Título
    create("TextLabel", {
        Size = UDim2.new(0, 200, 0, 20),
        Position = UDim2.new(0, 32, 0, 8),
        BackgroundTransparency = 1,
        Text = config.Title or "Window",
        TextColor3 = theme.Text,
        TextSize = 14,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleBar
    })

    -- Subtítulo
    create("TextLabel", {
        Size = UDim2.new(0, 180, 0, 16),
        Position = UDim2.new(0, 32, 0, 26),
        BackgroundTransparency = 1,
        Text = config.SubTitle or "",
        TextColor3 = theme.SubText,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleBar
    })

    -- Botões de controle
    local minimizeBtn = create("TextButton", {
        Size = UDim2.new(0, 35, 0, 30),
        Position = UDim2.new(1, -75, 0, 6),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 11,
        Parent = titleBar
    })

    local minIcon = create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "–",
        TextColor3 = theme.DisabledText,
        TextSize = 18,
        Font = Enum.Font.SourceSans,
        Parent = minimizeBtn
    })

    local closeBtn = create("TextButton", {
        Size = UDim2.new(0, 35, 0, 30),
        Position = UDim2.new(1, -40, 0, 6),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 11,
        Parent = titleBar
    })

    local closeIcon = create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "X",
        TextColor3 = Color3.fromRGB(255, 90, 90),
        TextSize = 18,
        Font = Enum.Font.SourceSansBold,
        Parent = closeBtn
    })

    -- Hover
    local function simpleHover(btn, icon, normal, hover, click)
        btn.MouseEnter:Connect(function()
            icon.TextColor3 = hover
        end)
        btn.MouseLeave:Connect(function()
            icon.TextColor3 = normal
        end)
        btn.MouseButton1Down:Connect(function()
            icon.TextColor3 = click
        end)
    end

    simpleHover(minimizeBtn, minIcon, theme.DisabledText, theme.Text, Color3.fromRGB(150, 150, 150))
    simpleHover(closeBtn, closeIcon, Color3.fromRGB(255, 90, 90), Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 50, 50))

    -- Fechar
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    -- Conteúdo principal
    local contentFrame = create("Frame", {
        Size = UDim2.new(1, 0, 1, -42),
        Position = UDim2.new(0, 0, 0, 42),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = mainFrame
    })

    -- Container das abas
    local tabContainer = create("Frame", {
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 0.3,
        BackgroundColor3 = theme.TabContainer,
        BorderSizePixel = 0.5,
        ClipsDescendants = true,
        Parent = contentFrame
    })

    create("UIStroke", {
        Color = theme.Border,
        Thickness = 1,
        Transparency = 0.5,
        Parent = tabContainer
    })

    -- Label "Tabs"
    create("TextLabel", {
        Size = UDim2.new(0, 100, 0, 20),
        Position = UDim2.new(0.05, 0, 0, 5),
        BackgroundTransparency = 1,
        Text = "Tabs",
        TextColor3 = theme.SubText,
        TextSize = 14,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = tabContainer
    })

    -- Linhas divisoras
    create("Frame", { Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 0, 28), BackgroundTransparency = 0, BackgroundColor3 = theme.Border, Parent = tabContainer })
    create("Frame", { Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 0, 67), BackgroundTransparency = 0, BackgroundColor3 = theme.Border, Parent = tabContainer })
    create("Frame", { Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -85), BackgroundTransparency = 0, BackgroundColor3 = theme.Border, Parent = tabContainer })

    -- SearchBar
    local searchBar = create("TextBox", {
        Size = UDim2.new(0.9, 0, 0, 30),
        Position = UDim2.new(0.05, 0, 0, 32),
        BackgroundTransparency = 0.4,
        BackgroundColor3 = theme.TabButton,
        BorderSizePixel = 0,
        PlaceholderText = "Buscar aba...",
        Text = "",
        TextColor3 = theme.SubText,
        TextSize = 14,
        Font = Enum.Font.Gotham,
        ClearTextOnFocus = false,
        Parent = tabContainer
    })

    create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = searchBar
    })

    -- ScrollingFrame das abas
    local tabScroll = create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, -155),
        Position = UDim2.new(0, 0, 0, 72),
        BackgroundTransparency = 1,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = theme.Scrollbar,
        HorizontalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
        Parent = tabContainer
    })

    tabScroll.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            input:Capture()
        end
    end)

    local listLayout = create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        Padding = UDim.new(0, 5),
        Parent = tabScroll
    })

    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabScroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
    end)

    -- Player Info
    local playerProfile = create("Frame", {
        Size = UDim2.new(0, 170, 0, 55),
        Position = UDim2.new(0, 15, 1, -70),
        BackgroundTransparency = 0.2,
        BackgroundColor3 = theme.PlayerInfo,
        BorderSizePixel = 0,
        Parent = tabContainer
    })

    create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = playerProfile
    })

    create("UIStroke", {
        Color = Color3.fromRGB(80, 80, 100),
        Thickness = 1,
        Transparency = 0.5,
        Parent = playerProfile
    })

    -- Avatar
    local avatar = create("ImageLabel", {
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(0, 8, 0, 11),
        BackgroundTransparency = 1,
        Image = "rbxasset://textures/ui/DefaultAvatar.png",
        Parent = playerProfile
    })

    create("UICorner", {
        CornerRadius = UDim.new(0, 16),
        Parent = avatar
    })

    local success, thumbnail = pcall(function()
        return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
    end)
    if success and thumbnail then
        avatar.Image = thumbnail
    end

    -- DisplayName
    create("TextLabel", {
        Size = UDim2.new(0, 120, 0, 18),
        Position = UDim2.new(0, 45, 0, 8),
        BackgroundTransparency = 1,
        Text = player.DisplayName,
        TextColor3 = theme.Text,
        TextSize = 14,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = playerProfile
    })

    -- Username
    create("TextLabel", {
        Size = UDim2.new(0, 120, 0, 16),
        Position = UDim2.new(0, 45, 0, 28),
        BackgroundTransparency = 1,
        Text = "@" .. player.Name,
        TextColor3 = theme.SubText,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = playerProfile
    })

    -- Conteúdo das abas
    local tabContentFrame = create("Frame", {
        Size = UDim2.new(1, -200, 1, 0),
        Position = UDim2.new(0, 200, 0, 0),
        BackgroundTransparency = 0.3,
        BackgroundColor3 = theme.Content,
        BorderSizePixel = 0,
        Parent = contentFrame
    })

    create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = tabContentFrame
    })

    create("UIStroke", {
        Color = Color3.fromRGB(70, 90, 120),
        Thickness = 1,
        Transparency = 0.4,
        Parent = tabContentFrame
    })

    -- Conteúdo inicial
    local currentContent = create("TextLabel", {
        Size = UDim2.new(0.9, 0, 0.8, 0),
        Position = UDim2.new(0.05, 0, 0.1, 0),
        BackgroundTransparency = 1,
        Text = "✨ Bem-vindo!\nSelecione uma aba para ver o conteúdo.",
        TextColor3 = theme.SubText,
        TextTransparency = 1,
        TextSize = 15,
        Font = Enum.Font.Gotham,
        TextWrapped = true,
        Parent = tabContentFrame
    })

    TweenService:Create(currentContent, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0
    }):Play()

    -- Estado
    local tabButtons = {}
    local currentTab = nil
    local isMinimized = false

    -- Função para filtrar abas
    local function filterTabs(query)
        query = string.lower(query or "")
        for _, btn in ipairs(tabButtons) do
            local tabName = btn.Name
            local isVisible = query == "" or string.find(string.lower(tabName), query, 1, true)
            btn.Visible = isVisible
        end
        tabScroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
    end

    searchBar.Changed:Connect(function(prop)
        if prop == "Text" then
            filterTabs(searchBar.Text)
        end
    end)

    -- Função de seleção de aba
    local function selectTab(targetBtn, data)
        if currentTab == targetBtn then return end

        if currentTab then
            local oldBg = currentTab:FindFirstChild("btnBg")
            local oldBorder = oldBg and oldBg:FindFirstChild("leftBorder")
            local oldIconText = currentTab:FindFirstChild("iconText")
            local oldMiniIcon = currentTab:FindFirstChild("miniIcon")

            if oldBg then TweenService:Create(oldBg, TweenInfo.new(0.15), { BackgroundTransparency = 0.5 }):Play() end
            if oldIconText then TweenService:Create(oldIconText, TweenInfo.new(0.15), { TextColor3 = theme.SubText }):Play() end
            if oldMiniIcon then TweenService:Create(oldMiniIcon, TweenInfo.new(0.15), { TextColor3 = theme.SubText }):Play() end
            if oldBorder then TweenService:Create(oldBorder, TweenInfo.new(0.2), { Size = UDim2.new(0, 3, 0, 0), BackgroundTransparency = 1 }):Play() end
        end

        currentTab = targetBtn

        local btnBg = targetBtn:FindFirstChild("btnBg")
        local leftBorder = btnBg and btnBg:FindFirstChild("leftBorder")
        local iconText = targetBtn:FindFirstChild("iconText")
        local miniIcon = targetBtn:FindFirstChild("miniIcon")

        if btnBg then TweenService:Create(btnBg, TweenInfo.new(0.15), { BackgroundTransparency = 0.6 }):Play() end
        if iconText then TweenService:Create(iconText, TweenInfo.new(0.15), { TextColor3 = theme.Text }):Play() end
        if miniIcon then TweenService:Create(miniIcon, TweenInfo.new(0.15), { TextColor3 = theme.Accent }):Play() end

        if leftBorder then
            leftBorder.BackgroundTransparency = 1
            leftBorder.Size = UDim2.new(0, 3, 0, 0)
            TweenService:Create(leftBorder, TweenInfo.new(0.25), { Size = UDim2.new(0, 3, 1, 0), BackgroundTransparency = 0 }):Play()
        end

        if currentContent then
            local fadeOut = TweenService:Create(currentContent, TweenInfo.new(0.2), { TextTransparency = 1 })
            fadeOut:Play()
            fadeOut.Completed:Wait()
            currentContent:Destroy()
        end

        currentContent = create("TextLabel", {
            Size = UDim2.new(0.9, 0, 0.8, 0),
            Position = UDim2.new(0.05, 0, 0.1, 0),
            BackgroundTransparency = 1,
            Text = "📌 " .. data.name .. "\n\n" .. (data.desc or ""),
            TextColor3 = theme.SubText,
            TextTransparency = 1,
            TextSize = 15,
            Font = Enum.Font.Gotham,
            TextWrapped = true,
            Parent = tabContentFrame
        })

        TweenService:Create(currentContent, TweenInfo.new(0.3), { TextTransparency = 0 }):Play()
    end

    -- Window Object
    local Window = {
        MainFrame = mainFrame,
        Tabs = {},
        Theme = theme
    }

    -- Método: MakeTab
    function Window:MakeTab(tabConfig)
        tabConfig = tabConfig or {}
        local data = {
            name = tabConfig.Name or "Tab",
            icon = tabConfig.Icon or "🔹",
            desc = tabConfig.Desc or "Conteúdo da aba."
        }

        local btn = create("TextButton", {
            Size = UDim2.new(1, -16, 0, 40),
            Position = UDim2.new(0, 1, 0, 0),
            BackgroundTransparency = 1,
            Text = "",
            LayoutOrder = #tabButtons + 1,
            Name = data.name,
            Parent = tabScroll
        })

        local btnBg = create("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 0.5,
            BackgroundColor3 = theme.TabButton,
            BorderSizePixel = 0,
            Parent = btn
        })

        create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btnBg })
        create("UIStroke", { Color = Color3.fromRGB(80, 80, 100), Thickness = 1, Transparency = 0.5, Parent = btnBg })

        local leftBorder = create("Frame", {
            Size = UDim2.new(0, 3, 0, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            BackgroundColor3 = theme.Accent,
            BorderSizePixel = 0,
            Parent = btnBg
        })

        create("UICorner", { CornerRadius = UDim.new(0, 1.5), Parent = leftBorder })

        local miniIcon = create("TextLabel", {
            Size = UDim2.new(0, 30, 1, 0),
            Position = UDim2.new(0, 8, 0, 0),
            BackgroundTransparency = 1,
            Text = data.icon,
            TextColor3 = theme.SubText,
            TextSize = 18,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Center,
            Parent = btn
        })

        local iconText = create("TextLabel", {
            Size = UDim2.new(0.9, 0, 1, 0),
            Position = UDim2.new(0, 40, 0, 0),
            BackgroundTransparency = 1,
            Text = data.name,
            TextColor3 = theme.SubText,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = btn
        })

        iconText.Name = "iconText"
        miniIcon.Name = "miniIcon"
        leftBorder.Name = "leftBorder"

        -- Hover
        btn.MouseEnter:Connect(function()
            if currentTab ~= btn then
                TweenService:Create(btnBg, TweenInfo.new(0.1), { BackgroundTransparency = 0.3 }):Play()
                TweenService:Create(iconText, TweenInfo.new(0.1), { TextColor3 = theme.Text }):Play()
                TweenService:Create(miniIcon, TweenInfo.new(0.1), { TextColor3 = theme.Text }):Play()
            end
        end)

        btn.MouseLeave:Connect(function()
            if currentTab ~= btn then
                TweenService:Create(btnBg, TweenInfo.new(0.1), { BackgroundTransparency = 0.5 }):Play()
                TweenService:Create(iconText, TweenInfo.new(0.1), { TextColor3 = theme.SubText }):Play()
                TweenService:Create(miniIcon, TweenInfo.new(0.1), { TextColor3 = theme.SubText }):Play()
            end
        end)

        -- Clique
        btn.MouseButton1Click:Connect(function()
            if not btn.Visible then return end
            selectTab(btn, data)
        end)

        table.insert(tabButtons, btn)

        if #tabButtons == 1 then
            task.spawn(function()
                wait(0.1)
                selectTab(btn, data)
            end)
        end

        -- Tab Object
        local Tab = {
            Button = btn,
            Name = data.name
        }

        -- Método: AddSection
        function Tab:AddSection(sectionConfig)
            sectionConfig = sectionConfig or {}
            -- Placeholder — você pode expandir com Frames, Labels, Buttons, Sliders, etc.
            -- Exemplo:
            local sectionLabel = create("TextLabel", {
                Size = UDim2.new(0.9, 0, 0, 24),
                Position = UDim2.new(0.05, 0, 0.05 + (#Window.Tabs * 0.1), 0),
                BackgroundTransparency = 1,
                Text = "🔹 " .. (sectionConfig.Name or "Section"),
                TextColor3 = theme.Text,
                TextSize = 14,
                Font = Enum.Font.GothamSemibold,
                Parent = tabContentFrame
            })
            return sectionLabel
        end

        table.insert(Window.Tabs, Tab)
        return Tab
    end

    -- Minimizar
    minimizeBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        contentFrame.Visible = not isMinimized
        if isMinimized then
            mainFrame.Size = UDim2.new(0, mainFrame.Size.X.Offset, 0, 42)
            minIcon.Text = "+"
        else
            mainFrame.Size = defaultSize
            minIcon.Text = "–"
        end
    end)

    -- Arraste
    local dragging = false
    local dragStart = nil
    local startPos = nil

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)

    titleBar.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- Redimensionamento
    if config.Resizable ~= false then
        local resizeHandle = create("TextButton", {
            Size = UDim2.new(1, 0, 0, 50),
            Position = UDim2.new(0, 0, 1, -50),
            BackgroundTransparency = 1,
            Text = "",
            ZIndex = 2,
            Parent = mainFrame
        })

        resizeHandle.MouseEnter:Connect(function()
            if not isMinimized then
                UserInputService.MouseIcon = "rbxasset://SystemCursors/SizeNS"
            end
        end)

        resizeHandle.MouseLeave:Connect(function()
            UserInputService.MouseIcon = "rbxasset://SystemCursors/Arrow"
        end)

        resizeHandle.InputBegan:Connect(function(input)
            if isMinimized or input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
            local startResize = input.Position
            local startSize = mainFrame.Size
            local conn = UserInputService.InputChanged:Connect(function(input2)
                if input2.UserInputType == Enum.UserInputType.MouseMovement then
                    local delta = input2.Position.Y - startResize.Y
                    local newHeight = math.clamp(startSize.Y.Offset + delta, minSize.Y.Offset, maxSize.Y.Offset)
                    mainFrame.Size = UDim2.new(startSize.X.Scale, startSize.X.Offset, 0, newHeight)
                end
            end)
            UserInputService.InputEnded:Connect(function(input2)
                if input2.UserInputType == Enum.UserInputType.MouseButton1 then
                    conn:Disconnect()
                end
            end)
        end)
    end

    table.insert(DoorLib.Windows, Window)
    return Window
end

return DoorLib
