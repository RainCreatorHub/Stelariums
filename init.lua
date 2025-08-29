-- Antes que diga a mas o Rain usa IA
-- Eu fico testando IA nessa conta porque eu nunca tenho nada pra fazer ok meu mano?
local Lib = {}
Lib.__index = Lib

function Lib.new()
    local instance = setmetatable({}, Lib)
    return instance
end

function Lib:MakeWindow(config)
    -- Validar configurações básicas
    assert(type(config.Title) == "string", "Title deve ser uma string")
    assert(type(config.SubTitle) == "string", "SubTitle deve ser uma string")
    assert(config.MinSize and config.MaxSize and config.DefaultSize, 
           "Dimensões mínimas, máximas e padrão são necessárias")

    -- Criar ScreenGui se não existir
    local player = game.Players.LocalPlayer
    local screen = Instance.new("ScreenGui")
    screen.Parent = player.PlayerGui
    
    -- Criar frame principal
    local window = Instance.new("Frame")
    window.Size = config.DefaultSize
    window.Position = UDim2.new(0.5, -config.DefaultSize.X.Offset / 2, 
                               0.5, -config.DefaultSize.Y.Offset / 2)
    window.BackgroundTransparency = 1
    window.ClipsDescendants = true
    window.Parent = screen

    -- Barra de título
    local titlebar = Instance.new("Frame")
    titlebar.Size = UDim2.new(1, 0, 0, 30)
    titlebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    titlebar.Parent = window

    -- Textos de título
    local title = Instance.new("TextLabel")
    title.Text = config.Title
    title.Size = UDim2.new(1, 0, 0, 20)
    title.Position = UDim2.new(0, 10, 0, 5)
    title.Font = Enum.Font.SourceSansSemibold
    title.TextColor3 = Color3.new(1, 1, 1)
    title.BackgroundTransparency = 1
    title.Parent = titlebar

    local subtitle = Instance.new("TextLabel")
    subtitle.Text = config.SubTitle
    subtitle.Size = UDim2.new(1, 0, 0, 10)
    subtitle.Position = UDim2.new(0, 10, 0, 20)
    subtitle.Font = Enum.Font.SourceSansLight
    subtitle.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    subtitle.BackgroundTransparency = 1
    subtitle.Parent = titlebar

    -- Implementar sistema de chave se ativado
    if config.KeySystem and config.KeySystem.Enabled then
        self:InitializeKeySystem(window, config.KeySystem)
    end

    -- Implementar barra do usuário se necessário
    if config.User and config.User.DefaultUser then
        self:InitializeUserBar(window, config.User)
    end

    -- Funções auxiliares para manipulação da janela
    function window.SetSize(size)
        assert(size.X.Offset >= config.MinSize.X.Offset and 
               size.X.Offset <= config.MaxSize.X.Offset and
               size.Y.Offset >= config.MinSize.Y.Offset and
               size.Y.Offset <= config.MaxSize.Y.Offset,
               "Tamanho fora dos limites permitidos")
        window.Size = size
    end

    return window
end

function Lib:InitializeKeySystem(window, keyConfig)
    -- Implementação do sistema de chave aqui
    local keyFrame = Instance.new("Frame")
    keyFrame.Size = UDim2.new(1, 0, 0, 50)
    keyFrame.Position = UDim2.new(0, 0, 1, -50)
    keyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    keyFrame.Parent = window

    -- Adicionar elementos do sistema de chave
    local keyTitle = Instance.new("TextLabel")
    keyTitle.Text = keyConfig.Title
    keyTitle.Size = UDim2.new(1, 0, 0, 15)
    keyTitle.Font = Enum.Font.SourceSansSemibold
    keyTitle.TextColor3 = Color3.new(1, 1, 1)
    keyTitle.BackgroundTransparency = 1
    keyTitle.Parent = keyFrame

    local keySubtitle = Instance.new("TextLabel")
    keySubtitle.Text = keyConfig.SubTitle
    keySubtitle.Size = UDim2.new(1, 0, 0, 15)
    keySubtitle.Font = Enum.Font.SourceSansLight
    keySubtitle.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    keySubtitle.BackgroundTransparency = 1
    keySubtitle.Parent = keyFrame
end

function Lib:InitializeUserBar(window, userConfig)
    -- Implementação da barra do usuário aqui
    local userBar = Instance.new("Frame")
    userBar.Size = UDim2.new(1, 0, 0, 30)
    userBar.Position = UDim2.new(0, 0, 1, -80)
    userBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    userBar.Parent = window

    -- Adicionar elementos da barra do usuário
    local userInfo = Instance.new("TextLabel")
    userInfo.Text = "Usuário: " .. (userConfig.Anonymous and "Anônimo" or "Padrão")
    userInfo.Size = UDim2.new(1, 0, 0, 30)
    userInfo.Font = Enum.Font.SourceSansLight
    userInfo.TextColor3 = Color3.new(1, 1, 1)
    userInfo.BackgroundTransparency = 1
    userInfo.Parent = userBar
end

return Lib
