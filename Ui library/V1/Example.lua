-- Example.lua - DoorLib Usage Example
-- Demonstrates how to use the complete UI library

-- Load the library
local DoorLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Stelariums/refs/heads/main/Ui%20library/V1/Library/Init.lua"))()

-- Create the main window with your preferred settings
local Window = DoorLib:MakeWindow({
    Title = "DoorLib Advanced UI",
    SubTitle = "Modern Roblox Interface",
    Resizable = true,
    Theme = "Cyan", -- Options: "Dark", "Light", "Cyan"
    Size = UDim2.new(0, 600, 0, 450),
    Position = UDim2.new(0.5, -300, 0.5, -225)
})

-- Create tabs for different categories
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
    Visible = true
})

local SettingsTab = Window:MakeTab({
    Name = "Settings",
    Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
    Visible = true
})

local MiscTab = Window:MakeTab({
    Name = "Miscellaneous",
    Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
    Visible = true
})

-- Add elements to the Main tab
local MainSection = MainTab:AddSection({
    Name = "Core Features"
})

-- Button example
MainSection:AddButton({
    Name = "Execute Action",
    Description = "Performs a sample action with visual feedback",
    Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png",
    Callback = function()
        print("Button clicked! Action executed.")
        -- Add your button logic here
    end
})

-- Toggle example
local AutoFarmToggle = MainSection:AddToggle({
    Name = "Auto Farm",
    Description = "Automatically farms resources when enabled",
    Default = false,
    Callback = function(value)
        print("Auto Farm toggled:", value)
        if value then
            print("Starting auto farm...")
            -- Add auto farm logic here
        else
            print("Stopping auto farm...")
            -- Add stop logic here
        end
    end
})

-- Button to control the toggle programmatically
MainSection:AddButton({
    Name = "Toggle Auto Farm",
    Description = "Programmatically toggle the auto farm feature",
    Callback = function()
        AutoFarmToggle:Toggle()
    end
})

-- Add a section for player controls
local PlayerSection = MainTab:AddSection({
    Name = "Player Controls"
})

-- Slider for walkspeed (will be implemented later)
-- PlayerSection:AddSlider({
--     Name = "Walk Speed",
--     Description = "Adjust your character's movement speed",
--     Min = 16,
--     Max = 100,
--     Default = 16,
--     Callback = function(value)
--         if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
--             game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
--         end
--     end
-- })

-- Add elements to the Settings tab
local GeneralSettings = SettingsTab:AddSection({
    Name = "General Settings"
})

-- Theme switcher
local ThemeButtons = {
    GeneralSettings:AddButton({
        Name = "Dark Theme",
        Description = "Switch to dark theme",
        Callback = function()
            -- Window:SetTheme("Dark")
            print("Switched to Dark theme")
        end
    }),
    
    GeneralSettings:AddButton({
        Name = "Light Theme", 
        Description = "Switch to light theme",
        Callback = function()
            -- Window:SetTheme("Light")
            print("Switched to Light theme")
        end
    }),
    
    GeneralSettings:AddButton({
        Name = "Cyan Theme",
        Description = "Switch to cyan theme",
        Callback = function()
            -- Window:SetTheme("Cyan")
            print("Switched to Cyan theme")
        end
    })
}

-- Notification system example
GeneralSettings:AddButton({
    Name = "Test Notification",
    Description = "Shows a sample notification",
    Callback = function()
        -- DoorLib:CreateNotification({
        --     Title = "Test Notification",
        --     Content = "This is a sample notification message!",
        --     Type = "Success", -- Options: "Info", "Success", "Warning", "Error"
        --     Duration = 3
        -- })
        print("Notification would appear here")
    end
})

-- Advanced settings section
local AdvancedSettings = SettingsTab:AddSection({
    Name = "Advanced Settings"
})

-- Performance toggle
AdvancedSettings:AddToggle({
    Name = "High Performance Mode",
    Description = "Reduces visual effects for better performance",
    Default = false,
    Callback = function(value)
        print("High Performance Mode:", value)
        -- Implement performance optimizations
    end
})

-- Debug toggle
local DebugMode = AdvancedSettings:AddToggle({
    Name = "Debug Mode",
    Description = "Shows additional debug information",
    Default = false,
    Callback = function(value)
        print("Debug Mode:", value)
        if value then
            print("Debug information enabled")
            -- Show debug overlay
        else
            print("Debug information disabled")
            -- Hide debug overlay
        end
    end
})

-- Add elements to the Miscellaneous tab
local UtilitiesSection = MiscTab:AddSection({
    Name = "Utilities"
})

-- Server information button
UtilitiesSection:AddButton({
    Name = "Server Info",
    Description = "Display current server information",
    Callback = function()
        local players = game:GetService("Players")
        local runService = game:GetService("RunService")
        
        print("=== Server Information ===")
        print("Server ID:", game.JobId)
        print("Place ID:", game.PlaceId)
        print("Players:", players.NumPlayers .. "/" .. players.MaxPlayers)
        print("Ping:", math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()) .. "ms")
        print("========================")
    end
})

-- Rejoin server button
UtilitiesSection:AddButton({
    Name = "Rejoin Server",
    Description = "Reconnect to the same server",
    Callback = function()
        local teleportService = game:GetService("TeleportService")
        teleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
    end
})

-- Copy game link button
UtilitiesSection:AddButton({
    Name = "Copy Game Link",
    Description = "Copy the current game link to clipboard",
    Callback = function()
        local link = "https://www.roblox.com/games/" .. game.PlaceId
        setclipboard(link)
        print("Game link copied to clipboard:", link)
    end
})

-- Fun section for miscellaneous features
local FunSection = MiscTab:AddSection({
    Name = "Fun Features"
})

-- Rainbow mode toggle
FunSection:AddToggle({
    Name = "Rainbow Mode",
    Description = "Applies rainbow colors to various UI elements",
    Default = false,
    Callback = function(value)
        print("Rainbow Mode:", value)
        if value then
            -- Start rainbow color cycling
            spawn(function()
                local hue = 0
                while value do
                    hue = hue + 1
                    if hue > 360 then hue = 0 end
                    
                    local color = Color3.fromHSV(hue / 360, 1, 1)
                    -- Apply rainbow colors to UI elements
                    
                    wait(0.1)
                end
            end)
        end
    end
})

-- Window controls section
local WindowSection = MiscTab:AddSection({
    Name = "Window Controls"
})

-- Minimize window button
WindowSection:AddButton({
    Name = "Minimize Window",
    Description = "Minimize the UI window",
    Callback = function()
        Window:ToggleMinimize()
    end
})

-- Close window button (with confirmation)
WindowSection:AddButton({
    Name = "Close Window",
    Description = "Close the UI window permanently",
    Callback = function()
        print("Are you sure you want to close the window? This action cannot be undone.")
        print("Execute again within 5 seconds to confirm.")
        
        local confirmClose = false
        local startTime = tick()
        
        local connection
        connection = WindowSection:AddButton({
            Name = "CONFIRM CLOSE",
            Description = "Click to confirm window closure",
            Callback = function()
                if tick() - startTime <= 5 then
                    confirmClose = true
                    Window:Close()
                    connection:Remove()
                else
                    print("Confirmation expired. Window remains open.")
                    connection:Remove()
                end
            end
        })
        
        spawn(function()
            wait(5)
            if not confirmClose then
                connection:Remove()
                print("Close confirmation expired.")
            end
        end)
    end
})

-- Advanced demonstrations
local DemoSection = MiscTab:AddSection({
    Name = "Demonstrations"
})

-- Stress test button
DemoSection:AddButton({
    Name = "UI Stress Test",
    Description = "Creates multiple elements to test performance",
    Callback = function()
        print("Starting UI stress test...")
        
        for i = 1, 5 do
            local testSection = MiscTab:AddSection({
                Name = "Test Section " .. i
            })
            
            for j = 1, 3 do
                testSection:AddButton({
                    Name = "Test Button " .. j,
                    Description = "Generated for stress testing",
                    Callback = function()
                        print("Test button", i, j, "clicked")
                    end
                })
                
                testSection:AddToggle({
                    Name = "Test Toggle " .. j,
                    Description = "Generated for stress testing",
                    Default = false,
                    Callback = function(value)
                        print("Test toggle", i, j, "set to", value)
                    end
                })
            end
        end
        
        print("Stress test complete. Added", 5, "sections with", 30, "total elements.")
    end
})

-- Performance metrics button
DemoSection:AddButton({
    Name = "Show Performance Metrics",
    Description = "Display current performance statistics",
    Callback = function()
        local stats = game:GetService("Stats")
        
        print("=== Performance Metrics ===")
        print("Memory Usage:", math.floor(stats:GetTotalMemoryUsageMb()), "MB")
        print("FPS:", math.floor(1 / game:GetService("RunService").Heartbeat:Wait()))
        
        local network = stats.Network.ServerStatsItem
        print("Data Received:", math.floor(network["Data Ping"]:GetValue()), "KB/s")
        print("Ping:", math.floor(network["Data Ping"]:GetValue()), "ms")
        
        print("=========================")
    end
})

print("DoorLib UI Library loaded successfully!")
print("Window created with theme:", "Cyan")
print("Total tabs created:", 3)
print("UI is ready for use.")
