# `DoorLib` | Library

> [!NOTE]
> ESTOU TESTANDO UMA IA.
> IA: Copilot
> Web site: [Copilot aqui!](https://github.com/copilot)


## > Ex de uso:

```lua
local DoorLib = loadstring(game:HttpGet(""))()

-- Criar janela principal
local Window = DoorLib:MakeWindow({
    Title = "Minha Interface",
    SubTitle = "Descrição",
    Resizable = true,
    MinSize = UDim2.new(0, 300, 0, 200),
    MaxSize = UDim2.new(0, 800, 0, 600),
    DefaultSize = UDim2.new(0, 500, 0, 350),
    Theme = "Dark"
})

-- Métodos da janela
Window:SetTitle("Novo Título")
Window:SetSubTitle("Nova Descrição") 
Window:Resize(UDim2.new(0, 600, 0, 400))
Window:Minimize()
Window:Maximize()
Window:Close()
Window:Notify({
    Title = "Sucesso",
    Description = "Window carregada",
    Duration = 3
})

-- Criar uma aba
local Tab = Window:MakeTab({
    Name = "Minha Aba",
    Icon = "rbxassetid://0",
    Style = 1 -- 1 normal, 2 vermelho, 3 verde
})

-- Criar uma seção
Tab:Section({
    Name = "Divisor",
    Desc = "Texto opcional",
    Icon = "",
    Style = 1
})

-- Criar um toggle
local Toggle = Tab:Toggle({
    Name = "Ativar Sistema",
    Desc = "Liga/Desliga algo",
    Default = false,
    Callback = function(Value)
        print("Toggle:", Value)
    end
})

Toggle:Set(true)       -- Força ON
Toggle:Set(false)      -- Força OFF
print(Toggle:Get())    -- true/false
Toggle:Lock()          -- Bloqueia interação
Toggle:Unlock()        -- Desbloqueia

-- Criar um slider
local Slider = Tab:Slider({
    Name = "Velocidade",
    Desc = "Ajuste a velocidade",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(Value)
        print("Velocidade:", Value)
    end
})

Slider:Set(80)        -- Define valor
print(Slider:Get())   -- Retorna valor atual
Slider:Lock()         -- Impede mexer
Slider:Unlock()       -- Libera

-- Criar um botão
local Button = Tab:Button({
    Name = "Executar",
    Desc = "Executa ação",
    Callback = function()
        print("Botão clicado")
    end
})

Button:SetTitle("Novo Nome")
Button:SetDesc("Nova descrição")

-- Criar um dropdown
local Dropdown = Tab:Dropdown({
    Name = "Escolher",
    Desc = "Selecione algo",
    Options = {"Opção 1", "Opção 2"},
    Default = "Opção 1",
    Callback = function(Selected)
        print("Escolhido:", Selected)
    end
})

Dropdown:Add("Opção 3")
Dropdown:Remove("Opção 1")
Dropdown:Clear()
Dropdown:Set("Opção 2")
print(Dropdown:Get())

-- Criar um color picker
local ColorPicker = Tab:ColorPicker({
    Name = "Cor",
    Desc = "Escolha uma cor",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(Color)
        print("Cor escolhida:", Color)
    end
})

ColorPicker:Set(Color3.fromRGB(0, 255, 0))
print(ColorPicker:Get())
ColorPicker:Lock()
ColorPicker:Unlock()

-- Criar um keybind
local Keybind = Tab:Keybind({
    Name = "Atalho",
    Desc = "Pressione a tecla",
    Default = Enum.KeyCode.F,
    Callback = function()
        print("Tecla pressionada")
    end
})

Keybind:Set(Enum.KeyCode.E)
print(Keybind:Get())
Keybind:Lock()
Keybind:Unlock()
```
