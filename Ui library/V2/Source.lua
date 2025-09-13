-- Door Library
-- Created by RainCreatorHub

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local DoorLib = {}
DoorLib.__index = DoorLib

-- Utility Functions
local function Create(className, properties)
    local instance = Instance.new(className)
    for k, v in pairs(properties or {}) do
        instance[k] = v
    end
    return instance
end

local function Tween(object, time, properties)
    local tween = TweenService:Create(object, TweenInfo.new(time), properties)
    tween:Play()
    return tween
end

function DoorLib:MakeWindow(config)
    local window = setmetatable({}, DoorLib)
    
    -- Main ScreenGui
    window.ScreenGui = Create("ScreenGui", {
        Name = "DoorLib",
        Parent = CoreGui,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    -- Main Frame
    window.MainFrame = Create("Frame", {
        Name = "MainFrame",
        Parent = window.ScreenGui,
        Size = config.DefaultSize or UDim2.new(0, 470, 0, 340),
        Position = UDim2.new(0.5, -235, 0.5, -170),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0
    })
    
    Create("UICorner", {
        Parent = window.MainFrame,
        CornerRadius = UDim.new(0, 8)
    })
    
    -- Titlebar
    window.Titlebar = Create("Frame", {
        Name = "Titlebar",
        Parent = window.MainFrame,
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 0
    })
    
    Create("UICorner", {
        Parent = window.Titlebar,
        CornerRadius = UDim.new(0, 8)
    })
    
    -- Title
    window.Title = Create("TextLabel", {
        Parent = window.Titlebar,
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Title or "Door Library",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Subtitle
    window.SubTitle = Create("TextLabel", {
        Parent = window.Titlebar,
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, 10, 0.5, 0),
        BackgroundTransparency = 1,
        Text = config.SubTitle or "",
        TextColor3 = Color3.fromRGB(200, 200, 200),
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Buttons Container
    window.ButtonsContainer = Create("Frame", {
        Parent = window.Titlebar,
        Size = UDim2.new(0, 90, 1, -10),
        Position = UDim2.new(1, -95, 0, 5),
        BackgroundTransparency = 1
    })
    
    -- Minimize Button
    window.MinimizeBtn = Create("TextButton", {
        Parent = window.ButtonsContainer,
        Size = UDim2.new(0, 25, 0, 25),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        Text = "-",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        Font = Enum.Font.GothamBold
    })
    
    Create("UICorner", {
        Parent = window.MinimizeBtn,
        CornerRadius = UDim.new(0, 4)
    })
    
    -- Close Button
    window.CloseBtn = Create("TextButton", {
        Parent = window.ButtonsContainer,
        Size = UDim2.new(0, 25, 0, 25),
        Position = UDim2.new(1, -25, 0, 0),
        BackgroundColor3 = Color3.fromRGB(255, 70, 70),
        Text = "×",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        Font = Enum.Font.GothamBold
    })
    
    Create("UICorner", {
        Parent = window.CloseBtn,
        CornerRadius = UDim.new(0, 4)
    })
    
    -- Container
    window.Container = Create("Frame", {
        Name = "Container",
        Parent = window.MainFrame,
        Size = UDim2.new(1, -20, 1, -45),
        Position = UDim2.new(0, 10, 0, 35),
        BackgroundTransparency = 1
    })
    
    -- Tabs Container
    window.TabsContainer = Create("Frame", {
        Name = "TabsContainer",
        Parent = window.Container,
        Size = UDim2.new(0, 120, 1, 0),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 0
    })
    
    Create("UICorner", {
        Parent = window.TabsContainer,
        CornerRadius = UDim.new(0, 6)
    })
    
    Create("UIListLayout", {
        Parent = window.TabsContainer,
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    -- Content Container
    window.ContentContainer = Create("Frame", {
        Name = "ContentContainer",
        Parent = window.Container,
        Size = UDim2.new(1, -130, 1, 0),
        Position = UDim2.new(0, 130, 0, 0),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 0
    })
    
    Create("UICorner", {
        Parent = window.ContentContainer,
        CornerRadius = UDim.new(0, 6)
    })
    
    -- Window Methods
    function window:SetTitle(title)
        window.Title.Text = title
    end
    
    function window:SetSubTitle(subtitle)
        window.SubTitle.Text = subtitle
    end
    
    function window:Resize(size)
        Tween(window.MainFrame, 0.3, {Size = size})
    end
    
    function window:Minimize()
        local size = window.MainFrame.Size
        if size.Y.Offset > 35 then
            window.previousSize = size
            Tween(window.MainFrame, 0.3, {Size = UDim2.new(0, size.X.Offset, 0, 35)})
        else
            Tween(window.MainFrame, 0.3, {Size = window.previousSize or UDim2.new(0, 470, 0, 340)})
        end
    end
    
    function window:Close()
        Tween(window.MainFrame, 0.3, {Size = UDim2.new(0, 0, 0, 0)}).Completed:Connect(function()
            window.ScreenGui:Destroy()
        end)
    end
    
    -- Dragging
    local dragging = false
    local dragInput
    local dragStart
    local startPos
    
    window.Titlebar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = window.MainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            window.MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Button Events
    window.MinimizeBtn.MouseButton1Click:Connect(function()
        window:Minimize()
    end)
    
    window.CloseBtn.MouseButton1Click:Connect(function()
        window:Close()
    end)
    
    -- Tabs
    window.Tabs = {}
    window.ActiveTab = nil
    
    function window:MakeTab(config)
        local tab = {}
        
        -- Tab Button
        tab.Button = Create("TextButton", {
            Parent = window.TabsContainer,
            Size = UDim2.new(1, -10, 0, 30),
            Position = UDim2.new(0, 5, 0, 5 + (#window.Tabs * 35)),
            BackgroundColor3 = Color3.fromRGB(35, 35, 35),
            Text = config.Name or "New Tab",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 14,
            Font = Enum.Font.Gotham
        })
        
        Create("UICorner", {
            Parent = tab.Button,
            CornerRadius = UDim.new(0, 6)
        })
        
        -- Tab Content
        tab.Content = Create("ScrollingFrame", {
            Parent = window.ContentContainer,
            Size = UDim2.new(1, -10, 1, -10),
            Position = UDim2.new(0, 5, 0, 5),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 2,
            Visible = #window.Tabs == 0,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y
        })
        
        Create("UIListLayout", {
            Parent = tab.Content,
            Padding = UDim.new(0, 5),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        
        -- Tab Methods
        function tab:Section(config)
            local section = {}
            
            section.Frame = Create("Frame", {
                Parent = tab.Content,
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            })
            
            Create("UICorner", {
                Parent = section.Frame,
                CornerRadius = UDim.new(0, 6)
            })
            
            section.Title = Create("TextLabel", {
                Parent = section.Frame,
                Size = UDim2.new(1, -20, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = config.Name or "Section",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            if config.Desc then
                section.Description = Create("TextLabel", {
                    Parent = section.Frame,
                    Size = UDim2.new(1, -20, 0, 20),
                    Position = UDim2.new(0, 10, 1, -20),
                    BackgroundTransparency = 1,
                    Text = config.Desc,
                    TextColor3 = Color3.fromRGB(200, 200, 200),
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                section.Frame.Size = UDim2.new(1, 0, 0, 55)
            end
            
            return section
        end
        
        function tab:Toggle(config)
            local toggle = {}
            
            toggle.Frame = Create("Frame", {
                Parent = tab.Content,
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            })
            
            Create("UICorner", {
                Parent = toggle.Frame,
                CornerRadius = UDim.new(0, 6)
            })
            
            toggle.Title = Create("TextLabel", {
                Parent = toggle.Frame,
                Size = UDim2.new(1, -60, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = config.Name or "Toggle",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            toggle.Button = Create("TextButton", {
                Parent = toggle.Frame,
                Size = UDim2.new(0, 40, 0, 20),
                Position = UDim2.new(1, -50, 0.5, -10),
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                Text = "",
                AutoButtonColor = false
            })
            
            Create("UICorner", {
                Parent = toggle.Button,
                CornerRadius = UDim.new(0, 10)
            })
            
            toggle.Indicator = Create("Frame", {
                Parent = toggle.Button,
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(0, 2, 0.5, -8),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            })
            
            Create("UICorner", {
                Parent = toggle.Indicator,
                CornerRadius = UDim.new(1, 0)
            })
            
            -- Toggle State
            toggle.Value = config.Default or false
            toggle.Locked = false
            
            function toggle:Set(value)
                if toggle.Locked then return end
                toggle.Value = value
                
                Tween(toggle.Indicator, 0.3, {
                    Position = UDim2.new(0, value and 22 or 2, 0.5, -8),
                    BackgroundColor3 = value and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
                })
                
                if config.Callback then
                    config.Callback(value)
                end
            end
            
            function toggle:Get()
                return toggle.Value
            end
            
            function toggle:Lock()
                toggle.Locked = true
                toggle.Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            end
            
            function toggle:Unlock()
                toggle.Locked = false
                toggle.Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            end
            
            toggle.Button.MouseButton1Click:Connect(function()
                if not toggle.Locked then
                    toggle:Set(not toggle.Value)
                end
            end)
            
            toggle:Set(toggle.Value)
            return toggle
        end
        
        function tab:Slider(config)
            local slider = {}
            
            slider.Frame = Create("Frame", {
                Parent = tab.Content,
                Size = UDim2.new(1, 0, 0, 50),
                BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            })
            
            Create("UICorner", {
                Parent = slider.Frame,
                CornerRadius = UDim.new(0, 6)
            })
            
            slider.Title = Create("TextLabel", {
                Parent = slider.Frame,
                Size = UDim2.new(1, -20, 0, 25),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = config.Name or "Slider",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            slider.Background = Create("Frame", {
                Parent = slider.Frame,
                Size = UDim2.new(1, -20, 0, 10),
                Position = UDim2.new(0, 10, 1, -15),
                BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            })
            
            Create("UICorner", {
                Parent = slider.Background,
                CornerRadius = UDim.new(0, 5)
            })
            
            slider.Fill = Create("Frame", {
                Parent = slider.Background,
                Size = UDim2.new(0, 0, 1, 0),
                BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            })
            
            Create("UICorner", {
                Parent = slider.Fill,
                CornerRadius = UDim.new(0, 5)
            })
            
            slider.Value = Create("TextLabel", {
                Parent = slider.Frame,
                Size = UDim2.new(0, 50, 0, 25),
                Position = UDim2.new(1, -60, 0, 0),
                BackgroundTransparency = 1,
                Text = tostring(config.Default or config.Min or 0),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                Font = Enum.Font.Gotham
            })
            
            -- Slider Properties
            slider.Min = config.Min or 0
            slider.Max = config.Max or 100
            slider.Current = config.Default or slider.Min
            slider.Locked = false
            
            function slider:Set(value)
                if slider.Locked then return end
                value = math.clamp(value, slider.Min, slider.Max)
                slider.Current = value
                
                local percent = (value - slider.Min) / (slider.Max - slider.Min)
                Tween(slider.Fill, 0.3, {
                    Size = UDim2.new(percent, 0, 1, 0)
                })
                
                slider.Value.Text = tostring(math.floor(value))
                
                if config.Callback then
                    config.Callback(value)
                end
            end
            
            function slider:Get()
                return slider.Current
            end
            
            function slider:Lock()
                slider.Locked = true
                slider.Background.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            end
            
            function slider:Unlock()
                slider.Locked = false
                slider.Background.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            end
            
            -- Slider Interaction
            local dragging = false
            
            slider.Background.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and not slider.Locked then
                    dragging = true
                    local pos = input.Position.X
                    local start = slider.Background.AbsolutePosition.X
                    local width = slider.Background.AbsoluteSize.X
                    local percent = math.clamp((pos - start) / width, 0, 1)
                    local value = slider.Min + (slider.Max - slider.Min) * percent
                    slider:Set(value)
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local pos = input.Position.X
                    local start = slider.Background.AbsolutePosition.X
                    local width = slider.Background.AbsoluteSize.X
                    local percent = math.clamp((pos - start) / width, 0, 1)
                    local value = slider.Min + (slider.Max - slider.Min) * percent
                    slider:Set(value)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            slider:Set(slider.Current)
            return slider
        end
        
        function tab:Button(config)
            local button = {}
            
            button.Frame = Create("Frame", {
                Parent = tab.Content,
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            })
            
            Create("UICorner", {
                Parent = button.Frame,
                CornerRadius = UDim.new(0, 6)
            })
            
            button.Button = Create("TextButton", {
                Parent = button.Frame,
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = config.Name or "Button",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                Font = Enum.Font.Gotham
            })
            
            function button:SetTitle(text)
                button.Button.Text = text
            end
            
            function button:SetDesc(desc)
                if not button.Description then
                    button.Description = Create("TextLabel", {
                        Parent = button.Frame,
                        Size = UDim2.new(1, -20, 0, 20),
                        Position = UDim2.new(0, 10, 1, -20),
                        BackgroundTransparency = 1,
                        Text = desc,
                        TextColor3 = Color3.fromRGB(200, 200, 200),
                        TextSize = 12,
                        Font = Enum.Font.Gotham,
                        TextXAlignment = Enum.TextXAlignment.Left
                    })
                    
                    button.Frame.Size = UDim2.new(1, 0, 0, 55)
                else
                    button.Description.Text = desc
                end
            end
            
            button.Button.MouseButton1Click:Connect(function()
                if config.Callback then
                    config.Callback()
                end
            end)
            
            return button
        end
        
        function tab:Dropdown(config)
            local dropdown = {}
            
            dropdown.Frame = Create("Frame", {
                Parent = tab.Content,
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                ClipsDescendants = true
            })
            
            Create("UICorner", {
                Parent = dropdown.Frame,
                CornerRadius = UDim.new(0, 6)
            })
            
            dropdown.Button = Create("TextButton", {
                Parent = dropdown.Frame,
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundTransparency = 1,
                Text = config.Name or "Dropdown",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                Font = Enum.Font.Gotham
            })
            
            dropdown.Container = Create("Frame", {
                Parent = dropdown.Frame,
                Size = UDim2.new(1, -10, 0, 0),
                Position = UDim2.new(0, 5, 0, 35),
                BackgroundTransparency = 1
            })
            
            Create("UIListLayout", {
                Parent = dropdown.Container,
                Padding = UDim.new(0, 5),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
            
            -- Dropdown Properties
            dropdown.Options = config.Options or {}
            dropdown.Value = config.Default or dropdown.Options[1]
            dropdown.Open = false
            
            function dropdown:Toggle()
                dropdown.Open = not dropdown.Open
                
                Tween(dropdown.Frame, 0.3, {
                    Size = UDim2.new(1, 0, 0, dropdown.Open and (40 + (#dropdown.Options * 25)) or 35)
                })
            end
            
            function dropdown:Add(option)
                if not table.find(dropdown.Options, option) then
                    table.insert(dropdown.Options, option)
                    
                    local button = Create("TextButton", {
                        Parent = dropdown.Container,
                        Size = UDim2.new(1, 0, 0, 20),
                        BackgroundColor3 = Color3.fromRGB(45, 45, 45),
                        Text = option,
                        TextColor3 = Color3.fromRGB(255, 255, 255),
                        TextSize = 12,
                        Font = Enum.Font.Gotham
                    })
                    
                    Create("UICorner", {
                        Parent = button,
                        CornerRadius = UDim.new(0, 4)
                    })
                    
                    button.MouseButton1Click:Connect(function()
                        dropdown:Set(option)
                        dropdown:Toggle()
                    end)
                end
            end
            
            function dropdown:Remove(option)
                local index = table.find(dropdown.Options, option)
                if index then
                    table.remove(dropdown.Options, index)
                    dropdown.Container:GetChildren()[index + 1]:Destroy()
                end
            end
            
            function dropdown:Clear()
                dropdown.Options = {}
                for _, child in ipairs(dropdown.Container:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
            end
            
            function dropdown:Set(value)
                if table.find(dropdown.Options, value) then
                    dropdown.Value = value
                    dropdown.Button.Text = value
                    
                    if config.Callback then
                        config.Callback(value)
                    end
                end
            end
            
            function dropdown:Get()
                return dropdown.Value
            end
            
            -- Initialize Options
            for _, option in ipairs(dropdown.Options) do
                dropdown:Add(option)
            end
            
            dropdown.Button.MouseButton1Click:Connect(function()
                dropdown:Toggle()
            end)
            
            if dropdown.Value then
                dropdown:Set(dropdown.Value)
            end
            
            return dropdown
        end
        
        function tab:ColorPicker(config)
            local colorPicker = {}
            
            colorPicker.Frame = Create("Frame", {
                Parent = tab.Content,
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            })
            
            Create("UICorner", {
                Parent = colorPicker.Frame,
                CornerRadius = UDim.new(0, 6)
            })
            
            colorPicker.Title = Create("TextLabel", {
                Parent = colorPicker.Frame,
                Size = UDim2.new(1, -60, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = config.Name or "Color Picker",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            colorPicker.Display = Create("Frame", {
                Parent = colorPicker.Frame,
                Size = UDim2.new(0, 30, 0, 30),
                Position = UDim2.new(1, -40, 0.5, -15),
                BackgroundColor3 = config.Default or Color3.fromRGB(255, 0, 0)
            })
            
            Create("UICorner", {
                Parent = colorPicker.Display,
                CornerRadius = UDim.new(0, 4)
            })
            
            -- Color Picker Properties
            colorPicker.Color = config.Default or Color3.fromRGB(255, 0, 0)
            colorPicker.Locked = false
            
            function colorPicker:Set(color)
                if colorPicker.Locked then return end
                colorPicker.Color = color
                colorPicker.Display.BackgroundColor3 = color
                
                if config.Callback then
                    config.Callback(color)
                end
            end
            
            function colorPicker:Get()
                return colorPicker.Color
            end
            
            function colorPicker:Lock()
                colorPicker.Locked = true
                colorPicker.Display.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            end
            
            function colorPicker:Unlock()
                colorPicker.Locked = false
                colorPicker.Display.BackgroundColor3 = colorPicker.Color
            end
            
            colorPicker.Display.MouseButton1Click:Connect(function()
                if not colorPicker.Locked then
                    -- Here you would implement a color picker UI
                    -- For this example, we'll just cycle through some colors
                    local colors = {
                        Color3.fromRGB(255, 0, 0),
                        Color3.fromRGB(0, 255, 0),
                        Color3.fromRGB(0, 0, 255),
                        Color3.fromRGB(255, 255, 0),
                        Color3.fromRGB(0, 255, 255),
                        Color3.fromRGB(255, 0, 255)
                    }
                    
                    local current = table.find(colors, colorPicker.Color) or 0
                    current = (current % #colors) + 1
                    colorPicker:Set(colors[current])
                end
            end)
            
            return colorPicker
        end
        
        function tab:Keybind(config)
            local keybind = {}
            
            keybind.Frame = Create("Frame", {
                Parent = tab.Content,
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            })
            
            Create("UICorner", {
                Parent = keybind.Frame,
                CornerRadius = UDim.new(0, 6)
            })
            
            keybind.Title = Create("TextLabel", {
                Parent = keybind.Frame,
                Size = UDim2.new(1, -110, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = config.Name or "Keybind",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            keybind.Button = Create("TextButton", {
                Parent = keybind.Frame,
                Size = UDim2.new(0, 90, 0, 25),
                Position = UDim2.new(1, -100, 0.5, -12),
                BackgroundColor3 = Color3.fromRGB(45, 45, 45),
                Text = config.Default and config.Default.Name or "None",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 12,
                Font = Enum.Font.Gotham
            })
            
            Create("UICorner", {
                Parent = keybind.Button,
                CornerRadius = UDim.new(0, 4)
            })
            
            -- Keybind Properties
            keybind.Key = config.Default
            keybind.Listening = false
            keybind.Locked = false
            
            function keybind:Set(key)
                if keybind.Locked then return end
                keybind.Key = key
                keybind.Button.Text = key and key.Name or "None"
                
                if config.Callback then
                    config.Callback(key)
                end
            end
            
            function keybind:Get()
                return keybind.Key
            end
            
            function keybind:Lock()
                keybind.Locked = true
                keybind.Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            end
            
            function keybind:Unlock()
                keybind.Locked = false
                keybind.Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            end
            
            -- Keybind Input
            keybind.Button.MouseButton1Click:Connect(function()
                if not keybind.Locked then
                    keybind.Listening = true
                    keybind.Button.Text = "..."
                end
            end)
            
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if not gameProcessed then
                    if keybind.Listening then
                        if input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode ~= Enum.KeyCode.Escape then
                            keybind:Set(input.KeyCode)
                        else
                            keybind:Set(nil)
                        end
                        keybind.Listening = false
                    elseif input.KeyCode == keybind.Key then
                        if config.Callback then
                            config.Callback(keybind.Key)
                        end
                    end
                end
            end)
            
            return keybind
        end
        
        -- Tab Selection
        tab.Button.MouseButton1Click:Connect(function()
            for _, otherTab in pairs(window.Tabs) do
                otherTab.Content.Visible = false
                otherTab.Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            end
            tab.Content.Visible = true
            tab.Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        end)
        
        table.insert(window.Tabs, tab)
        return tab
    end
    
    -- Notification System
    function window:Notify(config)
        local notification = {}
        
        notification.Frame = Create("Frame", {
            Parent = window.ScreenGui,
            Size = UDim2.new(0, 250, 0, 60),
            Position = UDim2.new(1, 20, 1, -70),
            BackgroundColor3 = Color3.fromRGB(35, 35, 35),
            BorderSizePixel = 0
        })
        
        Create("UICorner", {
            Parent = notification.Frame,
            CornerRadius = UDim.new(0, 6)
        })
        
        notification.Title = Create("TextLabel", {
            Parent = notification.Frame,
            Size = UDim2.new(1, -20, 0, 25),
            Position = UDim2.new(0, 10, 0, 5),
            BackgroundTransparency = 1,
            Text = config.Title or "Notification",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 14,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        notification.Description = Create("TextLabel", {
            Parent = notification.Frame,
            Size = UDim2.new(1, -20, 0, 20),
            Position = UDim2.new(0, 10, 0, 30),
            BackgroundTransparency = 1,
            Text = config.Description or "",
            TextColor3 = Color3.fromRGB(200, 200, 200),
            TextSize = 12,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        -- Animation
        Tween(notification.Frame, 0.5, {
            Position = UDim2.new(1, -270, 1, -70)
        })
        
        -- Auto Remove
        task.delay(config.Duration or 3, function()
            Tween(notification.Frame, 0.5, {
                Position = UDim2.new(1, 20, 1, -70)
            }).Completed:Connect(function()
                notification.Frame:Destroy()
            end)
        end)
        
        return notification
    end
    
    return window
end

return DoorLib
