local Tab = {}
Tab.__index = Tab

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

function Tab.new(config)
    local self = setmetatable({}, Tab)
    
    self.name = config.Name
    self.icon = config.Icon
    self.content = config.Content
    self.parent = config.Parent
    self.contentPage = config.ContentPage
    self.dependencies = config.Dependencies
    self.elements = {}
    
    self:createButton()
    
    local builder = {
        container = self.contentPage,
        dependencies = self.dependencies,
        elements = self.elements
    }
    setmetatable(self, {__index = getmetatable(self).__index or self, __index = ElementBuilder})
    
    return self
end

function Tab:createButton()
    self.Button = Instance.new("TextButton")
    self.Button.Name = self.name
    self.Button.Size = UDim2.new(0, 0, 0, 30)
    self.Button.AutomaticSize = Enum.AutomaticSize.X
    self.Button.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    self.Button.Text = "  " .. self.name .. "  "
    self.Button.Font = Enum.Font.Gotham
    self.Button.TextColor3 = Color3.fromRGB(160, 160, 160)
    self.Button.TextXAlignment = Enum.TextXAlignment.Left
    self.Button.AutoButtonColor = false
    self.Button.Parent = self.parent
    
    if self.icon and self.dependencies.Icons and self.dependencies.Icons[self.icon] then
        local IconImage = Instance.new("ImageLabel")
        IconImage.Size = UDim2.new(0, 18, 0, 18)
        IconImage.Position = UDim2.new(0, 8, 0.5, -9)
        IconImage.BackgroundTransparency = 1
        IconImage.Image = self.dependencies.Icons[self.icon]
        IconImage.Parent = self.Button
        self.Button.Text = "      " .. self.name .. "  "
    end
    
    if self.content then
        local TooltipModule = self.dependencies.FetchModule("components/Tooltip.lua")
        if TooltipModule then
            TooltipModule.new(self.Button, self.content)
        end
    end
end

function Tab:SetActive(active)
    self.contentPage.Visible = active
    if active then
        self.Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        self.Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        self.Button.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        self.Button.TextColor3 = Color3.fromRGB(160, 160, 160)
    end
end

function Tab:Section(config)
    local instance = self.dependencies.SectionModule.new({
        Title = config.Title,
        Parent = self.contentPage,
        Dependencies = self.dependencies
    })
    table.insert(self.elements, instance)
    return instance
end

function Tab:AddParagraphI(config)
    local instance = self.dependencies.ParagraphImageModule.new(self.contentPage, config)
    table.insert(self.elements, instance)
    return instance
end

return Tab
