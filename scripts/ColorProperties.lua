-- Avatar color
avatar:color(vectors.hexToRGB("408ED7"))

-- Glowing outline
renderer:outlineColor(vectors.hexToRGB("408ED7"))

-- Host only instructions
if not host:isHost() then return end

-- Table setup
local c = {}

-- Action variables
c.hover     = vectors.hexToRGB("408ED7")
c.active    = vectors.hexToRGB("EED0A3")
c.primary   = "#408ED7"
c.secondary = "#EED0A3"

-- Return variables
return c