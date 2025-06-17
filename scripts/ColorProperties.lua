-- Avatar color
avatar:color(vectors.hexToRGB("5EB7DD"))

-- Glowing outline
renderer:outlineColor(vectors.hexToRGB("5EB7DD"))

-- Host only instructions
if not host:isHost() then return end

-- Table setup
local c = {}

-- Action variables
c.hover     = vectors.hexToRGB("5EB7DD")
c.active    = vectors.hexToRGB("EFDBBC")
c.primary   = "#5EB7DD"
c.secondary = "#EFDBBC"

-- Return variables
return c