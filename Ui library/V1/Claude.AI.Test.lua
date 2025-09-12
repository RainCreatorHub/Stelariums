-- GUI Roblox estilo Claude.ai
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Cores estilo Claude.ai (tons neutros e modernos)
local cores = {
    background = Color3.fromRGB(248, 250, 252), -- Branco quase puro
    cardBackground = Color3.fromRGB(255, 255, 255), -- Branco puro
    border = Color3.fromRGB(229, 231, 235), -- Cinza claro
    text = Color3.fromRGB(17, 24, 39), -- Cinza escuro
    textSecondary = Color3.fromRGB(107, 114, 128), -- Cinza médio
    accent = Color3.fromRGB(99, 102, 241), -- Roxo/Índigo
    accentHover = Color3.fromRGB(79, 70, 229), -- Roxo mais escuro
    success = Color3.fromRGB(34, 197, 94), -- Verde
    danger = Color3.fromRGB(239, 68, 68), -- Vermelho
    shadow = Color3.fromRGB(0, 0, 0) -- Para sombras
}

-- Criar ScreenGui principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ClaudeStyleGUI"
screenGui.Parent = playerGui

-- Container principal com sombra
local shadowFrame = Instance.new("Frame")
shadowFrame.Name = "ShadowContainer"
shadowFrame.Size = UDim2.new(0, 476, 0, 346)
shadowFrame.Position = UDim2.new(0.5, -238, 0.5, -173)
shadowFrame.BackgroundColor3 = cores.shadow
shadowFrame.BackgroundTransparency = 0.9
shadowFrame.BorderSizePixel = 0
shadowFrame.Parent = screenGui

-- Criar cantos arredondados para sombra
local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 12)
shadowCorner.Parent = shadowFrame

-- Frame principal da janela
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainWindow"
mainFrame.Size = UDim2.new(0, 470, 0, 340)
mainFrame.Position = UDim2.new(0, 3, 0, 3)
mainFrame.BackgroundColor3 = cores.cardBackground
mainFrame.BorderSizePixel = 1
mainFrame.BorderColor3 = cores.border
mainFrame.Parent = shadowFrame

-- Cantos arredondados para frame principal
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

-- Barra de título moderna
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = cores.cardBackground
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

-- Cantos arredondados apenas na parte superior
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

-- Separador sutil
local separator = Instance.new("Frame")
separator.Name = "Separator"
separator.Size = UDim2.new(1, -20, 0, 1)
separator.Position = UDim2.new(0, 10, 1, -1)
separator.BackgroundColor3 = cores.border
separator.BorderSizePixel = 0
separator.Parent = titleBar

-- Ícone do Claude (círculo com "C")
local iconFrame = Instance.new("Frame")
iconFrame.Name = "Icon"
iconFrame.Size = UDim2.new(0, 32, 0, 32)
iconFrame.Position = UDim2.new(0, 15, 0, 9)
iconFrame.BackgroundColor3 = cores.accent
iconFrame.BorderSizePixel = 0
iconFrame.Parent = titleBar

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 16)
iconCorner.Parent = iconFrame

local iconLabel = Instance.new("TextLabel")
iconLabel.Size = UDim2.new(1, 0, 1, 0)
iconLabel.BackgroundTransparency = 1
iconLabel.Text = "C"
iconLabel.TextColor3 = Color3.new(1, 1, 1)
iconLabel.TextSize = 18
iconLabel.Font = Enum.Font.GothamBold
iconLabel.Parent = iconFrame

-- Título principal moderno
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(0.5, 0, 0, 24)
titleLabel.Position = UDim2.new(0, 55, 0, 8)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Claude Assistant"
titleLabel.TextColor3 = cores.text
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.GothamSemibold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- SubTítulo moderno
local subTitleLabel = Instance.new("TextLabel")
subTitleLabel.Name = "SubTitle"
subTitleLabel.Size = UDim2.new(0.5, 0, 0, 16)
subTitleLabel.Position = UDim2.new(0, 55, 0, 26)
subTitleLabel.BackgroundTransparency = 1
subTitleLabel.Text = "AI Assistant Interface"
subTitleLabel.TextColor3 = cores.textSecondary
subTitleLabel.TextSize = 12
subTitleLabel.Font = Enum.Font.Gotham
subTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
subTitleLabel.Parent = titleBar

-- Container para botões
local buttonContainer = Instance.new("Frame")
buttonContainer.Size = UDim2.new(0, 80, 0, 32)
buttonContainer.Position = UDim2.new(1, -95, 0, 9)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = titleBar

-- Botão de minimizar estilo moderno
local minButton = Instance.new("TextButton")
minButton.Name = "MinButton"
minButton.Size = UDim2.new(0, 32, 0, 32)
minButton.Position = UDim2.new(0, 0, 0, 0)
minButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
minButton.BackgroundTransparency = 1
minButton.BorderSizePixel = 0
minButton.Text = "−"
minButton.TextColor3 = cores.textSecondary
minButton.TextSize = 16
minButton.Font = Enum.Font.GothamMedium
minButton.Parent = buttonContainer

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = minButton

-- Botão de fechar estilo moderno
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 32, 0, 32)
closeButton.Position = UDim2.new(0, 40, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
closeButton.BackgroundTransparency = 1
closeButton.BorderSizePixel = 0
closeButton.Text = "×"
closeButton.TextColor3 = cores.textSecondary
closeButton.TextSize = 18
closeButton.Font = Enum.Font.GothamMedium
closeButton.Parent = buttonContainer

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

-- Área de conteúdo principal
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Name = "Content"
contentFrame.Size = UDim2.new(1, -30, 1, -80)
contentFrame.Position = UDim2.new(0, 15, 0, 65)
contentFrame.BackgroundColor3 = cores.background
contentFrame.BorderSizePixel = 0
contentFrame.ScrollBarThickness = 4
contentFrame.ScrollBarImageColor3 = cores.border
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 500)
contentFrame.Parent = mainFrame

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 6)
contentCorner.Parent = contentFrame

-- Layout para o conteúdo
local contentLayout = Instance.new("UIListLayout")
contentLayout.FillDirection = Enum.FillDirection.Vertical
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.Padding = UDim.new(0, 16)
contentLayout.Parent = contentFrame

local contentPadding = Instance.new("UIPadding")
contentPadding.PaddingAll = UDim.new(0, 20)
contentPadding.Parent = contentFrame

-- Cartão de boas-vindas
local welcomeCard = Instance.new("Frame")
welcomeCard.Name = "WelcomeCard"
welcomeCard.Size = UDim2.new(1, 0, 0, 120)
welcomeCard.BackgroundColor3 = cores.cardBackground
welcomeCard.BorderSizePixel = 1
welcomeCard.BorderColor3 = cores.border
welcomeCard.LayoutOrder = 1
welcomeCard.Parent = contentFrame

local welcomeCorner = Instance.new("UICorner")
welcomeCorner.CornerRadius = UDim.new(0, 8)
welcomeCorner.Parent = welcomeCard

local welcomePadding = Instance.new("UIPadding")
welcomePadding.PaddingAll = UDim.new(0, 20)
welcomePadding.Parent = welcomeCard

local welcomeTitle = Instance.new("TextLabel")
welcomeTitle.Size = UDim2.new(1, 0, 0, 24)
welcomeTitle.BackgroundTransparency = 1
welcomeTitle.Text = "Welcome to Claude"
welcomeTitle.TextColor3 = cores.text
welcomeTitle.TextSize = 18
welcomeTitle.Font = Enum.Font.GothamSemibold
welcomeTitle.TextXAlignment = Enum.TextXAlignment.Left
welcomeTitle.Parent = welcomeCard

local welcomeText = Instance.new("TextLabel")
welcomeText.Size = UDim2.new(1, 0, 1, -30)
welcomeText.Position = UDim2.new(0, 0, 0, 30)
welcomeText.BackgroundTransparency = 1
welcomeText.Text = "Your AI assistant is ready to help. This interface combines modern design with powerful functionality, featuring smooth animations and an intuitive user experience."
welcomeText.TextColor3 = cores.textSecondary
welcomeText.TextSize = 14
welcomeText.Font = Enum.Font.Gotham
welcomeText.TextXAlignment = Enum.TextXAlignment.Left
welcomeText.TextYAlignment = Enum.TextYAlignment.Top
welcomeText.TextWrapped = true
welcomeText.Parent = welcomeCard

-- Cartão de recursos
local featuresCard = Instance.new("Frame")
featuresCard.Name = "FeaturesCard"
featuresCard.Size = UDim2.new(1, 0, 0, 180)
featuresCard.BackgroundColor3 = cores.cardBackground
featuresCard.BorderSizePixel = 1
featuresCard.BorderColor3 = cores.border
featuresCard.LayoutOrder = 2
featuresCard.Parent = contentFrame

local featuresCorner = Instance.new("UICorner")
featuresCorner.CornerRadius = UDim.new(0, 8)
featuresCorner.Parent = featuresCard

local featuresPadding = Instance.new("UIPadding")
featuresPadding.PaddingAll = UDim.new(0, 20)
featuresPadding.Parent = featuresCard

local featuresTitle = Instance.new("TextLabel")
featuresTitle.Size = UDim2.new(1, 0, 0, 24)
featuresTitle.BackgroundTransparency = 1
featuresTitle.Text = "Interface Features"
featuresTitle.TextColor3 = cores.text
featuresTitle.TextSize = 16
featuresTitle.Font = Enum.Font.GothamSemibold
featuresTitle.TextXAlignment = Enum.TextXAlignment.Left
featuresTitle.Parent = featuresCard

-- Grid de features
local featuresGrid = Instance.new("Frame")
featuresGrid.Size = UDim2.new(1, 0, 1, -30)
featuresGrid.Position = UDim2.new(0, 0, 0, 30)
featuresGrid.BackgroundTransparency = 1
featuresGrid.Parent = featuresCard

local gridLayout = Instance.new("UIGridLayout")
gridLayout.CellSize = UDim2.new(0.48, 0, 0, 60)
gridLayout.CellPadding = UDim2.new(0.04, 0, 0, 16)
gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
gridLayout.Parent = featuresGrid

local features = {
    {icon = "🎨", title = "Modern Design", desc = "Clean, contemporary interface"},
    {icon = "⚡", title = "Smooth Animations", desc = "Fluid transitions and effects"},
    {icon = "📱", title = "Responsive Layout", desc = "Adapts to different sizes"},
    {icon = "🔧", title = "Customizable", desc = "Personalize your experience"}
}

for i, feature in ipairs(features) do
    local featureItem = Instance.new("Frame")
    featureItem.BackgroundColor3 = cores.background
    featureItem.BorderSizePixel = 0
    featureItem.LayoutOrder = i
    featureItem.Parent = featuresGrid
    
    local featureCorner = Instance.new("UICorner")
    featureCorner.CornerRadius = UDim.new(0, 6)
    featureCorner.Parent = featureItem
    
    local featurePadding = Instance.new("UIPadding")
    featurePadding.PaddingAll = UDim.new(0, 12)
    featurePadding.Parent = featureItem
    
    local featureIcon = Instance.new("TextLabel")
    featureIcon.Size = UDim2.new(0, 20, 0, 20)
    featureIcon.BackgroundTransparency = 1
    featureIcon.Text = feature.icon
    featureIcon.TextSize = 16
    featureIcon.Parent = featureItem
    
    local featureTitle = Instance.new("TextLabel")
    featureTitle.Size = UDim2.new(1, -25, 0, 18)
    featureTitle.Position = UDim2.new(0, 25, 0, 0)
    featureTitle.BackgroundTransparency = 1
    featureTitle.Text = feature.title
    featureTitle.TextColor3 = cores.text
    featureTitle.TextSize = 13
    featureTitle.Font = Enum.Font.GothamMedium
    featureTitle.TextXAlignment = Enum.TextXAlignment.Left
    featureTitle.Parent = featureItem
    
    local featureDesc = Instance.new("TextLabel")
    featureDesc.Size = UDim2.new(1, -25, 1, -20)
    featureDesc.Position = UDim2.new(0, 25, 0, 18)
    featureDesc.BackgroundTransparency = 1
    featureDesc.Text = feature.desc
    featureDesc.TextColor3 = cores.textSecondary
    featureDesc.TextSize = 11
    featureDesc.Font = Enum.Font.Gotham
    featureDesc.TextXAlignment = Enum.TextXAlignment.Left
    featureDesc.TextYAlignment = Enum.TextYAlignment.Top
    featureDesc.TextWrapped = true
    featureDesc.Parent = featureItem
end

-- Variáveis de estado
local isMinimized = false
local originalSize = mainFrame.Size
local originalShadowSize = shadowFrame.Size

-- Função para animar com efeito de bounce suave
local function animateResize(targetSize, targetShadowSize, duration)
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local tween1 = TweenService:Create(mainFrame, tweenInfo, {Size = targetSize})
    local tween2 = TweenService:Create(shadowFrame, tweenInfo, {Size = targetShadowSize})
    tween1:Play()
    tween2:Play()
    return tween1
end

-- Efeitos hover para botões
minButton.MouseEnter:Connect(function()
    local hoverTween = TweenService:Create(minButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.9})
    hoverTween:Play()
end)

minButton.MouseLeave:Connect(function()
    local hoverTween = TweenService:Create(minButton, TweenInfo.new(0.2), {BackgroundTransparency = 1})
    hoverTween:Play()
end)

closeButton.MouseEnter:Connect(function()
    local hoverTween = TweenService:Create(closeButton, TweenInfo.new(0.2), {
        BackgroundTransparency = 0.9,
        TextColor3 = cores.danger
    })
    hoverTween:Play()
end)

closeButton.MouseLeave:Connect(function()
    local hoverTween = TweenService:Create(closeButton, TweenInfo.new(0.2), {
        BackgroundTransparency = 1,
        TextColor3 = cores.textSecondary
    })
    hoverTween:Play()
end)

-- Função do botão minimizar
minButton.MouseButton1Click:Connect(function()
    if not isMinimized then
        -- Minimizar
        isMinimized = true
        minButton.Text = "□"
        
        -- Ocultar conteúdo
        contentFrame.Visible = false
        separator.Visible = false
        
        -- Animar redimensionamento
        animateResize(UDim2.new(0, 470, 0, 50), UDim2.new(0, 476, 0, 56), 0.4)
    else
        -- Restaurar
        isMinimized = false
        minButton.Text = "−"
        
        -- Animar redimensionamento primeiro
        local tween = animateResize(originalSize, originalShadowSize, 0.4)
        
        -- Mostrar conteúdo após animação
        tween.Completed:Connect(function()
            contentFrame.Visible = true
            separator.Visible = true
        end)
    end
end)

-- Função do botão fechar com confirmação visual
closeButton.MouseButton1Click:Connect(function()
    -- Animação de saída
    local exitTween = TweenService:Create(shadowFrame, TweenInfo.new(0.3), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    exitTween:Play()
    
    exitTween.Completed:Connect(function()
        screenGui:Destroy()
    end)
end)

-- Tornar a janela arrastável (apenas pela barra de título)
local dragging = false
local dragStart = nil
local startPos = nil

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = shadowFrame.Position
    end
end)

titleBar.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        shadowFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Animação de entrada suave
shadowFrame.Size = UDim2.new(0, 0, 0, 0)
shadowFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

wait(0.1)
local entranceTween = TweenService:Create(shadowFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
    Size = originalShadowSize,
    Position = UDim2.new(0.5, -238, 0.5, -173)
})
entranceTween:Play()

print("GUI estilo Claude.ai criado com sucesso!")
