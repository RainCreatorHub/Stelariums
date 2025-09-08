--[[
Antes de falr a mas o rain/zaka_script usou IA, eu n to querendo fazer mais lib e depois públicar em uma conta ai ninguém usar ai n vale a pena meu mano.
Estou fazendo isso pq estou sem nada para fazer.

IA usada: Claude
Web site: claude.ai
]]










-- DoorLib UI Library
-- Advanced Roblox UI Library with modular structure
-- Created with cyan, blue, and black theme support

local DoorLib = {}
DoorLib.__index = DoorLib

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")

-- Variables
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("CoreGui")

-- Themes
DoorLib.Themes = {
    Dark = {
        Primary = Color3.fromRGB(25, 25, 35),
        Secondary = Color3.fromRGB(35, 35, 45),
        Accent = Color3.fromRGB(0, 162, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(200, 200, 200),
        Border = Color3.fromRGB(65, 65, 75),
        Success = Color3.fromRGB(46, 204, 113),
        Warning = Color3.fromRGB(241, 196, 15),
        Error = Color3.fromRGB(231, 76, 60)
    },
    Light = {
        Primary = Color3.fromRGB(240, 240, 245),
        Secondary = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(0, 122, 255),
        Text = Color3.fromRGB(50, 50, 50),
        TextSecondary = Color3.fromRGB(100, 100, 100),
        Border = Color3.fromRGB(220, 220, 230),
        Success = Color3.fromRGB(46, 204, 113),
        Warning = Color3.fromRGB(241, 196, 15),
        Error = Color3.fromRGB(231, 76, 60)
    },
    Cyan = {
        Primary = Color3.fromRGB(15, 25, 35),
        Secondary = Color3.fromRGB(25, 35, 45),
        Accent = Color3.fromRGB(0, 255, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(180, 220, 255),
        Border = Color3.fromRGB(0, 200, 200),
        Success = Color3.fromRGB(46, 204, 113),
        Warning = Color3.fromRGB(241, 196, 15),
        Error = Color3.fromRGB(231, 76, 60)
    }
}

-- Utility Functions
function DoorLib:CreateTween(object, info, properties)
    local tweenInfo = TweenInfo.new(
        info.Duration or 0.3,
        info.EasingStyle or Enum.EasingStyle.Quad,
        info.EasingDirection or Enum.EasingDirection.Out,
        info.RepeatCount or 0,
        info.Reverses or false,
        info.DelayTime or 0
    )
    return TweenService:Create(object, tweenInfo, properties)
end

function DoorLib:CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 6)
    corner.Parent = parent
    return corner
end

function DoorLib:CreateStroke(parent, thickness, color)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.Color = color or Color3.fromRGB(65, 65, 75)
    stroke.Parent = parent
    return stroke
end

function DoorLib:CreateGradient(parent, colors, rotation)
    local gradient = Instance.new("UIGradient")
    local colorSequence = {}
    
    for i, colorData in ipairs(colors) do
        table.insert(colorSequence, ColorSequenceKeypoint.new(colorData[1], colorData[2]))
    end
    
    gradient.Color = ColorSequence.new(colorSequence)
    gradient.Rotation = rotation or 0
    gradient.Parent = parent
    return gradient
end

-- Load Components
DoorLib.TitleBar = require(script.src.components.TitleBar)
DoorLib.Window = require(script.src.components.Window)
DoorLib.Section = require(script.src.elements.Section)
DoorLib.Button = require(script.src.elements.Button)
DoorLib.Toggle = require(script.src.elements.Toggle)
DoorLib.Slider = require(script.src.elements.Slider)
DoorLib.TextBox = require(script.src.elements.TextBox)
DoorLib.Dropdown = require(script.src.elements.Dropdown)
DoorLib.ColorPicker = require(script.src.elements.ColorPicker)
DoorLib.Keybind = require(script.src.elements.Keybind)

-- Main Window Creation Function
function DoorLib:MakeWindow(Info)
    Info = Info or {}
    
    local WindowInfo = {
        Title = Info.Title or "DoorLib Window",
        SubTitle = Info.SubTitle or "By anonymous",
        Resizable = Info.Resizable or true,
        Theme = Info.Theme or "Dark",
        Size = Info.Size or UDim2.new(0, 500, 0, 400),
        Position = Info.Position or UDim2.new(0.5, -250, 0.5, -200)
    }
    
    return DoorLib.Window.new(WindowInfo, DoorLib)
end

return DoorLib
