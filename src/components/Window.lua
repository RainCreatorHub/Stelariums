-- Stell UI Library | Created by Grok
-- Version: 1.2
-- Description: A modular UI library for creating customizable windows, tabs, and buttons in Roblox,
--              designed without animation features and with text-based tabs (no icons).
-- Last Updated: August 19, 2025, 06:45 PM -03

local Players = game:GetService("Players") -- Service to access player data
local TweenService = game:GetService("TweenService") -- Service for smooth color transitions (used for hover effects)
local UserInputService = game:GetService("UserInputService") -- Service to handle user input

-- Get the local player and their PlayerGui for UI rendering
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Define the main Stell library table
local Stell = {}

-- Default Configuration Table
-- This table contains all default settings for windows, tabs, and buttons
Stell.DefaultConfig = {
    WindowTitle = "Stell Window", -- Default title for the window
    WindowSubtitle = "", -- Default subtitle (empty by default)
    Theme = "Dark", -- Default theme ("Dark" or "Light")
    Logo = "", -- Default logo image (empty by default, can be an rbxassetid)
    Resizable = true, -- Whether the window can be resized
    Transparency = false, -- Whether the window has transparency
    DefaultOpened = true, -- Whether the window is visible by default
    DefaultSize = {500, 350}, -- Default width and height (in pixels)
    MinSize = {300, 200}, -- Minimum allowable size (width, height)
    MaxSize = {800, 600}, -- Maximum allowable size (width, height)
    ToggleKey = Enum.KeyCode.F, -- Key to toggle the window visibility

    -- Color schemes for different themes
    Colors = {
        Dark = {
            Background = Color3.fromRGB(28, 29, 32), -- Main window background
            Header = Color3.fromRGB(35, 37, 40), -- Header background
            PrimaryText = Color3.fromRGB(255, 255, 255), -- Text color
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
            PrimaryText = Color3.fromRGB(0, 0, 0), -- Text color
            Button = Color3.fromRGB(180, 180, 180), -- Default button color
            ButtonHover = Color3.fromRGB(160, 160, 160), -- Button color on hover
            TabActive = Color3.fromRGB(88, 101, 242), -- Active tab color
            TabInactive = Color3.fromRGB(180, 180, 180), -- Inactive tab color
            CloseButton = Color3.fromRGB(237, 66, 69), -- Close button color
            LockedButton = Color3.fromRGB(150, 150, 150) -- Locked button color
        }
    },
    Icons = {} -- Removed icon support for tabs, kept empty
}

-- Internal state variables
local mainFrameVisible = true -- Tracks the visibility state of the main window
local currentTab = nil -- Tracks the currently active tab

-- Utility Function: Creates UI elements with specified properties
local function createElement(className, properties)
    local element = Instance.new(className) -- Creates a new instance of the specified class
    for prop, value in pairs(properties) do -- Applies all properties to the element
        element[prop] = value
    end
    return element
end

-- Function to Make a Frame Draggable
-- Allows the user to drag the window by holding and moving the mouse or touch input
local function makeDraggable(guiObject, dragHandle)
    local dragging = false -- Flag to track if dragging is active
    local dragInput, dragStart, startPos -- Variables to store drag state

    local function update(input)
        local delta = input.Position - dragStart -- Calculate the movement delta
        guiObject.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X, -- Update X position
            startPos.Y.Scale, startPos.Y.Offset + delta.Y -- Update Y position
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
-- Adds a resize handle to the bottom-right corner of the window
local function makeResizable(guiObject, minSize, maxSize)
    local resizeButton = createElement("TextButton", {
        Name = "ResizeButton", -- Name of the resize handle
        Parent = guiObject, -- Parent is the main frame
        Size = UDim2.new(0, 15, 0, 15), -- Small square for resizing
        Position = UDim2.new(1, -15, 1, -15), -- Positioned at bottom-right
        AnchorPoint = Vector2.new(1, 1), -- Anchored to the bottom-right corner
        BackgroundColor3 = Color3.fromRGB(100, 100, 100), -- Gray color for visibility
        Text = "", -- No text, just a handle
        AutoButtonColor = false -- Prevents default button color changes
    })
    createElement("UICorner", {CornerRadius = UDim.new(0, 4), Parent = resizeButton}) -- Rounded corners

    local resizing = false -- Flag to track if resizing is active
    local resizeStart, startSize -- Variables to store resize state

    resizeButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            resizeStart = input.Position
            startSize = guiObject.Size
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if resizing then
            local delta = input.Position - resizeStart -- Calculate the resize delta
            local newWidth = math.clamp(startSize.X.Offset + delta.X, minSize[1], maxSize[1]) -- Clamp width
            local newHeight = math.clamp(startSize.Y.Offset + delta.Y, minSize[2], maxSize[2]) -- Clamp height
            guiObject.Size = UDim2.new(0, newWidth, 0, newHeight) -- Apply new size
        end
    end)

    resizeButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = false
        end
    end)
end

-- Stell:Window Method
-- Creates a new window with customizable properties
function Stell:Window(info)
    info = info or {} -- Use empty table if no info is provided
    local config = {
        Title = info.Title or Stell.DefaultConfig.WindowTitle, -- Window title
        Subtitle = info.Subtitle or Stell.DefaultConfig.WindowSubtitle, -- Window subtitle
        Theme = info.Theme or Stell.DefaultConfig.Theme, -- Selected theme
        Logo = info.Logo or Stell.DefaultConfig.Logo, -- Logo image (if any)
        Resizable = info.Resizable ~= nil and info.Resizable or Stell.DefaultConfig.Resizable, -- Resizability
        Transparency = info.Transparency or Stell.DefaultConfig.Transparency, -- Transparency setting
        DefaultOpened = info.DefaultOpened ~= nil and info.DefaultOpened or Stell.DefaultConfig.DefaultOpened, -- Initial visibility
        DefaultSize = info.DefaultSize or Stell.DefaultConfig.DefaultSize, -- Initial size
        MinSize = info.MinSize or Stell.DefaultConfig.MinSize, -- Minimum size constraints
        MaxSize = info.MaxSize or Stell.DefaultConfig.MaxSize, -- Maximum size constraints
        ToggleKey = Stell.DefaultConfig.ToggleKey, -- Key to toggle visibility
        Colors = Stell.DefaultConfig.Colors[info.Theme or "Dark"] or Stell.DefaultConfig.Colors.Dark, -- Theme colors
        Icons = Stell.DefaultConfig.Icons -- Empty icons table (no icons used)
    }

    local gui = {} -- Table to hold all GUI elements

    -- Create the ScreenGui to hold the window
    gui.ScreenGui = createElement("ScreenGui", {
        Name = "StellGui", -- Unique name for the GUI
        Parent = playerGui, -- Parent to the player's GUI
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling, -- Allows layering with other GUIs
        ResetOnSpawn = false, -- Persists across respawns
        IgnoreGuiInset = true -- Ignores safe area insets
    })

    -- Create the main window frame
    gui.MainFrame = createElement("Frame", {
        Name = "MainFrame", -- Name of the main frame
        Parent = gui.ScreenGui, -- Parent is the ScreenGui
        Size = UDim2.new(0, config.DefaultSize[1], 0, config.DefaultSize[2]), -- Initial size
        Position = UDim2.new(0.5, 0, 0.5, 0), -- Centered on screen
        BackgroundColor3 = config.Colors.Background, -- Background color from theme
        BorderSizePixel = 0, -- No border for a clean look
        AnchorPoint = Vector2.new(0.5, 0.5), -- Anchored at center for resizing
        BackgroundTransparency = config.Transparency and 0.3 or 0 -- Apply transparency if enabled
    })
    createElement("UICorner", {CornerRadius = UDim.new(0, 8), Parent = gui.MainFrame}) -- Rounded corners

    -- Create the header frame
    gui.Header = createElement("Frame", {
        Name = "Header", -- Name of the header
        Parent = gui.MainFrame, -- Parent is the main frame
        Size = UDim2.new(1, 0, 0, config.Subtitle ~= "" and 60 or 40), -- Height adjusts with subtitle
        BackgroundColor3 = config.Colors.Header, -- Header color from theme
        BorderSizePixel = 0 -- No border
    })
    createElement("UICorner", {CornerRadius = UDim.new(0, 6), Parent = gui.Header}) -- Rounded corners

    -- Create the title label
    gui.Title = createElement("TextLabel", {
        Name = "Title", -- Name of the title label
        Parent = gui.Header, -- Parent is the header
        Size = UDim2.new(1, -50, config.Subtitle ~= "" and 0.5 or 1, 0), -- Adjusts with subtitle
        Position = UDim2.new(0, config.Logo ~= "" and 50 or 15, 0, 0), -- Offset for logo if present
        BackgroundTransparency = 1, -- Transparent background
        Text = config.Title, -- Display the title
        TextColor3 = config.Colors.PrimaryText, -- Text color from theme
        Font = Enum.Font.GothamBold, -- Bold Gotham font
        TextSize = 18, -- Font size
        TextXAlignment = Enum.TextXAlignment.Left -- Left-aligned text
    })

    -- Create the subtitle label if provided
    if config.Subtitle ~= "" then
        gui.Subtitle = createElement("TextLabel", {
            Name = "Subtitle", -- Name of the subtitle label
            Parent = gui.Header, -- Parent is the header
            Size = UDim2.new(1, -50, 0.5, 0), -- Half the header height
            Position = UDim2.new(0, config.Logo ~= "" and 50 or 15, 0.5, 0), -- Below title
            BackgroundTransparency = 1, -- Transparent background
            Text = config.Subtitle, -- Display the subtitle
            TextColor3 = config.Colors.PrimaryText, -- Text color from theme
            Font = Enum.Font.Gotham, -- Regular Gotham font
            TextSize = 14, -- Smaller font size
            TextXAlignment = Enum.TextXAlignment.Left -- Left-aligned text
        })
    end

    -- Create the logo image if provided
    if config.Logo ~= "" then
        gui.Logo = createElement("ImageLabel", {
            Name = "Logo", -- Name of the logo
            Parent = gui.Header, -- Parent is the header
            Size = UDim2.new(0, 30, 0, 30), -- Fixed size for logo
            Position = UDim2.new(0, 10, 0.5, 0), -- Centered vertically
            AnchorPoint = Vector2.new(0, 0.5), -- Anchored at left center
            BackgroundTransparency = 1, -- Transparent background
            Image = config.Logo -- Logo image from config
        })
    end

    -- Create the close button
    gui.CloseButton = createElement("TextButton", {
        Name = "CloseButton", -- Name of the close button
        Parent = gui.Header, -- Parent is the header
        Size = UDim2.new(0, 25, 0, 25), -- Small square button
        Position = UDim2.new(1, -15, 0.5, 0), -- Top-right corner
        AnchorPoint = Vector2.new(1, 0.5), -- Anchored at right center
        BackgroundColor3 = config.Colors.Button, -- Button color from theme
        Text = "X", -- Close symbol
        TextColor3 = config.Colors.PrimaryText, -- Text color
        Font = Enum.Font.GothamBold, -- Bold Gotham font
        TextSize = 14 -- Font size
    })
    createElement("UICorner", {CornerRadius = UDim.new(0, 6), Parent = gui.CloseButton}) -- Rounded corners

    -- Create the body frame
    gui.Body = createElement("Frame", {
        Name = "Body", -- Name of the body
        Parent = gui.MainFrame, -- Parent is the main frame
        Size = UDim2.new(1, 0, 1, config.Subtitle ~= "" and -60 or -40), -- Adjusts with subtitle
        Position = UDim2.new(0, 0, 0, config.Subtitle ~= "" and 60 or 40), -- Below header
        BackgroundTransparency = 1 -- Transparent background
    })

    -- Create the tabs container
    gui.TabsContainer = createElement("Frame", {
        Name = "TabsContainer", -- Name of the tabs container
        Parent = gui.Body, -- Parent is the body
        Size = UDim2.new(0, 60, 1, 0), -- Fixed width for tabs
        BackgroundColor3 = config.Colors.Header, -- Same color as header
        BorderSizePixel = 0 -- No border
    })
    createElement("UIListLayout", {
        Parent = gui.TabsContainer, -- Parent is the tabs container
        FillDirection = Enum.FillDirection.Vertical, -- Tabs stack vertically
        HorizontalAlignment = Enum.HorizontalAlignment.Center, -- Centered horizontally
        SortOrder = Enum.SortOrder.LayoutOrder, -- Order based on LayoutOrder
        Padding = UDim.new(0, 10) -- Spacing between tabs
    })
    createElement("UIPadding", {Parent = gui.TabsContainer, PaddingTop = UDim.new(0, 10)}) -- Top padding

    -- Create the content frame for tab content
    gui.ContentFrame = createElement("Frame", {
        Name = "Content", -- Name of the content frame
        Parent = gui.Body, -- Parent is the body
        Size = UDim2.new(1, -60, 1, 0), -- Adjusts for tabs container width
        Position = UDim2.new(0, 60, 0, 0), -- To the right of tabs
        BackgroundTransparency = 1 -- Transparent background
    })
    createElement("UIPadding", {
        Parent = gui.ContentFrame, -- Parent is the content frame
        PaddingTop = UDim.new(0, 10), -- Top padding
        PaddingLeft = UDim.new(0, 10), -- Left padding
        PaddingRight = UDim.new(0, 10) -- Right padding
    })

    -- Draggable functionality
    if UserInputService.TouchEnabled then
        gui.MoveButton = createElement("ImageButton", {
            Name = "MoveButton", -- Name of the move button
            Parent = gui.Header, -- Parent is the header
            Size = UDim2.new(0, 25, 0, 25), -- Small square button
            Position = UDim2.new(1, -50, 0.5, 0), -- Next to close button
            AnchorPoint = Vector2.new(1, 0.5), -- Anchored at right center
            BackgroundColor3 = config.Colors.Button, -- Button color
            Image = "" -- No image (icons removed)
        })
        createElement("UICorner", {CornerRadius = UDim.new(0, 6), Parent = gui.MoveButton}) -- Rounded corners
        makeDraggable(gui.MainFrame, gui.MoveButton) -- Make draggable with move button
    else
        makeDraggable(gui.MainFrame, gui.Header) -- Make draggable with entire header
    end

    -- Resizable functionality
    if config.Resizable then
        makeResizable(gui.MainFrame, config.MinSize, config.MaxSize) -- Enable resizing
    end

    -- Tab Management
    gui.Tabs = {} -- Table to store all tabs
    function gui:Tab(info)
        info = info or {} -- Use empty table if no info provided
        local tabConfig = {
            Name = info.Name or "Tab", -- Tab name (displayed as text)
            KeySystem = info.KeySystem or false, -- Whether a key is required
            Key = info.Key or "Hi123" -- Default key if key system is enabled
        }

        -- Key System Implementation
        local keyValid = not tabConfig.KeySystem -- Assume valid unless key system is active
        local keyPrompt, submitButton -- Variables for key input UI
        if tabConfig.KeySystem then
            keyPrompt = createElement("TextBox", {
                Name = "KeyPrompt", -- Name of the key input box
                Parent = gui.ContentFrame, -- Parent is the content frame
                Size = UDim2.new(1, -20, 0, 30), -- Width minus padding, fixed height
                Position = UDim2.new(0, 10, 0, 10), -- Top-left position
                BackgroundColor3 = config.Colors.Button, -- Button color
                Text = "Enter Key", -- Placeholder text
                TextColor3 = config.Colors.PrimaryText, -- Text color
                Font = Enum.Font.Gotham, -- Gotham font
                TextSize = 14, -- Font size
                Visible = false -- Hidden by default
            })
            createElement("UICorner", {CornerRadius = UDim.new(0, 6), Parent = keyPrompt}) -- Rounded corners

            submitButton = createElement("TextButton", {
                Name = "SubmitKey", -- Name of the submit button
                Parent = gui.ContentFrame, -- Parent is the content frame
                Size = UDim2.new(0, 100, 0, 30), -- Fixed size
                Position = UDim2.new(0, 10, 0, 50), -- Below key prompt
                BackgroundColor3 = config.Colors.Button, -- Button color
                Text = "Submit", -- Button text
                TextColor3 = config.Colors.PrimaryText, -- Text color
                Font = Enum.Font.Gotham, -- Gotham font
                TextSize = 14, -- Font size
                Visible = false -- Hidden by default
            })
            createElement("UICorner", {CornerRadius = UDim.new(0, 6), Parent = submitButton}) -- Rounded corners

            -- Handle key submission
            submitButton.MouseButton1Click:Connect(function()
                if keyPrompt.Text == tabConfig.Key then
                    keyValid = true -- Validate key
                    keyPrompt.Visible = false -- Hide prompt
                    submitButton.Visible = false -- Hide submit button
                    for _, t in pairs(gui.Tabs) do
                        t.Content.Visible = (t == gui.Tabs[tabConfig.Name]) and keyValid -- Show only valid tab
                    end
                else
                    keyPrompt.Text = "Invalid Key" -- Feedback for wrong key
                    wait(1) -- Wait 1 second
                    keyPrompt.Text = "Enter Key" -- Reset prompt
                end
            end)
        end

        -- Create the tab button (text-based)
        local tab = {}
        tab.Button = createElement("TextButton", {
            Name = tabConfig.Name .. "Button", -- Unique name based on tab name
            Parent = gui.TabsContainer, -- Parent is the tabs container
            Size = UDim2.new(0, 50, 0, 30), -- Fixed width and height for text button
            BackgroundColor3 = config.Colors.TabInactive, -- Inactive tab color
            Text = tabConfig.Name, -- Display the tab name as text
            TextColor3 = config.Colors.PrimaryText, -- Text color
            Font = Enum.Font.Gotham, -- Gotham font
            TextSize = 14, -- Font size
            LayoutOrder = #gui.Tabs + 1 -- Order in the list
        })
        createElement("UICorner", {CornerRadius = UDim.new(0, 6), Parent = tab.Button}) -- Rounded corners

        -- Create the content frame for the tab
        tab.Content = createElement("ScrollingFrame", {
            Name = tabConfig.Name .. "_Content", -- Unique name
            Parent = gui.ContentFrame, -- Parent is the content frame
            Size = UDim2.new(1, 0, 1, 0), -- Full size of content area
            Visible = false, -- Hidden by default
            BackgroundTransparency = 1, -- Transparent background
            BorderSizePixel = 0, -- No border
            CanvasSize = UDim2.new(0, 0, 0, 0), -- Initial canvas size
            ScrollBarImageColor3 = config.Colors.ButtonHover, -- Scrollbar color
            ScrollBarThickness = 5 -- Scrollbar width
        })
        createElement("UIGridLayout", {
            Parent = tab.Content, -- Parent is the content frame
            CellPadding = UDim2.new(0, 8, 0, 8), -- Padding between elements
            CellSize = UDim2.new(0, 100, 0, 35), -- Size of each grid cell
            SortOrder = Enum.SortOrder.LayoutOrder -- Order based on LayoutOrder
        })

        -- Tab switching logic
        tab.Button.MouseButton1Click:Connect(function()
            if tabConfig.KeySystem and not keyValid then
                keyPrompt.Visible = true -- Show key prompt
                submitButton.Visible = true -- Show submit button
                return -- Exit if key is required but not valid
            end
            for _, t in pairs(gui.Tabs) do
                t.Content.Visible = false -- Hide all other tab contents
                t.Button.BackgroundColor3 = config.Colors.TabInactive -- Set to inactive color
            end
            tab.Content.Visible = true -- Show current tab content
            tab.Button.BackgroundColor3 = config.Colors.TabActive -- Set to active color
            currentTab = tabConfig.Name -- Update current tab
        end)

        -- Button creation method for the tab
        function tab:Button(info)
            info = info or {} -- Use empty table if no info provided
            local buttonConfig = {
                Name = info.Name or "Button", -- Button text
                Desc = info.Desc or "", -- Button description
                Locked = info.Locked or false, -- Whether the button is locked
                Visible = info.Visible ~= nil and info.Visible or true, -- Visibility
                Callback = info.Callback or function() print("Button clicked!") end -- Default callback
            }

            -- Create a frame to hold the button and description
            local buttonFrame = createElement("Frame", {
                Name = buttonConfig.Name .. "_Frame", -- Unique name
                Parent = tab.Content, -- Parent is the tab content
                Size = UDim2.new(0, 100, 0, buttonConfig.Desc ~= "" and 50 or 35), -- Adjust height with description
                BackgroundTransparency = 1, -- Transparent background
                Visible = buttonConfig.Visible -- Apply visibility
            })

            -- Create the button
            local button = createElement("TextButton", {
                Name = buttonConfig.Name, -- Button name
                Parent = buttonFrame, -- Parent is the frame
                Size = UDim2.new(1, 0, buttonConfig.Desc ~= "" and 0.7 or 1, 0), -- Adjust with description
                BackgroundColor3 = buttonConfig.Locked and config.Colors.LockedButton or config.Colors.Button, -- Color based on lock state
                Text = buttonConfig.Name, -- Display the name
                TextColor3 = config.Colors.PrimaryText, -- Text color
                Font = Enum.Font.Gotham, -- Gotham font
                TextSize = 14, -- Font size
                AutoButtonColor = not buttonConfig.Locked -- Disable color change if locked
            })
            createElement("UICorner", {CornerRadius = UDim.new(0, 6), Parent = button}) -- Rounded corners

            -- Add description label if provided
            if buttonConfig.Desc ~= "" then
                local descLabel = createElement("TextLabel", {
                    Name = buttonConfig.Name .. "_Desc", -- Unique name
                    Parent = buttonFrame, -- Parent is the frame
                    Size = UDim2.new(1, 0, 0.3, 0), -- Below the button
                    Position = UDim2.new(0, 0, 0.7, 0), -- Position below
                    BackgroundTransparency = 1, -- Transparent background
                    Text = buttonConfig.Desc, -- Display description
                    TextColor3 = config.Colors.PrimaryText, -- Text color
                    Font = Enum.Font.Gotham, -- Gotham font
                    TextSize = 10, -- Smaller font size
                    TextWrapped = true, -- Wrap long text
                    TextXAlignment = Enum.TextXAlignment.Center -- Centered text
                })
            end

            -- Add interactivity if not locked
            if not buttonConfig.Locked then
                button.MouseButton1Click:Connect(function()
                    buttonConfig.Callback() -- Execute callback on click
                end)
                button.MouseEnter:Connect(function()
                    TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = config.Colors.ButtonHover}):Play()
                end)
                button.MouseLeave:Connect(function()
                    TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = config.Colors.Button}):Play()
                end)
            end

            return button -- Return the button for further manipulation
        end

        gui.Tabs[tabConfig.Name] = tab -- Store the tab in the tabs table
        return tab -- Return the tab object
    end

    -- Toggle Window Visibility
    function gui:Toggle(state)
        mainFrameVisible = state -- Update internal state
        gui.MainFrame.Visible = state -- Apply visibility
    end

    -- Close Button Functionality
    gui.CloseButton.MouseButton1Click:Connect(function()
        gui:Toggle(false) -- Hide the window on click
    end)
    gui.CloseButton.MouseEnter:Connect(function()
        TweenService:Create(gui.CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = config.Colors.CloseButton}):Play()
    end)
    gui.CloseButton.MouseLeave:Connect(function()
        TweenService:Create(gui.CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = config.Colors.Button}):Play()
    end)

    -- Toggle Key Binding
    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if gameProcessedEvent then return end -- Ignore if input is processed by game
        if input.KeyCode == config.ToggleKey then
            gui:Toggle(not mainFrameVisible) -- Toggle visibility on key press
        end
    end)

    -- Set initial visibility
    gui:Toggle(config.DefaultOpened)

    return gui -- Return the GUI object
end

-- Initialize Stell UI with an empty window
function Stell:Init(customConfig)
    local config = customConfig or {} -- Use empty table if no config provided
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

    print("Stell UI Library v1.2 initialized.") -- Confirmation message
    return gui -- Return the initialized GUI
end

return Stell -- Return the Stell library for use
