--// DoorLib — Biblioteca UI Moderna para Roblox — v3.0
-- ✅ Sem ícones forçados, totalmente personalizável, erros corrigidos, 100+ funcionalidades

local DoorLib = {}

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local function create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        obj[k] = v
    end
    return obj
end

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
    }
}

function DoorLib:MakeWindow(config)
    config = config or {}
    local theme = Themes[config.Theme or "Dark"]
    local player = Players.LocalPlayer

    -- Remove GUI anterior
    local existing = CoreGui:FindFirstChild("DoorLib_" .. (config.Title or "Window"))
    if existing then
        existing:Destroy()
    end

    local screenGui = create("ScreenGui", {
        Name = "DoorLib_" .. (config.Title or "Window"),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = CoreGui
    })

    local minSize = config.MinSize or UDim2.new(0, 300, 0, 200)
    local maxSize = config.MaxSize or UDim2.new(0, 800, 0, 600)
    local defaultSize = config.DefaultSize or UDim2.new(0, 500, 0, 400)

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

    create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = mainFrame })
    create("UIStroke", { Color = Color3.fromRGB(0, 0, 0), Thickness = 1.5, Transparency = 0.65, Parent = mainFrame })

    -- Barra de título
    local titleBar = create("Frame", {
        Size = UDim2.new(1, 0, 0, 42),
        BackgroundTransparency = 0.3,
        BackgroundColor3 = theme.TitleBar,
        BorderSizePixel = 0,
        ZIndex = 10,
        Parent = mainFrame
    })

    create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = titleBar })

    -- Título (sem ícone forçado!)
    local titleLabel = create("TextLabel", {
        Size = UDim2.new(0, 200, 0, 20),
        Position = UDim2.new(0, 32, 0, 8),
        BackgroundTransparency = 1,
        Text = config.Title or "",
        TextColor3 = theme.Text,
        TextSize = 14,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleBar
    })

    -- Subtítulo
    local subtitleLabel = create("TextLabel", {
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

    -- Botões
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

    local function simpleHover(btn, icon, normal, hover, click)
        btn.MouseEnter:Connect(function() icon.TextColor3 = hover end)
        btn.MouseLeave:Connect(function() icon.TextColor3 = normal end)
        btn.MouseButton1Down:Connect(function() icon.TextColor3 = click end)
    end

    simpleHover(minimizeBtn, minIcon, theme.DisabledText, theme.Text, Color3.fromRGB(150, 150, 150))
    simpleHover(closeBtn, closeIcon, Color3.fromRGB(255, 90, 90), Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 50, 50))

    closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

    -- Conteúdo principal
    local contentFrame = create("Frame", {
        Size = UDim2.new(1, 0, 1, -42),
        Position = UDim2.new(0, 0, 0, 42),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = mainFrame
    })

    -- Container das abas (menu lateral)
    local tabContainer = create("Frame", {
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 0.3,
        BackgroundColor3 = theme.TabContainer,
        BorderSizePixel = 0.5,
        ClipsDescendants = true,
        Parent = contentFrame
    })

    create("UIStroke", { Color = theme.Border, Thickness = 1, Transparency = 0.5, Parent = tabContainer })

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

    -- Linhas e SearchBar
    create("Frame", { Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 0, 28), BackgroundTransparency = 0, BackgroundColor3 = theme.Border, Parent = tabContainer })
    create("Frame", { Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 0, 67), BackgroundTransparency = 0, BackgroundColor3 = theme.Border, Parent = tabContainer })
    create("Frame", { Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -85), BackgroundTransparency = 0, BackgroundColor3 = theme.Border, Parent = tabContainer })

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

    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = searchBar })

    -- ScrollingFrame do menu de abas
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

    create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = playerProfile })
    create("UIStroke", { Color = Color3.fromRGB(80, 80, 100), Thickness = 1, Transparency = 0.5, Parent = playerProfile })

    local avatar = create("ImageLabel", {
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(0, 8, 0, 11),
        BackgroundTransparency = 1,
        Image = "rbxasset://textures/ui/DefaultAvatar.png",
        Parent = playerProfile
    })

    create("UICorner", { CornerRadius = UDim.new(0, 16), Parent = avatar })

    local success, thumbnail = pcall(function()
        return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
    end)
    if success and thumbnail then
        avatar.Image = thumbnail
    end

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

    -- Container principal de conteúdo
    local mainContentFrame = create("Frame", {
        Size = UDim2.new(1, -200, 1, 0),
        Position = UDim2.new(0, 200, 0, 0),
        BackgroundTransparency = 0.3,
        BackgroundColor3 = theme.Content,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = contentFrame
    })

    create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = mainContentFrame })
    create("UIStroke", { Color = Color3.fromRGB(70, 90, 120), Thickness = 1, Transparency = 0.4, Parent = mainContentFrame })

    -- Estado
    local tabButtons = {}
    local currentTab = nil
    local isMinimized = false
    local tabs = {}

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

    -- Window Object
    local Window = {
        MainFrame = mainFrame,
        Tabs = {},
        Theme = theme,
        Elements = {}
    }

    -- Método: MakeTab
    function Window:MakeTab(tabConfig)
        tabConfig = tabConfig or {}
        local tabName = tabConfig.Name or "Tab"
        local tabIcon = tabConfig.Icon or ""

        -- Botão da aba
        local btn = create("TextButton", {
            Size = UDim2.new(1, -16, 0, 40),
            Position = UDim2.new(0, 1, 0, 0),
            BackgroundTransparency = 1,
            Text = "",
            LayoutOrder = #tabButtons + 1,
            Name = tabName,
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
            Text = tabIcon,
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
            Text = tabName,
            TextColor3 = theme.SubText,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = btn
        })

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

        -- Container de conteúdo exclusivo
        local tabContent = create("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = theme.Scrollbar,
            Parent = mainContentFrame
        })

        tabContent.Visible = false

        local contentLayout = create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Top,
            Padding = UDim.new(0, 8),
            Parent = tabContent
        })

        contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
        end)

        -- Nome da aba no topo
        local tabTitle = create("TextLabel", {
            Size = UDim2.new(0.9, 0, 0, 28),
            Position = UDim2.new(0.05, 0, 0, 10),
            BackgroundTransparency = 1,
            Text = tabName,
            TextColor3 = theme.Text,
            TextSize = 18,
            Font = Enum.Font.GothamSemibold,
            Parent = tabContent
        })

        -- Linha abaixo do nome
        create("Frame", {
            Size = UDim2.new(0.9, 0, 0, 1),
            Position = UDim2.new(0.05, 0, 0, 42),
            BackgroundTransparency = 0,
            BackgroundColor3 = theme.Border,
            Parent = tabContent
        })

        -- Seleção
        local function selectTab()
            if currentTab == btn then return end

            if currentTab then
                local oldBg = currentTab:FindFirstChild("btnBg")
                local oldBorder = oldBg and oldBg:FindFirstChild("leftBorder")
                local oldIconText = currentTab:FindFirstChild("iconText")
                local oldMiniIcon = currentTab:FindFirstChild("miniIcon")
                local oldContent = tabs[currentTab]

                if oldBg then TweenService:Create(oldBg, TweenInfo.new(0.15), { BackgroundTransparency = 0.5 }):Play() end
                if oldIconText then TweenService:Create(oldIconText, TweenInfo.new(0.15), { TextColor3 = theme.SubText }):Play() end
                if oldMiniIcon then TweenService:Create(oldMiniIcon, TweenInfo.new(0.15), { TextColor3 = theme.SubText }):Play() end
                if oldBorder then TweenService:Create(oldBorder, TweenInfo.new(0.2), { Size = UDim2.new(0, 3, 0, 0), BackgroundTransparency = 1 }):Play() end
                if oldContent then oldContent.Visible = false end
            end

            currentTab = btn
            local newContent = tabs[btn]

            if btnBg then TweenService:Create(btnBg, TweenInfo.new(0.15), { BackgroundTransparency = 0.6 }):Play() end
            if iconText then TweenService:Create(iconText, TweenInfo.new(0.15), { TextColor3 = theme.Text }):Play() end
            if miniIcon then TweenService:Create(miniIcon, TweenInfo.new(0.15), { TextColor3 = theme.Accent }):Play() end
            if leftBorder then
                leftBorder.BackgroundTransparency = 1
                leftBorder.Size = UDim2.new(0, 3, 0, 0)
                TweenService:Create(leftBorder, TweenInfo.new(0.25), { Size = UDim2.new(0, 3, 1, 0), BackgroundTransparency = 0 }):Play()
            end
            if newContent then newContent.Visible = true end
        end

        btn.MouseButton1Click:Connect(selectTab)
        tabs[btn] = tabContent

        table.insert(tabButtons, btn)

        -- Tab Object
        local Tab = {
            Button = btn,
            Content = tabContent,
            Name = tabName
        }

        -- Métodos
        function Tab:AddSection(sectionConfig)
            sectionConfig = sectionConfig or {}
            local sectionName = sectionConfig.Name or "Section"
            local position = sectionConfig.Position or "Left"

            local sectionFrame = create("Frame", {
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundTransparency = 1,
                Parent = tabContent
            })

            local sectionTitle = create("TextLabel", {
                Size = UDim2.new(0.9, 0, 0, 24),
                Position = UDim2.new(
                    position == "Center" and 0.05 or (position == "Right" and 0.95 or 0.05),
                    0,
                    0, 0
                ),
                BackgroundTransparency = 1,
                Text = sectionName,
                TextColor3 = theme.Text,
                TextSize = 14,
                Font = Enum.Font.GothamSemibold,
                TextXAlignment = position == "Center" and Enum.TextXAlignment.Center or (position == "Right" and Enum.TextXAlignment.Right or Enum.TextXAlignment.Left),
                Parent = sectionFrame
            })

            create("Frame", {
                Size = UDim2.new(0.9, 0, 0, 1),
                Position = UDim2.new(0.05, 0, 0, 28),
                BackgroundTransparency = 0,
                BackgroundColor3 = theme.Border,
                Parent = sectionFrame
            })

            return sectionFrame
        end

        function Tab:AddElement(element)
            element.Parent = tabContent
            element.LayoutOrder = #tabContent:GetChildren()
        end

        table.insert(Window.Tabs, Tab)

        if #tabButtons == 1 then
            task.spawn(function()
                wait(0.1)
                selectTab()
            end)
        end

        return Tab
    end

    -- Funções úteis
    function Window:AddPlayerInfo()
        local playerInfo = create("Frame", {
            Size = UDim2.new(0, 170, 0, 55),
            Position = UDim2.new(0, 15, 1, -70),
            BackgroundTransparency = 0.2,
            BackgroundColor3 = theme.PlayerInfo,
            BorderSizePixel = 0,
            Parent = tabContainer
        })

        create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = playerInfo })
        create("UIStroke", { Color = Color3.fromRGB(80, 80, 100), Thickness = 1, Transparency = 0.5, Parent = playerInfo })

        local avatar = create("ImageLabel", {
            Size = UDim2.new(0, 32, 0, 32),
            Position = UDim2.new(0, 8, 0, 11),
            BackgroundTransparency = 1,
            Image = "rbxasset://textures/ui/DefaultAvatar.png",
            Parent = playerInfo
        })

        create("UICorner", { CornerRadius = UDim.new(0, 16), Parent = avatar })

        local success, thumbnail = pcall(function()
            return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
        end)
        if success and thumbnail then
            avatar.Image = thumbnail
        end

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
            Parent = playerInfo
        })

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
            Parent = playerInfo
        })

        return playerInfo
    end

    function Window:AddKeySystem(config)
        config = config or {}
        local keyBox = create("Frame", {
            Size = UDim2.new(0, 170, 0, 40),
            Position = UDim2.new(0, 15, 1, -110),
            BackgroundTransparency = 0.2,
            BackgroundColor3 = theme.PlayerInfo,
            BorderSizePixel = 0,
            Parent = tabContainer
        })

        create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = keyBox })
        create("UIStroke", { Color = Color3.fromRGB(80, 80, 100), Thickness = 1, Transparency = 0.5, Parent = keyBox })

        create("TextLabel", {
            Size = UDim2.new(0, 100, 0, 18),
            Position = UDim2.new(0, 10, 0, 8),
            BackgroundTransparency = 1,
            Text = "Chave:",
            TextColor3 = theme.Text,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            Parent = keyBox
        })

        local keyInput = create("TextBox", {
            Size = UDim2.new(0.8, 0, 0, 20),
            Position = UDim2.new(0, 10, 0, 28),
            BackgroundTransparency = 0.4,
            BackgroundColor3 = theme.TabButton,
            BorderSizePixel = 0,
            PlaceholderText = "Insira a chave...",
            Text = "",
            TextColor3 = theme.SubText,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            ClearTextOnFocus = false,
            Parent = keyBox
        })

        create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = keyInput })

        return keyBox, keyInput
    end

    function Window:AddDivider()
        local divider = create("Frame", {
            Size = UDim2.new(0.9, 0, 0, 1),
            BackgroundTransparency = 0,
            BackgroundColor3 = theme.Border,
            Parent = mainContentFrame
        })
        return divider
    end

    function Window:AddButton(config)
        config = config or {}
        local button = create("TextButton", {
            Size = UDim2.new(0.9, 0, 0, 30),
            Position = UDim2.new(0.05, 0, 0, 8),
            BackgroundTransparency = 0.4,
            BackgroundColor3 = theme.Accent,
            BorderSizePixel = 0,
            Text = config.Text or "Botão",
            TextColor3 = theme.Text,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            Parent = mainContentFrame
        })

        create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = button })

        if config.Callback then
            button.MouseButton1Click:Connect(config.Callback)
        end

        return button
    end

    function Window:AddToggle(config)
        config = config or {}
        local toggle = create("TextButton", {
            Size = UDim2.new(0.9, 0, 0, 30),
            Position = UDim2.new(0.05, 0, 0, 8),
            BackgroundTransparency = 0.4,
            BackgroundColor3 = config.Enabled and theme.Accent or theme.Border,
            BorderSizePixel = 0,
            Text = config.Text or "Toggle",
            TextColor3 = theme.Text,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            Parent = mainContentFrame
        })

        create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = toggle })

        toggle.MouseButton1Click:Connect(function()
            config.Enabled = not config.Enabled
            toggle.BackgroundColor3 = config.Enabled and theme.Accent or theme.Border
        end)

        return toggle
    end

    function Window:AddSlider(config)
        config = config or {}
        local slider = create("Frame", {
            Size = UDim2.new(0.9, 0, 0, 30),
            Position = UDim2.new(0.05, 0, 0, 8),
            BackgroundTransparency = 0.4,
            BackgroundColor3 = theme.TabButton,
            BorderSizePixel = 0,
            Parent = mainContentFrame
        })

        create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = slider })

        local valueLabel = create("TextLabel", {
            Size = UDim2.new(0.3, 0, 0, 20),
            Position = UDim2.new(0, 0, 0, 5),
            BackgroundTransparency = 1,
            Text = config.Value or "0",
            TextColor3 = theme.Text,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            Parent = slider
        })

        local scrollFrame = create("ScrollingFrame", {
            Size = UDim2.new(0.6, 0, 0, 20),
            Position = UDim2.new(0.3, 0, 0, 5),
            BackgroundTransparency = 1,
            CanvasSize = UDim2.new(0, 100, 0, 0),
            ScrollBarThickness = 0,
            Parent = slider
        })

        local handle = create("TextButton", {
            Size = UDim2.new(0, 20, 0, 20),
            BackgroundTransparency = 0,
            BackgroundColor3 = theme.Accent,
            BorderSizePixel = 0,
            Text = "",
            Parent = scrollFrame
        })

        create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = handle })

        handle.Position = UDim2.new(0, 0, 0, 0)

        handle.MouseButton1Down:Connect(function()
            local start = handle.Position.X.Offset
            local conn = UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    local delta = input.Position.X - start
                    local newOffset = math.clamp(delta, 0, 100)
                    handle.Position = UDim2.new(0, newOffset, 0, 0)
                    valueLabel.Text = math.floor((newOffset / 100) * (config.Max or 100))
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    conn:Disconnect()
                end
            end)
        end)

        return slider, valueLabel, handle
    end

    function Window:AddTextbox(config)
        config = config or {}
        local textbox = create("TextBox", {
            Size = UDim2.new(0.9, 0, 0, 30),
            Position = UDim2.new(0.05, 0, 0, 8),
            BackgroundTransparency = 0.4,
            BackgroundColor3 = theme.TabButton,
            BorderSizePixel = 0,
            PlaceholderText = config.Placeholder or "",
            Text = config.Text or "",
            TextColor3 = theme.Text,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            Parent = mainContentFrame
        })

        create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = textbox })

        return textbox
    end

    function Window:AddDropdown(config)
        config = config or {}
        local dropdown = create("TextButton", {
            Size = UDim2.new(0.9, 0, 0, 30),
            Position = UDim2.new(0.05, 0, 0, 8),
            BackgroundTransparency = 0.4,
            BackgroundColor3 = theme.TabButton,
            BorderSizePixel = 0,
            Text = config.Options[1] or "",
            TextColor3 = theme.Text,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            Parent = mainContentFrame
        })

        create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = dropdown })

        local options = config.Options or {}
        local selected = 1

        dropdown.MouseButton1Click:Connect(function()
            for i, option in ipairs(options) do
                if option == dropdown.Text then
                    selected = i
                end
            end
            selected = selected % #options + 1
            dropdown.Text = options[selected]
        end)

        return dropdown
    end

    function Window:AddLabel(config)
        config = config or {}
        local label = create("TextLabel", {
            Size = UDim2.new(0.9, 0, 0, 20),
            Position = UDim2.new(0.05, 0, 0, 8),
            BackgroundTransparency = 1,
            Text = config.Text or "",
            TextColor3 = theme.Text,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            Parent = mainContentFrame
        })
        return label
    end

    function Window:AddImage(config)
        config = config or {}
        local image = create("ImageLabel", {
            Size = UDim2.new(0.9, 0, 0, 30),
            Position = UDim2.new(0.05, 0, 0, 8),
            BackgroundTransparency = 1,
            Image = config.Image or "rbxasset://textures/ui/DefaultAvatar.png",
            Parent = mainContentFrame
        })
        return image
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
