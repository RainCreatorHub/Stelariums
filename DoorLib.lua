--[[Door Library
Created by RainCreatorHub
n é eu nn é o copilot
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local DoorLib = {}
DoorLib.__index = DoorLib

function DoorLib:MakeWindow(config)
    local window = setmetatable({}, DoorLib)
    window.ScreenGui = Instance.new("ScreenGui")
    window.ScreenGui.Name = "DoorLib"
    window.ScreenGui.Parent = CoreGui
    
    window.MainFrame = Instance.new("Frame")
    window.MainFrame.Name = "MainFrame"
    window.MainFrame.Size = config.DefaultSize or UDim2.new(0, 470, 0, 340)
    window.MainFrame.Position = UDim2.new(0.5, -235, 0.5, -170)
    window.MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    window.MainFrame.Parent = window.ScreenGui
    
    return window
end

return DoorLib
