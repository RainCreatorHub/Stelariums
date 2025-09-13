local DoorLib = loadstring(game:HttpGet(""))()

-- Criar janela principal
local Window = DoorLib:MakeWindow({
    Title = "Exemplo DoorLib",
    SubTitle = "Por RainCreatorHub",
    Resizable = true, 
    MinSize = UDim2.new(0, 300, 0, 200),
    MaxSize = UDim2.new(0, 500, 0, 350),
    DefaultSize = UDim2.new(0, 470, 0, 340),
    Theme = "Dark"
})

-- Criar uma aba
local MainTab = Window:MakeTab({
    Name = "Principal",
    Icon = "rbxassetid://0",
    Style = 1
})

-- Criar uma seção
MainTab:Section({
    Name = "Controles",
    Desc = "Configurações principais"
})

-- Toggle
local SpeedToggle = MainTab:Toggle({
    Name = "Velocidade Rápida", 
    Desc = "Ativa/Desativa velocidade aumentada",
    Default = false,
    Callback = function(Value)
        print("Toggle:", Value)
    end
})

-- Slider
local SpeedSlider = MainTab:Slider({
    Name = "Velocidade",
    Desc = "Ajusta a velocidade",
    Min = 16,
    Max = 100, 
    Default = 16,
    Callback = function(Value)
        print("Velocidade:", Value)
    end
})

-- Button 
local ResetButton = MainTab:Button({
    Name = "Resetar",
    Desc = "Reseta configurações",
    Callback = function()
        SpeedToggle:Set(false)
        SpeedSlider:Set(16)
    end
})

-- Dropdown
local TeleportDropdown = MainTab:Dropdown({
    Name = "Teleporte",
    Desc = "Escolha um local",
    Options = {"Spawn", "Loja", "Arena"},
    Default = "Spawn",
    Callback = function(Selected)
        print("Local:", Selected)
    end
})

-- ColorPicker
local ColorPicker = MainTab:ColorPicker({
    Name = "Cor", 
    Desc = "Escolha uma cor",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(Color)
        print("Cor:", Color)
    end
})

-- Keybind
local ToggleUI = MainTab:Keybind({
    Name = "Toggle UI",
    Desc = "Tecla para mostrar/esconder UI",
    Default = Enum.KeyCode.RightControl,
    Callback = function()
        print("UI alternada")
    end
})