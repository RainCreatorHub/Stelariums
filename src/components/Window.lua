-- Stell UI Library | Created by Grok
-- Version: 1.1
-- Description: A modular UI library for creating customizable windows, tabs, and buttons in Roblox, without animation features.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Stell Library
local Stell = {}

-- Default Configuration
Stell.DefaultConfig = {
    WindowTitle = "Window",
    WindowSubtitle = "",
    Theme = "Dark",
    Logo = "",
    Resizable = true,
    Transparency = false,
    DefaultOpened = true,
    DefaultSize = {500, 350},
    MinSize = {300, 200},
    MaxSize = {800, 600},
    ToggleKey = Enum.KeyCode.F,
    Colors = {
        Dark = {
            Background = Color3.fromRGB(28, 29, 32),
            Header = Color3.fromRGB(35, 37, 40),
            PrimaryText = Color3.fromRGB(255, 255, 255),
            Button = Color3.fromRGB(55, 58, 64),
            ButtonHover = Color3.fromRGB(75, 78, 84),
            TabActive = Color3.fromRGB(88, 101, 242),
            TabInactive = Color3.fromRGB(55, 58, 64),
            CloseButton = Color3.fromRGB(237, 66, 69),
            LockedButton = Color3.fromRGB(100, 100, 100)
        },
        Light = {
            Background = Color3.fromRGB(240, 240, 240),
            Header = Color3.fromRGB(200, 200, 200),
            PrimaryText = Color3.fromRGB(0, 0, 0),
            Button = Color3.fromRGB(180, 180, 180),
            ButtonHover = Color3.fromRGB(160, 160, 160),
            TabActive = Color3.fromRGB(88, 101, 242),
            TabInactive = Color3.fromRGB(180, 180, 180),
            CloseButton = Color3.fromRGB(237, 66, 69),
            LockedButton = Color3.fromRGB(150, 150, 150)
        }
    },
    Icons = {
        Move = "rbxassetid://5122394512"
    }
}

-- Internal state
local mainFrameVisible = true
local currentTab = nil

-- Utility function to create UI elements
local function createElement(className, properties)
    local element = Instance.new(className)
    for prop, value in pairs(properties) do
        element[prop] = value
    end
    return element
end

-- Function to make a frame draggable
local function makeDraggable(guiObject, dragHandle)
    local dragging = false
    local dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        guiObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = guiObject.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
end

-- Function to make a frame resizable
local function makeResizable(guiObject, minSize, maxSize)
    local resizeButton = createElement("TextButton", {
        Name = "ResizeButton",
        Parent = guiObject,
        Size = UDim2.new(0, 15, 0, 15),
        Position = UDim2.new(1, -15, 1, -15),
        AnchorPoint = Vector2.new(1, 1),
        BackgroundColor3 = Color3.fromRGB(100, 100, 100),
        Text = "",
        AutoButtonColor = false
    })
    createElement("UICorner", {CornerRadius = UDim.new(0, 4), Parent = resizeButton})

    local resizing = false
    local resizeStart, startSize
    resizeButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            resizeStart = input.Position
            startSize = guiObject.Size
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if resizing then
            local delta = input.Position - resizeStart
            local newWidth = math.clamp(startSize.X.Offset + delta.X, minSize[1], maxSize[1])
            local newHeight = math.clamp(startSize.Y.Offset + delta.Y, minSize[2], maxSize[2])
            guiObject.Size = UDim2.new(0, newWidth, 0, newHeight)
        end
    end)
    resizeButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = false
        end
    end)
end

-- Stell:Window method
function Stell:Window(info)
    info = info or {}
    local config = {
        Title = info.Title or Stell.DefaultConfig.WindowTitle,
        Subtitle = info.Subtitle or Stell.DefaultConfig.WindowSubtitle,
        Theme = info.Theme or Stell.DefaultConfig.Theme,
        Logo = info.Logo or Stell.DefaultConfig.Logo,
        Resizable = info.Resizable ~= nil and info.Resizable or Stell.DefaultConfig.Resizable,
        Transparency = info.Transparency or Stell.DefaultConfig.Transparency,
        DefaultOpened = info.DefaultOpened ~= nil and info.DefaultOpened or Stell.DefaultConfig.DefaultOpened,
        DefaultSize = info.DefaultSize or Stell.DefaultConfig.DefaultSize,
        MinSize = info.MinSize or Stell.DefaultConfig.MinSize,
        MaxSize = info.MaxSize or Stell.DefaultConfig.MaxSize,
        ToggleKey = Stell.DefaultConfig.ToggleKey,
        Colors = Stell.DefaultConfig.Colors[info.Theme or "Dark"] or Stell.DefaultConfig.Colors.Dark,
        Icons = Stell.DefaultConfig.Icons
    }

    local gui = {}

    -- Create main GUI
    gui.ScreenGui = createElement("ScreenGui", {
        Name = "StellGui",
        Parent = playerGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        IgnoreGuiInset = true
    })

    gui.MainFrame = createElement("Frame", {
        Name = "MainFrame",
        Parent = gui.ScreenGui,
        Size = UDim2.new(0, config.DefaultSize[1], 0, config.DefaultSize[2]),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundColor3 = config.Colors.Background,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = config.Transparency and 0.3 or 0
    })
    createElement("UICorner", {CornerRadius = UDim.new(0, 8), Parent = gui.MainFrame})

    -- Header
    gui.Header = createElement("Frame", {
        Name = "Header",
        Parent = gui.MainFrame,
        Size = UDim2.new(1, 0, 0, config.Subtitle ~= "" and 60 or 40),
        BackgroundColor3 = config.Colors.Header,
        BorderSizePixel = 0
    })
    createElement("UICorner", {CornerRadius = UDim.new(0, 6), Parent = gui.Header})

    gui.Title = createElement("TextLabel", {
        Name = "Title",
        Parent = gui.Header,
        Size = UDim2.new(1, -50, config.Subtitle ~= "" and 0.5 or 1, 0),
        Position = UDim2.new(0, config.Logo ~= "" and 50 or 15, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Title,
        TextColor3 = config.Colors.PrimaryText,
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    if config.Subtitle ~= "" then
        gui.Subtitle = createElement("TextLabel", {
            Name = "Subtitle",
            Parent = gui.Header,
            Size = UDim2.new(1, -50, 0.5, 0),
            Position = UDim2.new(0, config.Logo ~= "" and 50 or 15, 0.5, 0),
            BackgroundTransparency = 1,
            Text = config.Subtitle,
            TextColor3 = config.Colors.PrimaryText,
            Font = Enum.Font.Gotham,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        })
    end

    if config.Logo ~= "" then
        gui.Logo = createElement("ImageLabel", {
            Name = "Logo",
            Parent = gui.Header,
            Size = UDim2.new(0, 30, 0, 30),
            Position = UDim2.new(0, 10, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundTransparency = 1,
            Image = config.Logo
        })
    end

    gui.CloseButton = createElement("TextButton", {
        Name = "CloseButton",
        Parent = gui.Header,
        Size = UDim2.new(0, 25, 0, 25),
        Position = UDim2.new(1, -15, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = config.Colors.Button,
        Text = "X",
        TextColor3 = config.Colors.PrimaryText,
        Font = Enum.Font.GothamBold,
        TextSize = 14
    })
    createElement("UICorner", {CornerRadius = UDim.new(0, 6), Parent = gui.CloseButton})

    -- Body
    gui.Body = createElement("Frame", {
        Name = "Body",
        Parent = gui.MainFrame,
        Size = UDim2.new(1, 0, 1, config.Subtitle ~= "" and -60 or -40),
        Position = UDim2.new(0, 0, 0, config.Subtitle ~= "" and 60 or 40),
        BackgroundTransparency = 1
    })

    gui.TabsContainer = createElement("Frame", {
        Name = "TabsContainer",
        Parent = gui.Body,
        Size = UDim2.new(0, 60, 1, 0),
        BackgroundColor3 = config.Colors.Header,
        BorderSizePixel = 0
    })
    createElement("UIListLayout", {
        Parent = gui.TabsContainer,
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10)
    })
    createElement("UIPadding", {Parent = gui.TabsContainer, PaddingTop = UDim.new(0, 10)})

    -- Content Frame
    gui.ContentFrame = createElement("Frame", {
        Name = "Content",
        Parent = gui.Body,
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 60, 0, 0),
        BackgroundTransparency = 1
    })
    createElement("UIPadding", {
        Parent = gui.ContentFrame,
        PaddingTop = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10)
    })

    -- Draggable functionality
    if UserInputService.TouchEnabled then
        gui.MoveButton = createElement("ImageButton", {
            Name = "MoveButton",
            Parent = gui.Header,
            Size = UDim2.new(0, 25, 0, 25),
            Position = UDim2.new(1, -50, 0.5, 0),
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundColor3 = config.Colors.Button,
            Image = config.Icons.Move
        })
        createElement("UICorner", {CornerRadius = UDim.new(0, 6), Parent = gui.MoveButton})
        makeDraggable(gui.MainFrame, gui.MoveButton)
    else
        makeDraggable(gui.MainFrame, gui.Header)
    end

    -- Resizable functionality
    if config.Resizable then
        makeResizable(gui.MainFrame, config.MinSize, config.MaxSize)
    end

    -- Tab Management
    gui.Tabs = {}
    function gui:Tab(info)
        info = info or {}
        local tabConfig = {
            Name = info.Name or "Tab",
            Icon = info.Icon or "",
            KeySystem = info.KeySystem or false,
            Key = info.Key or "Hi123"
        }

        -- Key System
        local keyValid = not tabConfig.KeySystem
        local keyPrompt, submitButton
        if tabConfig.KeySystem then
            keyPrompt = createElement("TextBox", {
                Name = "KeyPrompt",
                Parent = gui.ContentFrame,
                Size = UDim2.new(1, -20, 0, 30),
                Position = UDim2.new(0, 10, 0, 10),
                BackgroundColor3 = config.Colors.Button,
                Text = "Enter Key",
                TextColor3 = config.Colors.PrimaryText,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                Visible = false
            })
            createElement("UICorner", {CornerRadius = UDim.new(0, 6), Parent = keyPrompt})

            submitButton = createElement("TextButton", {
                Name = "SubmitKey",
                Parent = gui.ContentFrame,
                Size = UDim2.new(0, 100, 0, 30),
                Position = UDim2.new(0, 10, 0, 50),
                BackgroundColor3 = config.Colors.Button,
                Text = "Submit",
                TextColor3 = config.Colors.PrimaryText,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                Visible = false
            })
            createElement("UICorner", {CornerRadius = UDim.new(0, 6), Parent = submitButton})

            submitButton.MouseButton1Click:Connect(function()
                if keyPrompt.Text == tabConfig.Key then
                    keyValid = true
                    keyPrompt.Visible = false
                    submitButton.Visible = false
                    for _, t in pairs(gui.Tabs) do
                        t.Content.Visible = (t == gui.Tabs[tabConfig.Name]) and keyValid
                    end
                else
                    keyPrompt.Text = "Invalid Key"
                    wait(1)
                    keyPrompt.Text = "Enter Key"
                end
            end)
        end

        local tab = {}
        tab.Button = createElement("ImageButton", {
            Name = tabConfig.Name .. "Button",
            Parent = gui.TabsContainer,
            Size = UDim2.new(0, 40, 0, 40),
            BackgroundColor3 = config.Colors.TabInactive,
            Image = tabConfig.Icon,
            LayoutOrder = #gui.Tabs + 1
        })
        createElement("UICorner", {CornerRadius = UDim.new(0, 6), Parent = tab.Button})

        tab.Content = createElement("ScrollingFrame", {
            Name = tabConfig.Name .. "_Content",
            Parent = gui.ContentFrame,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarImageColor3 = config.Colors.ButtonHover,
            ScrollBarThickness = 5
        })
        createElement("UIGridLayout", {
            Parent = tab.Content,
            CellPadding = UDim2.new(0, 8, 0, 8),
            CellSize = UDim2.new(0, 100, 0, 35),
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        -- Tab switching
        tab.Button.MouseButton1Click:Connect(function()
            if tabConfig.KeySystem and not keyValid then
                keyPrompt.Visible = true
                submitButton.Visible = true
                return
            end
            for _, t in pairs(gui.Tabs) do
                t.Content.Visible = false
                t.Button.BackgroundColor3 = config.Colors.TabInactive
            end
            tab.Content.Visible = true
            tab.Button.BackgroundColor3 = config.Colors.TabActive
            currentTab = tabConfig.Name
        end)

        -- Button creation method
        function tab:Button(info)
            info = info or {}
            local buttonConfig = {
                Name = info.Name or "Button",
                Desc = info.Desc or "",
                Locked = info.Locked or false,
                Visible = info.Visible ~= nil and info.Visible or true,
                Callback = info.Callback or function() print("Button clicked!") end
            }

            local buttonFrame = createElement("Frame", {
                Name = buttonConfig.Name .. "_Frame",
                Parent = tab.Content,
                Size = UDim2.new(0, 100, 0, buttonConfig.Desc ~= "" and 50 or 35),
                BackgroundTransparency = 1,
                Visible = buttonConfig.Visible
            })

            local button = createElement("TextButton", {
                Name = buttonConfig.Name,
                Parent = buttonFrame,
                Size = UDim2.new(1, 0, buttonConfig.Desc ~= "" and 0.7 or 1, 0),
                BackgroundColor3 = buttonConfig.Locked and config.Colors.LockedButton or config.Colors.Button,
                Text = buttonConfig.Name,
                TextColor3 = config.Colors.PrimaryText,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                AutoButtonColor = not buttonConfig.Locked
            })
            createElement("UICorner", {CornerRadius = UDim.new(0, 6), Parent = button})

            if buttonConfig.Desc ~= "" then
                local descLabel = createElement("TextLabel", {
                    Name = buttonConfig.Name .. "_Desc",
                    Parent = buttonFrame,
                    Size = UDim2.new(1, 0, 0.3, 0),
                    Position = UDim2.new(0, 0, 0.7, 0),
                    BackgroundTransparency = 1,
                    Text = buttonConfig.Desc,
                    TextColor3 = config.Colors.PrimaryText,
                    Font = Enum.Font.Gotham,
                    TextSize = 10,
                    TextWrapped = true,
                    TextXAlignment = Enum.TextXAlignment.Center
                })
            end

            if not buttonConfig.Locked then
                button.MouseButton1Click:Connect(function()
                    buttonConfig.Callback()
                end)
                button.MouseEnter:Connect(function()
                    TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = config.Colors.ButtonHover}):Play()
                end)
                button.MouseLeave:Connect(function()
                    TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = config.Colors.Button}):Play()
                end)
            end

            return button
        end

        gui.Tabs[tabConfig.Name] = tab
        return tab
    end

    -- Toggle Window
    function gui:Toggle(state)
        mainFrameVisible = state
        gui.MainFrame.Visible = state
    end

    -- Close Button Functionality
    gui.CloseButton.MouseButton1Click:Connect(function()
        gui:Toggle(false)
    end)
    gui.CloseButton.MouseEnter:Connect(function()
        TweenService:Create(gui.CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = config.Colors.CloseButton}):Play()
    end)
    gui.CloseButton.MouseLeave:Connect(function()
        TweenService:Create(gui.CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = config.Colors.Button}):Play()
    end)

    -- Toggle Key Binding
    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if gameProcessedEvent then return end
        if input.KeyCode == config.ToggleKey then
            gui:Toggle(not mainFrameVisible)
        end
    end)

    -- Set initial visibility
    gui:Toggle(config.DefaultOpened)

    return gui
end

-- Initialize Stell UI with an empty window
function Stell:Init(customConfig)
    local config = customConfig or {}
    local gui = self:Window({
        Title = config.Title or Stell.DefaultConfig.WindowTitle,
        Subtitle = config.Subtitle or Stell.DefaultConfig.WindowSubtitle,
        Theme = config.Theme or Stell.DefaultConfig.Theme,
        Logo = config.Logo or Stell.DefaultConfig.Logo,
        Resizable = config.Resizable ~= nil and config.Resizable or Stell.DefaultConfig.Resizable,
        Transparency = config.Transparency or Stell.DefaultConfig.Transparency,
        DefaultOpened = config.DefaultOpened ~= nil and config.DefaultOpened or Stell.DefaultConfig.DefaultOpened,
        DefaultSize = config.DefaultSize or Stell.DefaultConfig.DefaultSize,
        MinSize = config.MinSize or Stell.DefaultConfig.MinSize,
        MaxSize = config.MaxSize or Stell.DefaultConfig.MaxSize
    })

    print("Stell UI Library v1.1 initialized.")
    return gui
end

return Stell
