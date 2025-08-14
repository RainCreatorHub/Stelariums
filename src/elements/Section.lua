local Section = {}
Section.__index = Section

local ElementBuilder = {}
function ElementBuilder:__index(key)
    local moduleName = key:sub(1,1):upper() .. key:sub(2):lower() .. "Module"
    local elementModule = self.dependencies[moduleName]

    if elementModule then
        return function(config)
            config = config or {}
            local instance = elementModule.new(self.container, config)
            table.insert(self.elements, instance)
            return instance
        end
    end
end

function Section.new(config)
    local self = setmetatable({}, Section)
    
    self.title = config.Name or "Section"
    self.parent = config.Parent
    self.dependencies = config.Dependencies
    self.elements = {}
    
    self:createUI()
    
    local builder = {
        container = self.ContentFrame,
        dependencies = self.dependencies,
        elements = self.elements
    }
    setmetatable(self, {__index = getmetatable(self).__index or self, __index = ElementBuilder})
    
    return self
end

function Section:createUI()
    self.Frame = Instance.new("Frame")
    self.Frame.Name = self.Name .. "_Section"
    self.Frame.Size = UDim2.new(1, -40, 0, 0)
    self.Frame.AutomaticSize = Enum.AutomaticSize.Y
    self.Frame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    self.Frame.BorderSizePixel = 1
    self.Frame.BorderColor3 = Color3.fromRGB(15, 15, 15)
    self.Frame.Parent = self.parent

    self.ContentFrame = Instance.new("Frame")
    self.ContentFrame.Name = "SectionContent"
    self.ContentFrame.Size = UDim2.new(1, 0, 1, 0)
    self.ContentFrame.AutomaticSize = Enum.AutomaticSize.Y
    self.ContentFrame.BackgroundTransparency = 1
    self.ContentFrame.Parent = self.Frame

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Parent = self.ContentFrame
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 35)
    padding.PaddingBottom = UDim.new(0, 15)
    padding.PaddingLeft = UDim.new(0, 15)
    padding.PaddingRight = UDim.new(0, 15)
    padding.Parent = self.Frame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "SectionTitle"
    TitleLabel.Size = UDim2.new(1, 0, 0, 25)
    TitleLabel.Position = UDim2.new(0, 0, 0, 0)
    TitleLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TitleLabel.Font = Enum.Font.GothamSemibold
    TitleLabel.Text = " " .. self.Name
    TitleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = self.Frame
end

return Section
