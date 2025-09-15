-- Bind AI test
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
dropdownFrame.Text = ""
dropdownFrame.Parent = screenGui

local dropdownUICorner = Instance.new("UICorner")
dropdownUICorner.CornerRadius = UDim.new(0, 8)
dropdownUICorner.Parent = dropdownFrame

local dropdownStroke = Instance.new("UIStroke")
dropdownStroke.Thickness = 1
dropdownStroke.Color = Color3.fromRGB(0,0,0)
dropdownStroke.Parent = dropdownFrame

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

-- Container da opção selecionada
local selectedContainer = Instance.new("Frame")
selectedContainer.Size = UDim2.new(0, 50, 0, 20)
selectedContainer.Position = UDim2.new(1, -55, 0.5, -10)
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

-- Options ScrollFrame
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

-- Opções
local options = {"Op 1","Op 2","Op 3","Op 4","Op 5","Op 6","Op 7","Op 8","Op 9"}
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
        -- Remove linha azul de todas as outras opções
        for _, otherBtn in ipairs(optionButtons) do
            if otherBtn:FindFirstChild("selectedLine") then
                otherBtn.selectedLine:Destroy()
            end
        end

        -- Cria a linha azul com bordas arredondadas apenas na opção selecionada
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

        -- Atualiza container de opção selecionada
        selectedLabel.Text = btn.Text
        -- NÃO fecha o dropdown
    end)

    table.insert(optionButtons, btn)
end

-- Atualiza CanvasSize
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

-- Lupa
local searchButton = Instance.new("TextButton")
searchButton.Size = UDim2.new(0, 30, 0, 30)
searchButton.Position = UDim2.new(0.5, 105, 0.5, -15)
searchButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
searchButton.Text = "🔍"
searchButton.BorderSizePixel = 0
searchButton.Parent = screenGui

local searchUICorner = Instance.new("UICorner")
searchUICorner.CornerRadius = UDim.new(0, 6)
searchUICorner.Parent = searchButton

local searchButtonStroke = Instance.new("UIStroke")
searchButtonStroke.Thickness = 1
searchButtonStroke.Color = Color3.fromRGB(0,0,0)
searchButtonStroke.Parent = searchButton

-- Barra de pesquisa
local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(0, 0, 0, 25)
searchBox.Position = UDim2.new(0.5, 105, 0.5, -12)
searchBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
searchBox.PlaceholderText = " "
searchBox.Text = ""
searchBox.Visible = false
searchBox.TextTransparency = 0
searchBox.TextSize = 14
searchBox.ClearTextOnFocus = false
searchBox.BorderSizePixel = 0
searchBox.ClipsDescendants = true
searchBox.Parent = screenGui

local searchBoxCorner = Instance.new("UICorner")
searchBoxCorner.CornerRadius = UDim.new(0, 6)
searchBoxCorner.Parent = searchBox

local searchBoxStroke = Instance.new("UIStroke")
searchBoxStroke.Thickness = 1
searchBoxStroke.Color = Color3.fromRGB(0,0,0)
searchBoxStroke.Parent = searchBox

-- Variáveis de estado
local dropdownOpen = false
local searchOpen = false

-- Funções do Dropdown
function OpenDrop()
    if not dropdownOpen then
        dropdownOpen = true
        optionsFrame.Visible = true
        optionsFrame:TweenSize(UDim2.new(1,0,0,math.min(#optionButtons*27,150)), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
    end
end

function CloseDrop()
    if dropdownOpen then
        dropdownOpen = false
        optionsFrame:TweenSize(UDim2.new(1,0,0,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
        task.delay(0.25,function()
            optionsFrame.Visible = false
        end)
    end
end

-- Funções da SearchBar
function OpenDropSearch()
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

function CloseDropSearch()
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
        CloseDropSearch()
    else
        OpenDropSearch()
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
