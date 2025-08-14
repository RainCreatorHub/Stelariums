local ParagraphImage = {}
ParagraphImage.__index = ParagraphImage

function ParagraphImage.new(parent, config)
    local self = setmetatable({}, ParagraphImage)
    
    self.parent = parent
    self.config = config
    
    self:createUI()
    
    return self
end

function ParagraphImage:createUI()
    self.Frame = Instance.new("Frame")
    self.Frame.Name = self.config.Name or "ParagraphImageFrame"
    self.Frame.Size = UDim2.new(1, -40, 0, 0)
    self.Frame.AutomaticSize = Enum.AutomaticSize.Y
    self.Frame.BackgroundTransparency = 1
    self.Frame.Parent = self.parent

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Padding = UDim.new(0, 15)
    layout.Parent = self.Frame

    -- Cria o primeiro par (Descrição + Imagem)
    if self.config.Description then
        self:CreateParagraph(self.config.Description)
    end
    if self.config.Image then
        self:CreateImage(self.config.Image)
    end

    -- Loop para criar os pares contínuos (CDescription1, Image2, CDescription2, etc.)
    local i = 1
    while true do
        local descKey = "CDescription" .. i
        local imgKey = "Image" .. (i + 1)

        local hasDesc = self.config[descKey]
        local hasImg = self.config[imgKey]

        if not hasDesc and not hasImg then
            break -- Para o loop se não houver mais descrições ou imagens na sequência
        end

        if hasDesc then
            self:CreateParagraph(self.config[descKey])
        end
        if hasImg then
            self:CreateImage(self.config[imgKey])
        end
        
        i = i + 1
    end
end

function ParagraphImage:CreateParagraph(text)
    local ParagraphLabel = Instance.new("TextLabel")
    ParagraphLabel.Name = "Paragraph"
    ParagraphLabel.Size = UDim2.new(1, 0, 0, 0)
    ParagraphLabel.AutomaticSize = Enum.AutomaticSize.Y
    ParagraphLabel.BackgroundTransparency = 1
    ParagraphLabel.Font = Enum.Font.Gotham
    ParagraphLabel.Text = text
    ParagraphLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    ParagraphLabel.TextSize = 16
    ParagraphLabel.TextWrapped = true
    ParagraphLabel.TextXAlignment = Enum.TextXAlignment.Left
    ParagraphLabel.Parent = self.Frame
end

function ParagraphImage:CreateImage(assetId)
    local ImageLabel = Instance.new("ImageLabel")
    ImageLabel.Name = "DisplayImage"
    ImageLabel.Size = UDim2.new(1, 0, 0, 150)
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = assetId
    ImageLabel.ScaleType = Enum.ScaleType.Fit
    ImageLabel.Parent = self.Frame
end

return ParagraphImage
