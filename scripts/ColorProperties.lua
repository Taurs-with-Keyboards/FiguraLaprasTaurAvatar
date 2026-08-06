-- Avatar color
avatar:color(vectors.hexToRGB("408ED7"))

-- Glowing outline
renderer:outlineColor(vectors.hexToRGB("408ED7"))

-- Host only instructions
if not host:isHost() then return end

-- Table setup
local colors = {}

-- Action variables
colors.hover     = vectors.hexToRGB("408ED7")
colors.active    = vectors.hexToRGB("EED0A3")
colors.primary   = "#408ED7"
colors.secondary = "#EED0A3"

-- Return variables
return colors