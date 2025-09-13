-- Main entry point for Stelariums UI Library
local Stelariums = {
    Version = "1.0.0",
    Components = {},
    Utils = {}
}

-- Import core modules
local Components = require(script.Parent.src.Components)
local Utils = require(script.Parent.src.Utils)

-- Initialize components
Stelariums.Components = Components
Stelariums.Utils = Utils

-- Create main API
function Stelariums.new()
    local self = setmetatable({}, {
        __index = Stelariums
    })
    
    return self
end

return Stelariums
