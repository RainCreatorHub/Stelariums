-- Stell UI Library | Created by Grok
-- Version: 1.3
-- Description: A modular UI library for creating customizable windows, tabs, and buttons in Roblox,
--              with text-based tabs (no icons), enhanced layouts, and detailed functionality.
-- Last Updated: August 19, 2025, 07:21 PM -03

local Players = game:GetService("Players") -- Service to access player data
local TweenService = game:GetService("TweenService") -- Service for smooth color transitions
local UserInputService = game:GetService("UserInputService") -- Service to handle user input

-- Get the local player and their PlayerGui for UI rendering
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Define the main Stell library table
local Stell = {}

-- Default Configuration Table
-- This table contains all default settings for windows, tabs, and buttons
Stell.DefaultConfig = {
    WindowTitle = "Stell Interface", -- Default window title
    WindowSubtitle = "", -- Default subtitle (empty by default)
    Theme = "Dark", -- Default theme ("Dark" or "Light")
    Logo = "", -- Default logo image (rbxassetid, empty by default)
    Resizable = true, -- Enable window resizing
    Transparency = false, -- Enable window transparency
    DefaultOpened = true, -- Window visible by default
    DefaultSize = {550, 400}, -- Default width and height (in pixels)
    MinSize = {350, 250}, -- Minimum allowable size
    MaxSize = {900, 700}, -- Maximum allowable size
    ToggleKey = Enum.KeyCode.F, -- Key to toggle window visibility

    -- Color schemes for different themes
    Colors = {
        Dark = {
            Background = Color3.fromRGB(28, 29, 32), -- Main window background
            Header = Color3.fromRGB(35, 37, 40), -- Header background
            PrimaryText = Color3.fromRGB(255, 255, 255), -- Main text color
            SecondaryText = Color3.fromRGB(200, 200, 200), -- Secondary text color (e.g., descriptions)
            Button = Color3.fromRGB(55, 58, 64), -- Default button color
            ButtonHover = Color3.fromRGB(75, 78, 84), -- Button color on hover
            TabActive = Color3.fromRGB(88, 101, 242), -- Active tab color
            TabInactive = Color3.fromRGB(55, 58, 64), -- Inactive tab color
            CloseButton = Color3.fromRGB(237, 66, 69), -- Close button color
            LockedButton = Color3.fromRGB(100, 100, 100) -- Locked button color
        },
        Light = {
            Background = Color3.fromRGB(240, 240, 240), -- Main window background
            Header = Color3.fromRGB(200, 200, 200), -- Header background
            PrimaryText = Color3.fromRGB(0, 0, 0), -- Main text color
            SecondaryText = Color3.fromRGB(100, 100, 100), -- Secondary text color
            Button = Color3.fromRGB(180, 180, 180), -- Default button color
            ButtonHover = Color3.fromRGB(160, 160, 160), -- Button color on hover
            TabActive = Color3.fromRGB(88, 101, 242), -- Active tab color
            TabInactive = Color3.fromRGB(180, 180, 180), -- Inactive tab color
            CloseButton = Color3.fromRGB(237, 66, 69), -- Close button color
            LockedButton = Color3.fromRGB(150, 150, 150) -- Locked button color
        }
    }
}

-- Internal state variables
local mainFrameVisible = true -- Tracks window visibility
local currentTab = nil -- Tracks the currently active tab

-- Utility Function: Creates UI elements with specified properties
local function createElement(className, properties)
    local element = Instance.new(className) -- Create a new instance
    for prop, value in pairs(properties) do -- Apply all properties
        element[prop] = value
    end
    return element
end

-- Function to Make a Frame Draggable
local function makeDraggable(guiObject, dragHandle)
    local dragging = false
    local dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        guiObject.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
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

-- Function to Make a Frame Resizable
local function makeResizable(guiObject, minSize, maxSize)
    local resizeButton = createElement("TextButton", {
        Name = "ResizeButton",
        Parent = guiObject,
        Size = UDim2.new(0, 15, 0, 15),
        Position = UDim2.new(1, -15, 1, -15),
        AnchorPoint = Vector2.new(1, 1),
        BackgroundColor3 = Color3.fromRGB(120, 120, 120),
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

-- Stell:Window Method
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
        Colors = Stell.DefaultConfig.Colors[info.Theme or "Dark"] or Stell.DefaultConfig.Colors.Dark
    }

    local gui = {}

    -- Create ScreenGui
    gui.ScreenGui = createElement("ScreenGui", {
        Name = "StellGui",
        Parent = playerGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        IgnoreGuiInset = true
    })

    -- Create MainFrame
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

    -- Create Header
    gui.Header = createElement("Frame", {
        Name = "Header",
        Parent = gui.MainFrame,
        Size = UDim2.new(1, 0, 0, config.Subtitle ~= "" and 60 or 40),
        BackgroundColor3 = config.Colors.Header,
        BorderSizePixel = 0
    })
    createElement("UICorner", {CornerRadius = UDim.new(0, 6), Parent = gui.Header})

    -- Create Title
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
            TextColor3 = config.Colors.SecondaryText,
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

    -- Create Body
    gui.Body = createElement("Frame", {
        Name = "Body",
        Parent = gui.MainFrame,
        Size = UDim2.new(1, 0, 1, config.Subtitle ~= "" and -60 or -40),
        Position = UDim2.new(0, 0, 0, config.Subtitle ~= "" and 60 or 40),
        BackgroundTransparency = 1
    })

    -- Create TabsContainer
    gui.TabsContainer = createElement("Frame", {
        Name = "TabsContainer",
        Parent = gui.Body,
        Size = UDim2.new(0, 70, 1, 0),
        BackgroundColor3 = config.Colors.Header,
        BorderSizePixel = 0
    })
    createElement("UIListLayout", {
        Parent = gui.TabsContainer,
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })
    createElement("UIPadding", {Parent = gui.TabsContainer, PaddingTop = UDim.new(0, 5)})

    -- Create ContentFrame
    gui.ContentFrame = createElement("Frame", {
        Name = "Content",
        Parent = gui.Body,
        Size = UDim2.new(1, -70, 1, 0),
        Position = UDim2.new(0, 70, 0, 0),
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
        gui.MoveButton = createElement("TextButton", {
            Name = "MoveButton",
            Parent = gui.Header,
            Size = UDim2.new(0, 25, 0, 25),
            Position = UDim2.new(1, -50, 0.5, 0),
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundColor3 = config.Colors.Button,
            Text = "☰", -- Simple move indicator
            TextColor3 = config.Colors.PrimaryText,
            Font = Enum.Font.Gotham,
            TextSize = 14
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
            Name = info.Name or "Tab", -- Tab name displayed as text
            KeySystem = info.KeySystem or false, -- Enable key system
            Key = info.Key or "Hi123" -- Default key
        }

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
        tab.Button = createElement("TextButton", {
            Name = tabConfig.Name .. "Button",
            Parent = gui.TabsContainer,
            Size = UDim2.new(0, 60, 0, 35),
            BackgroundColor3 = config.Colors.TabInactive,
            Text = tabConfig.Name,
            TextColor3 = config.Colors.PrimaryText,
            Font = Enum.Font.Gotham,
            TextSize = 14,
            TextWrapped = true,
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
            ScrollBarThickness = 6
        })
        createElement("UIGridLayout", {
            Parent = tab.Content,
            CellPadding = UDim2.new(0, 10, 0, 10),
            CellSize = UDim2.new(0, 120, 0, 40),
            SortOrder = Enum.SortOrder.LayoutOrder
        })

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
                Size = UDim2.new(0, 120, 0, buttonConfig.Desc ~= "" and 60 or 40),
                BackgroundTransparency = 1,
                Visible = buttonConfig.Visible
            })

            local button = createElement("TextButton", {
                Name = buttonConfig.Name,
                Parent = buttonFrame,
                Size = UDim2.new(1, 0, buttonConfig.Desc ~= "" and 0.6 or 1, 0),
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
                    Size = UDim2.new(1, 0, 0.4, 0),
                    Position = UDim2.new(0, 0, 0.6, 0),
                    BackgroundTransparency = 1,
                    Text = buttonConfig.Desc,
                    TextColor3 = config.Colors.SecondaryText,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
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

    function gui:Toggle(state)
        mainFrameVisible = state
        gui.MainFrame.Visible = state
    end

    gui.CloseButton.MouseButton1Click:Connect(function()
        gui:Toggle(false)
    end)
    gui.CloseButton.MouseEnter:Connect(function()
        TweenService:Create(gui.CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = config.Colors.CloseButton}):Play()
    end)
    gui.CloseButton.MouseLeave:Connect(function()
        TweenService:Create(gui.CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = config.Colors.Button}):Play()
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if gameProcessedEvent then return end
        if input.KeyCode == config.ToggleKey then
            gui:Toggle(not mainFrameVisible)
        end
    end)

    gui:Toggle(config.DefaultOpened)

    return gui
end

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

    print("Stell UI Library v1.3 initialized at " .. os.date("%H:%M, %d/%m/%Y"))
    return gui
end

return Stell
