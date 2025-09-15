-- Gpt Test
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = PlayerGui
screenGui.ResetOnSpawn = true

-- Dropdown principal
local dropdownFrame = Instance.new("TextButton")
dropdownFrame.Size = UDim2.new(0, 200, 0, 30)
dropdownFrame.Position = UDim2.new(0.5, -100, 0.5, -15)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
dropdownFrame.BorderSizePixel = 1
dropdownFrame.BorderColor3 = Color3.fromRGB(0,0,0)
dropdownFrame.Text = ""
dropdownFrame.Parent = screenGui

local dropdownUICorner = Instance.new("UICorner")
dropdownUICorner.CornerRadius = UDim.new(0, 8)
dropdownUICorner.Parent = dropdownFrame

-- Label do Dropdown
local dropdownLabel = Instance.new("TextLabel")
dropdownLabel.Size = UDim2.new(1, 0, 1, 0)
dropdownLabel.Position = UDim2.new(0, 10, 0, 0)
dropdownLabel.BackgroundTransparency = 1
dropdownLabel.Text = "Dropdown example"
dropdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
dropdownLabel.Font = Enum.Font.Gotham
dropdownLabel.TextSize = 14
dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
dropdownLabel.Parent = dropdownFrame

-- Container mostrando option selecionada
local selectedBox = Instance.new("TextLabel")
selectedBox.Size = UDim2.new(0,40,1,0)
selectedBox.Position = UDim2.new(1,-45,0,0)
selectedBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
selectedBox.BorderSizePixel = 1
selectedBox.BorderColor3 = Color3.fromRGB(0,0,0)
selectedBox.Text = ""
selectedBox.TextColor3 = Color3.fromRGB(255,255,255)
selectedBox.Font = Enum.Font.Gotham
selectedBox.TextSize = 14
selectedBox.Parent = dropdownFrame

local selectedCorner = Instance.new("UICorner")
selectedCorner.CornerRadius = UDim.new(0,6)
selectedCorner.Parent = selectedBox

-- Options ScrollFrame
local optionsFrame = Instance.new("ScrollingFrame")
optionsFrame.Size = UDim2.new(1, 0, 0, 0)
optionsFrame.Position = UDim2.new(0, 0, 1, 5)
optionsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
optionsFrame.BorderSizePixel = 1
optionsFrame.BorderColor3 = Color3.fromRGB(0,0,0)
optionsFrame.Visible = false
optionsFrame.ScrollBarThickness = 5
optionsFrame.Parent = dropdownFrame

local optionsCorner = Instance.new("UICorner")
optionsCorner.CornerRadius = UDim.new(0, 8)
optionsCorner.Parent = optionsFrame

local optionsLayout = Instance.new("UIListLayout")
optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
optionsLayout.Padding = UDim.new(0, 5)
optionsLayout.Parent = optionsFrame

-- Opções
local options = {"Op 1","Op 2","Op 3","Op 4","Op 5","Op 6","Op 7","Op 8","Op 9"}
local optionButtons = {}

for _, option in pairs(options) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 25)
    btn.Position = UDim2.new(0, 5, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.Text = option
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(0,0,0)
    btn.Parent = optionsFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    -- Linha azul esquerda para option selecionada
    local line = Instance.new("Frame")
    line.Size = UDim2.new(0,0,1,0)
    line.Position = UDim2.new(0,0,0,0)
    line.BackgroundColor3 = Color3.fromRGB(0,162,255)
    line.BorderSizePixel = 1
    line.BorderColor3 = Color3.fromRGB(0,0,0)
    line.Visible = false
    line.Parent = btn

    btn.MouseButton1Click:Connect(function()
        selectedBox.Text = option
        for _,b in ipairs(optionButtons) do
            b:FindFirstChildWhichIsA("Frame").Visible = false
        end
        line.Visible = true
    end)

    table.insert(optionButtons, btn)
end

-- Atualiza CanvasSize do ScrollFrame
local function updateCanvasSize()
    local totalHeight = 0
    for _, btn in ipairs(optionButtons) do
        if btn.Visible then
            totalHeight = totalHeight + btn.AbsoluteSize.Y + optionsLayout.Padding.Offset
        end
    end
    optionsFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

optionsFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateCanvasSize)
for _, btn in ipairs(optionButtons) do
    btn:GetPropertyChangedSignal("Visible"):Connect(updateCanvasSize)
end

-- Lupa (posição inicial)
local searchButton = Instance.new("TextButton")
searchButton.Size = UDim2.new(0, 30, 0, 30)
searchButton.Position = UDim2.new(0.5, 105, 0.5, -15)
searchButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
searchButton.Text = "🔍"
searchButton.BorderSizePixel = 1
searchButton.BorderColor3 = Color3.fromRGB(0,0,0)
searchButton.Parent = screenGui

local searchCorner = Instance.new("UICorner")
searchCorner.CornerRadius = UDim.new(0,6)
searchCorner.Parent = searchButton

-- Barra de pesquisa
local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(0,0,0,25)
searchBox.Position = UDim2.new(0.5,105,0.5,-12)
searchBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
searchBox.TextColor3 = Color3.fromRGB(255,255,255)
searchBox.PlaceholderText = "Search..."
searchBox.Text = ""
searchBox.Visible = false
searchBox.TextSize = 14
searchBox.ClearTextOnFocus = false
searchBox.BorderSizePixel = 1
searchBox.BorderColor3 = Color3.fromRGB(0,0,0)
searchBox.Parent = screenGui

local searchBoxCorner = Instance.new("UICorner")
searchBoxCorner.CornerRadius = UDim.new(0,6)
searchBoxCorner.Parent = searchBox

-- Abrir/fechar dropdown
local dropdownOpen = false
dropdownFrame.MouseButton1Click:Connect(function()
    dropdownOpen = not dropdownOpen
    if dropdownOpen then
        optionsFrame.Visible = true
        optionsFrame:TweenSize(UDim2.new(1,0,0,math.min(#optionButtons*30,150)), Enum.EasingDirection.Out, Enum.EasingStyle.Quad,0.25,true)
    else
        optionsFrame:TweenSize(UDim2.new(1,0,0,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad,0.25,true)
        task.wait(0.25)
        optionsFrame.Visible = false
    end
end)

-- Abrir/fechar SearchBar com animação
local searchOpen = false
searchButton.MouseButton1Click:Connect(function()
    searchOpen = not searchOpen
    if searchOpen then
        -- Lupa sobe
        searchButton:TweenPosition(UDim2.new(0.5,105,0.5,-46), Enum.EasingDirection.Out, Enum.EasingStyle.Quad,0.25,true)
        searchBox.Visible = true
        searchBox:TweenSize(UDim2.new(0,150,0,25), Enum.EasingDirection.Out, Enum.EasingStyle.Quad,0.25,true)
    else
        -- Lupa volta
        searchButton:TweenPosition(UDim2.new(0.5,105,0.5,-15), Enum.EasingDirection.Out, Enum.EasingStyle.Quad,0.25,true)
        searchBox:TweenSize(UDim2.new(0,0,0,25), Enum.EasingDirection.Out, Enum.EasingStyle.Quad,0.25,true)
        task.wait(0.25)
        searchBox.Visible = false
    end
end)

-- Filtrar opções
searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local text = searchBox.Text:lower()
    for _, btn in pairs(optionButtons) do
        if text == "" or btn.Text:lower():find(text) then
            btn.Visible = true
        else
            btn.Visible = false
        end
    end
    updateCanvasSize()
end)
