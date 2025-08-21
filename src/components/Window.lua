-- Stell UI Library (Executor-Compatible)
local Stell = {}
Stell.__index = Stell

-- Services
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- UI Instance Creation Helper
local function createInstance(class, properties)
    local instance = Instance.new(class)
    for prop, value in pairs(properties or {}) do
        pcall(function() instance[prop] = value end)
    end
    return instance
end

-- Default Configuration
local DEFAULT_CONFIG = {
    Title = "Stell Window",
    Icon = "",
    Author = "",
    Folder = "StellUI",
    Size = UDim2.fromOffset(580, 460),
    Transparent = false,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.5,
    HideSearchBar = false,
    ScrollBarEnabled = true,
    User = {
        Enabled = false,
        Anonymous = false,
        Callback = function() end,
    },
    KeySystem = {
        Key = {},
        Note = "",
        Thumbnail = { Image = "", Title = "" },
        URL = "",
        SaveKey = false,
    },
    Background = "",
}

-- Themes
local THEMES = {
    Dark = {
        BackgroundColor = Color3.fromRGB(30, 30, 30),
        TextColor = Color3.fromRGB(255, 255, 255),
        AccentColor = Color3.fromRGB(100, 100, 255),
        BorderColor = Color3.fromRGB(50, 50, 50),
    },
    Light = {
        BackgroundColor = Color3.fromRGB(240, 240, 240),
        TextColor = Color3.fromRGB(0, 0, 0),
        AccentColor = Color3.fromRGB(50, 50, 200),
        BorderColor = Color3.fromRGB(200, 200, 200),
    }
}

-- Window Class
local Window = {}
Window.__index = Window

function Stell:Window(config, info)
    -- Handle Info request
    if config == "Info" then
        return {
            Library = "Stell",
            Version = "1.0.0",
            Features = {
                "Customizable window with title, icon, and author",
                "Dark and Light themes",
                "Resizable and draggable windows",
                "Sidebar with optional search bar",
                "Content area with optional scrollbar",
                "Background image or video support",
                "User info with anonymous mode and callback",
                "Key system with validation and saving to Folder/Key.lua",
                "Transparency toggle",
                "Customizable top bar buttons",
            },
            Methods = {
                "Window(config, info)",
                "ToggleTransparency(state)",
                "IsResizable(state)",
                "ToggleSearchBar(state)",
                "SetBackground(resource)",
                "DisableTopbarButtons(buttons)",
                "CreateTopbarButton(name, icon, callback, order)",
                "Destroy()",
            }
        }
    end

    -- Validate config
    if type(config) ~= "table" then
        error("Stell:Window expects a table configuration or 'Info' as argument.")
    end
    info = type(info) == "table" and info or {}

    local window = setmetatable({}, Window)
    window.Config = {}
    window.TopbarButtons = {} -- Store top bar buttons

    -- Merge default config with info and user config
    for key, default in pairs(DEFAULT_CONFIG) do
        if type(default) == "table" then
            window.Config[key] = {}
            for k, v in pairs(default) do
                window.Config[key][k] = (config[key] and config[key][k] ~= nil) and config[key][k] or
                                       (info[key] and info[key][k] ~= nil) and info[key][k] or v
            end
        else
            if key == "Size" then
                window.Config[key] = config[key] or
                                    (info[key] and UDim2.fromOffset(info[key][1], info[key][2])) or
                                    default
            elseif key == "SideBarWidth" then
                window.Config[key] = config[key] or info.SideBarWhidth or default
            else
                window.Config[key] = config[key] or info[key] or default
            end
        end
    end

    -- Create UI
    window.ScreenGui = createInstance("ScreenGui", {
        Parent = Players.LocalPlayer.PlayerGui,
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        Name = window.Config.Folder,
    })

    window.MainFrame = createInstance("Frame", {
        Parent = window.ScreenGui,
        Size = window.Config.Size,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = THEMES[window.Config.Theme].BackgroundColor,
        BorderColor3 = THEMES[window.Config.Theme].BorderColor,
        ClipsDescendants = true,
    })

    -- Apply Transparency
    window.MainFrame.BackgroundTransparency = window.Config.Transparent and 0.5 or 0

    -- Draggable Title Bar
    window.TitleBar = createInstance("Frame", {
        Parent = window.MainFrame,
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = THEMES[window.Config.Theme].AccentColor,
        BorderColor3 = THEMES[window.Config.Theme].BorderColor,
    })

    local isDragging = false
    local dragStart, startPos
    window.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            dragStart = input.Position
            startPos = window.MainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            window.MainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)

    -- Title and Icon
    window.IconLabel = createInstance("ImageLabel", {
        Parent = window.TitleBar,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, 5, 0.5, -10),
        BackgroundTransparency = 1,
        Image = window.Config.Icon:find("rbxassetid://") and window.Config.Icon or "rbxassetid://7072706620", -- Fallback icon
    })

    window.TitleLabel = createInstance("TextLabel", {
        Parent = window.TitleBar,
        Size = UDim2.new(1, -150, 1, 0),
        Position = UDim2.new(0, 30, 0, 0),
        Text = window.Config.Title .. " | " .. window.Config.Author,
        TextColor3 = THEMES[window.Config.Theme].TextColor,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.SourceSansBold,
        TextSize = 16,
    })

    -- Default Topbar Buttons (Close, Minimize, Fullscreen)
    window.TopbarButtons.Close = createInstance("TextButton", {
        Parent = window.TitleBar,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -25, 0.5, -10),
        BackgroundTransparency = 1,
        Image = "rbxassetid://7072725342", -- Close icon
        ImageColor3 = THEMES[window.Config.Theme].TextColor,
    })
    window.TopbarButtons.Close.MouseButton1Click:Connect(function()
        window:Destroy()
    end)

    window.TopbarButtons.Minimize = createInstance("TextButton", {
        Parent = window.TitleBar,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -50, 0.5, -10),
        BackgroundTransparency = 1,
        Image = "rbxassetid://7072706764", -- Minimize icon
        ImageColor3 = THEMES[window.Config.Theme].TextColor,
    })
    window.TopbarButtons.Minimize.MouseButton1Click:Connect(function()
        window.MainFrame.Visible = false
    end)

    window.TopbarButtons.Fullscreen = createInstance("TextButton", {
        Parent = window.TitleBar,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -75, 0.5, -10),
        BackgroundTransparency = 1,
        Image = "rbxassetid://7072721682", -- Fullscreen icon
        ImageColor3 = THEMES[window.Config.Theme].TextColor,
    })
    window.TopbarButtons.Fullscreen.MouseButton1Click:Connect(function()
        if window.MainFrame.Size == UDim2.new(1, 0, 1, 0) then
            window.MainFrame.Size = window.Config.Size
            window.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
            window.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        else
            window.MainFrame.Size = UDim2.new(1, 0, 1, 0)
            window.MainFrame.Position = UDim2.new(0, 0, 0, 0)
            window.MainFrame.AnchorPoint = Vector2.new(0, 0)
        end
    end)

    -- Sidebar
    window.SideBar = createInstance("Frame", {
        Parent = window.MainFrame,
        Size = UDim2.new(0, window.Config.SideBarWidth, 1, -30),
        Position = UDim2.new(0, 0, 0, 30),
        BackgroundColor3 = THEMES[window.Config.Theme].BackgroundColor:lerp(Color3.new(0, 0, 0), 0.1),
        BorderColor3 = THEMES[window.Config.Theme].BorderColor,
    })

    -- Search Bar
    window.SearchBar = createInstance("TextBox", {
        Parent = window.SideBar,
        Size = UDim2.new(0.9, 0, 0, 30),
        Position = UDim2.new(0.05, 0, 0, 5),
        PlaceholderText = "Search...",
        Text = "",
        TextColor3 = THEMES[window.Config.Theme].TextColor,
        BackgroundColor3 = THEMES[window.Config.Theme].BackgroundColor:lerp(Color3.new(1, 1, 1), 0.1),
        Visible = not window.Config.HideSearchBar,
        Font = Enum.Font.SourceSans,
        TextSize = 14,
    })

    -- Content Area
    window.ContentFrame = createInstance("Frame", {
        Parent = window.MainFrame,
        Size = UDim2.new(1, -window.Config.SideBarWidth, 1, -30),
        Position = UDim2.new(0, window.Config.SideBarWidth, 0, 30),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
    })

    -- ScrollBar
    if window.Config.ScrollBarEnabled then
        window.ScrollingFrame = createInstance("ScrollingFrame", {
            Parent = window.ContentFrame,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 8,
            CanvasSize = UDim2.new(0, 0, 0, 0),
        })
    end

    -- Background Image/Video
    if window.Config.Background:find("rbxassetid://") then
        window.BackgroundImage = createInstance("ImageLabel", {
            Parent = window.MainFrame,
            Size = UDim2.new(1, 0, 1, 0),
            Image = window.Config.Background,
            ImageTransparency = window.Config.BackgroundImageTransparency,
            BackgroundTransparency = 1,
            ZIndex = 0,
        })
    elseif window.Config.Background:find("video:") then
        window.BackgroundVideo = createInstance("VideoFrame", {
            Parent = window.MainFrame,
            Size = UDim2.new(1, 0, 1, 0),
            Video = window.Config.Background:gsub("video:", ""),
            Volume = 0,
            Looped = true,
            Playing = true,
            BackgroundTransparency = 1,
            ZIndex = 0,
        })
    end

    -- User Info
    if window.Config.User.Enabled then
        window.UserLabel = createInstance("TextLabel", {
            Parent = window.TitleBar,
            Size = UDim2.new(0, 100, 1, 0),
            Position = UDim2.new(1, -110, 0, 0),
            Text = window.Config.User.Anonymous and "Anonymous" or Players.LocalPlayer.Name,
            TextColor3 = THEMES[window.Config.Theme].TextColor,
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Right,
            Font = Enum.Font.SourceSans,
            TextSize = 14,
        })
        window.UserLabel.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                window.Config.User.Callback()
            end
        end)
    end

    -- Key System
    if window.Config.KeySystem and next(window.Config.KeySystem.Key) then
        window.KeySystemFrame = createInstance("Frame", {
            Parent = window.ScreenGui,
            Size = UDim2.fromOffset(400, 300),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = THEMES[window.Config.Theme].BackgroundColor,
            BorderColor3 = THEMES[window.Config.Theme].BorderColor,
        })

        -- Thumbnail
        if window.Config.KeySystem.Thumbnail.Image ~= "" then
            createInstance("ImageLabel", {
                Parent = window.KeySystemFrame,
                Size = UDim2.new(0.8, 0, 0, 100),
                Position = UDim2.new(0.1, 0, 0, 10),
                Image = window.Config.KeySystem.Thumbnail.Image,
                BackgroundTransparency = 1,
            })
            createInstance("TextLabel", {
                Parent = window.KeySystemFrame,
                Size = UDim2.new(0.8, 0, 0, 20),
                Position = UDim2.new(0.1, 0, 0, 110),
                Text = window.Config.KeySystem.Thumbnail.Title,
                TextColor3 = THEMES[window.Config.Theme].TextColor,
                BackgroundTransparency = 1,
                Font = Enum.Font.SourceSansBold,
                TextSize = 16,
            })
        end

        -- Note
        createInstance("TextLabel", {
            Parent = window.KeySystemFrame,
            Size = UDim2.new(0.8, 0, 0, 30),
            Position = UDim2.new(0.1, 0, 0, 140),
            Text = window.Config.KeySystem.Note,
            TextColor3 = THEMES[window.Config.Theme].TextColor,
            BackgroundTransparency = 1,
            Font = Enum.Font.SourceSans,
            TextSize = 14,
            TextWrapped = true,
        })

        -- URL (Get Key Button)
        if window.Config.KeySystem.URL ~= "" then
            local getKeyButton = createInstance("TextButton", {
                Parent = window.KeySystemFrame,
                Size = UDim2.new(0.4, 0, 0, 30),
                Position = UDim2.new(0.3, 0, 0, 180),
                Text = "Get Key",
                TextColor3 = THEMES[window.Config.Theme].TextColor,
                BackgroundColor3 = THEMES[window.Config.Theme].AccentColor,
                Font = Enum.Font.SourceSans,
                TextSize = 14,
            })
            getKeyButton.MouseButton1Click:Connect(function()
                print("Open URL:", window.Config.KeySystem.URL)
            end)
        end

        -- Key Input
        window.KeyInput = createInstance("TextBox", {
            Parent = window.KeySystemFrame,
            Size = UDim2.new(0.8, 0, 0, 30),
            Position = UDim2.new(0.1, 0, 0, 220),
            PlaceholderText = "Enter Key",
            Text = "",
            TextColor3 = THEMES[window.Config.Theme].TextColor,
            BackgroundColor3 = THEMES[window.Config.Theme].BackgroundColor:lerp(Color3.new(1, 1, 1), 0.1),
            Font = Enum.Font.SourceSans,
            TextSize = 14,
        })

        -- Submit Button
        window.KeySubmit = createInstance("TextButton", {
            Parent = window.KeySystemFrame,
            Size = UDim2.new(0.4, 0, 0, 30),
            Position = UDim2.new(0.3, 0, 0, 260),
            Text = "Submit",
            TextColor3 = THEMES[window.Config.Theme].TextColor,
            BackgroundColor3 = THEMES[window.Config.Theme].AccentColor,
            Font = Enum.Font.SourceSans,
            TextSize = 14,
        })

        -- Load saved key if enabled (using executor file functions)
        if window.Config.KeySystem.SaveKey then
            local keyPath = window.Config.Folder .. "/Key.lua"
            if isfile and isfile(keyPath) then
                local success, savedKey = pcall(function()
                    return readfile(keyPath)
                end)
                if success and savedKey and table.find(window.Config.KeySystem.Key, savedKey) then
                    window.KeyInput.Text = savedKey
                    window.KeySystemFrame.Visible = false
                    window.MainFrame.Visible = true
                end
            end
        end

        window.KeySubmit.MouseButton1Click:Connect(function()
            local key = window.KeyInput.Text
            if table.find(window.Config.KeySystem.Key, key) then
                window.KeySystemFrame.Visible = false
                window.MainFrame.Visible = true
                if window.Config.KeySystem.SaveKey then
                    pcall(function()
                        makefolder(window.Config.Folder)
                        writefile(window.Config.Folder .. "/Key.lua", key)
                    end)
                end
            else
                window.KeyInput.Text = "Invalid Key"
                wait(1)
                window.KeyInput.Text = ""
            end
        end)

        window.MainFrame.Visible = false
    end

    -- Resizable Logic
    if window.Config.Resizable then
        window.ResizeButton = createInstance("TextButton", {
            Parent = window.MainFrame,
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(1, -20, 1, -20),
            Text = "",
            BackgroundColor3 = THEMES[window.Config.Theme].AccentColor,
            BorderColor3 = THEMES[window.Config.Theme].BorderColor,
        })

        local isResizing = false
        local lastPos = Vector2.new(0, 0)
        window.ResizeButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isResizing = true
                lastPos = input.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if isResizing and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - lastPos
                window.MainFrame.Size = UDim2.new(
                    0, math.max(300, window.MainFrame.Size.X.Offset + delta.X),
                    0, math.max(200, window.MainFrame.Size.Y.Offset + delta.Y)
                )
                lastPos = input.Position
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isResizing = false
            end
        end)
    end

    return window
end

-- Window Methods
function Window:ToggleTransparency(state)
    self.Config.Transparent = state
    self.MainFrame.BackgroundTransparency = state and 0.5 or 0
end

function Window:IsResizable(state)
    self.Config.Resizable = state
    if self.ResizeButton then
        self.ResizeButton.Visible = state
    end
end

function Window:ToggleSearchBar(state)
    self.Config.HideSearchBar = not state
    self.SearchBar.Visible = state
end

function Window:SetBackground(resource)
    self.Config.Background = resource
    if self.BackgroundImage then
        self.BackgroundImage:Destroy()
        self.BackgroundImage = nil
    end
    if self.BackgroundVideo then
        self.BackgroundVideo:Destroy()
        self.BackgroundVideo = nil
    end
    if resource:find("rbxassetid://") then
        self.BackgroundImage = createInstance("ImageLabel", {
            Parent = self.MainFrame,
            Size = UDim2.new(1, 0, 1, 0),
            Image = resource,
            ImageTransparency = self.Config.BackgroundImageTransparency,
            BackgroundTransparency = 1,
            ZIndex = 0,
        })
    elseif resource:find("video:") then
        self.BackgroundVideo = createInstance("VideoFrame", {
            Parent = self.MainFrame,
            Size = UDim2.new(1, 0, 1, 0),
            Video = resource:gsub("video:", ""),
            Volume = 0,
            Looped = true,
            Playing = true,
            BackgroundTransparency = 1,
            ZIndex = 0,
        })
    end
end

function Window:DisableTopbarButtons(buttons)
    for _, buttonName in ipairs(buttons) do
        if self.TopbarButtons[buttonName] then
            self.TopbarButtons[buttonName].Visible = false
            self.TopbarButtons[buttonName].Active = false
        end
    end
end

function Window:CreateTopbarButton(name, icon, callback, order)
    local button = createInstance("TextButton", {
        Parent = self.TitleBar,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -25 - (order or 0) * 25, 0.5, -10),
        BackgroundTransparency = 1,
        Image = icon:find("rbxassetid://") and icon or "rbxassetid://7072706620", -- Fallback icon
        ImageColor3 = THEMES[self.Config.Theme].TextColor,
    })
    button.MouseButton1Click:Connect(callback)
    self.TopbarButtons[name] = button
    return button
end

function Window:Destroy()
    self.ScreenGui:Destroy()
    setmetatable(self, nil)
end

return Stell
