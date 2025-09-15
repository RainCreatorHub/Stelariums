-- UI Library
local UILib = {}
UILib.__index = UILib

-- Função principal: criar janela
function UILib:MakeWindow(info)
    local Window = {}
    setmetatable(Window, UILib)

    local Players = game:GetService("Players")
    local Player = Players.LocalPlayer
    local PlayerGui = Player:WaitForChild("PlayerGui")

    -- ScreenGui
    Window.ScreenGui = Instance.new("ScreenGui")
    Window.ScreenGui.Parent = PlayerGui
    Window.ScreenGui.ResetOnSpawn = true

    -- Frame principal
    Window.Frame = Instance.new("Frame")
    Window.Frame.Size = info.Size or UDim2.new(0,500,0,350)
    Window.Frame.Position = info.Position or UDim2.new(0.5,-250,0.5,-175)
    Window.Frame.BackgroundColor3 = info.BackgroundColor or Color3.fromRGB(25,25,25)
    Window.Frame.BorderSizePixel = 1
    Window.Frame.BorderColor3 = Color3.fromRGB(0,0,0)
    Window.Frame.Parent = Window.ScreenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,8)
    corner.Parent = Window.Frame

    Window.Tabs = {}

    -- Criar Tab
    function Window:MakeTab(info)
        local Tab = {}
        setmetatable(Tab, UILib)
        Tab.Title = info.Title or "Tab"
        Tab.Frame = Instance.new("Frame")
        Tab.Frame.Size = UDim2.new(1,0,1,0)
        Tab.Frame.Position = UDim2.new(0,0,0,0)
        Tab.Frame.BackgroundTransparency = 1
        Tab.Frame.Visible = true
        Tab.Frame.Parent = Window.Frame

        Tab.Sections = {}

        -- Section (separador visual)
        function Tab:Section(info)
            local Section = {}
            Section.Frame = Instance.new("Frame")
            Section.Frame.Size = UDim2.new(1,0,0,25)
            Section.Frame.BackgroundTransparency = 1
            Section.Frame.Parent = Tab.Frame

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1,0,1,0)
            label.Position = UDim2.new(0,5,0,0)
            label.BackgroundTransparency = 1
            label.Text = info.Title or ""
            label.TextColor3 = Color3.fromRGB(255,255,255)
            label.Font = Enum.Font.Gotham
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = Section.Frame

            table.insert(Tab.Sections, Section)
            return Section
        end

        -- SearchBar
        function Tab:SearchBar(info)
            local SB = {}
            SB.Text = info.Text or ""
            SB.Placeholder = info.Placeholder or "Search..."
            SB.Callback = info.Callback

            SB.Box = Instance.new("TextBox")
            SB.Box.Size = UDim2.new(0,150,0,25)
            SB.Box.Position = info.Position or UDim2.new(0,10,0,50)
            SB.Box.BackgroundColor3 = Color3.fromRGB(35,35,35)
            SB.Box.TextColor3 = Color3.fromRGB(255,255,255)
            SB.Box.PlaceholderText = SB.Placeholder
            SB.Box.Text = SB.Text
            SB.Box.ClearTextOnFocus = false
            SB.Box.BorderSizePixel = 1
            SB.Box.BorderColor3 = Color3.fromRGB(0,0,0)
            SB.Box.Parent = Tab.Frame

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0,6)
            corner.Parent = SB.Box

            SB.Box:GetPropertyChangedSignal("Text"):Connect(function()
                SB.Text = SB.Box.Text
                if SB.Callback then SB.Callback(SB.Text) end
            end)

            return SB
        end

        -- Dropdown
        function Tab:Dropdown(info)
            local Dropdown = {}
            Dropdown.Options = info.Values or {}
            Dropdown.SelectedValues = info.Value or {}
            Dropdown.Multi = info.Multi or false
            Dropdown.AllowNone = info.AllowNone or false
            Dropdown.Callback = info.Callback

            Dropdown.Frame = Instance.new("TextButton")
            Dropdown.Frame.Size = UDim2.new(0,200,0,30)
            Dropdown.Frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
            Dropdown.Frame.BorderSizePixel = 1
            Dropdown.Frame.BorderColor3 = Color3.fromRGB(0,0,0)
            Dropdown.Frame.Text = ""
            Dropdown.Frame.Parent = Tab.Frame

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0,8)
            corner.Parent = Dropdown.Frame

            -- Label
            Dropdown.Label = Instance.new("TextLabel")
            Dropdown.Label.Size = UDim2.new(1,0,1,0)
            Dropdown.Label.Position = UDim2.new(0,10,0,0)
            Dropdown.Label.BackgroundTransparency = 1
            Dropdown.Label.Text = info.Title or "Dropdown"
            Dropdown.Label.TextColor3 = Color3.fromRGB(255,255,255)
            Dropdown.Label.Font = Enum.Font.Gotham
            Dropdown.Label.TextSize = 14
            Dropdown.Label.TextXAlignment = Enum.TextXAlignment.Left
            Dropdown.Label.Parent = Dropdown.Frame

            -- Selected Box
            Dropdown.SelectedBox = Instance.new("TextLabel")
            Dropdown.SelectedBox.Size = UDim2.new(0,80,1,0)
            Dropdown.SelectedBox.Position = UDim2.new(1,-85,0,0)
            Dropdown.SelectedBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
            Dropdown.SelectedBox.BorderSizePixel = 1
            Dropdown.SelectedBox.BorderColor3 = Color3.fromRGB(0,0,0)
            Dropdown.SelectedBox.Text = table.concat(Dropdown.SelectedValues,", ")
            Dropdown.SelectedBox.TextColor3 = Color3.fromRGB(255,255,255)
            Dropdown.SelectedBox.Font = Enum.Font.Gotham
            Dropdown.SelectedBox.TextSize = 14
            Dropdown.SelectedBox.Parent = Dropdown.Frame

            local selCorner = Instance.new("UICorner")
            selCorner.CornerRadius = UDim.new(0,6)
            selCorner.Parent = Dropdown.SelectedBox

            -- Options Frame
            Dropdown.OptionsFrame = Instance.new("ScrollingFrame")
            Dropdown.OptionsFrame.Size = UDim2.new(1,0,0,0)
            Dropdown.OptionsFrame.Position = UDim2.new(0,0,1,5)
            Dropdown.OptionsFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
            Dropdown.OptionsFrame.BorderSizePixel = 1
            Dropdown.OptionsFrame.BorderColor3 = Color3.fromRGB(0,0,0)
            Dropdown.OptionsFrame.Visible = false
            Dropdown.OptionsFrame.ScrollBarThickness = 5
            Dropdown.OptionsFrame.Parent = Dropdown.Frame

            local optionsCorner = Instance.new("UICorner")
            optionsCorner.CornerRadius = UDim.new(0,8)
            optionsCorner.Parent = Dropdown.OptionsFrame

            local layout = Instance.new("UIListLayout")
            layout.SortOrder = Enum.SortOrder.LayoutOrder
            layout.Padding = UDim.new(0,5)
            layout.Parent = Dropdown.OptionsFrame

            Dropdown.OptionButtons = {}

            -- SearchBar dentro do Dropdown
            if info.SearchBar then
                Dropdown.SearchBox = Instance.new("TextBox")
                Dropdown.SearchBox.Size = UDim2.new(1,0,0,25)
                Dropdown.SearchBox.Position = UDim2.new(0,0,0,0)
                Dropdown.SearchBox.PlaceholderText = (info.SearchBarSettings and info.SearchBarSettings.Placeholder) or "Search..."
                Dropdown.SearchBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
                Dropdown.SearchBox.TextColor3 = Color3.fromRGB(255,255,255)
                Dropdown.SearchBox.BorderSizePixel = 1
                Dropdown.SearchBox.BorderColor3 = Color3.fromRGB(0,0,0)
                Dropdown.SearchBox.ClearTextOnFocus = false
                Dropdown.SearchBox.Parent = Dropdown.OptionsFrame
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0,6)
                corner.Parent = Dropdown.SearchBox

                Dropdown.SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
                    local search = Dropdown.SearchBox.Text:lower()
                    for _,btn in ipairs(Dropdown.OptionButtons) do
                        btn.Visible = btn.Text:lower():find(search) ~= nil
                    end
                end)
            end

            -- Criar Option Buttons
            for _,option in pairs(Dropdown.Options) do
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1,-10,0,25)
                btn.Position = UDim2.new(0,5,0,0)
                btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
                btn.Text = option
                btn.TextColor3 = Color3.fromRGB(255,255,255)
                btn.Font = Enum.Font.Gotham
                btn.TextSize = 14
                btn.BorderSizePixel = 1
                btn.BorderColor3 = Color3.fromRGB(0,0,0)
                btn.Parent = Dropdown.OptionsFrame

                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0,6)
                btnCorner.Parent = btn

                btn.MouseButton1Click:Connect(function()
                    local idx = table.find(Dropdown.SelectedValues, option)
                    if Dropdown.Multi then
                        if idx then
                            if Dropdown.AllowNone or #Dropdown.SelectedValues > 1 then
                                table.remove(Dropdown.SelectedValues, idx)
                            end
                        else
                            table.insert(Dropdown.SelectedValues, option)
                        end
                    else
                        Dropdown.SelectedValues = {option}
                    end
                    Dropdown.SelectedBox.Text = table.concat(Dropdown.SelectedValues,", ")
                    if Dropdown.Callback then
                        Dropdown.Callback(Dropdown.SelectedValues)
                    end
                end)

                table.insert(Dropdown.OptionButtons, btn)
            end

            -- Toggle Dropdown
            local open = false
            Dropdown.Frame.MouseButton1Click:Connect(function()
                open = not open
                if open then
                    Dropdown.OptionsFrame.Visible = true
                    Dropdown.OptionsFrame:TweenSize(UDim2.new(1,0,0,#Dropdown.OptionButtons*30 + (Dropdown.SearchBox and 30 or 0)), "Out", "Quad", 0.3, true)
                else
                    Dropdown.OptionsFrame:TweenSize(UDim2.new(1,0,0,0), "Out", "Quad", 0.3, true)
                    task.wait(0.3)
                    Dropdown.OptionsFrame.Visible = false
                end
            end)

            return Dropdown
        end

        -- Button element
        function Tab:Button(info)
            local Button = Instance.new("TextButton")
            Button.Size = info.Size or UDim2.new(0,120,0,30)
            Button.Position = info.Position or UDim2.new(0,10,0,100)
            Button.Text = info.Text or "Button"
            Button.BackgroundColor3 = info.BackgroundColor or Color3.fromRGB(50,50,50)
            Button.TextColor3 = info.TextColor or Color3.fromRGB(255,255,255)
            Button.Parent = Tab.Frame

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0,6)
            corner.Parent = Button

            if info.Callback then
                Button.MouseButton1Click:Connect(info.Callback)
            end

            return Button
        end

        table.insert(Window.Tabs, Tab)
        return Tab
    end

    return Window
end

return UILib
