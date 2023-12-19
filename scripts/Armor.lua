-- Model setup
local model     = models.LaprasTaur
local modelRoot = model.Player

-- Katt armor setup
local kattArmor = require("lib.KattArmor")

-- Setting the leggings to layer 1
kattArmor.Armor.Leggings:setLayer(1)

-- Armor parts
kattArmor.Armor.Helmet
  :addParts(modelRoot.UpperBody.Head.Armor.Helmet)
kattArmor.Armor.Chestplate
  :addParts(
    modelRoot.UpperBody.Body.Armor.Chestplate,
    modelRoot.UpperBody.RightArm.Armor.Chestplate,
    modelRoot.UpperBody.LeftArm.Armor.Chestplate
  )
kattArmor.Armor.Leggings
  :addParts(
    modelRoot.UpperBody.Body.Armor.Belt,
    modelRoot.LowerBody.Front.Armor.Leggings
  )
kattArmor.Armor.Boots
  :addParts(
    modelRoot.LowerBody.Main.FlipperFrontRight.Armor.Boot,
    modelRoot.LowerBody.Main.FlipperFrontLeft.Armor.Boot,
    modelRoot.LowerBody.Main.FlipperBackRight.Armor.Boot,
    modelRoot.LowerBody.Main.FlipperBackLeft.Armor.Boot
  )

-- Leather armor
kattArmor.Materials.leather
  :setTexture(textures["textures.armor.leatherArmor"])
  :addParts(kattArmor.Armor.Helmet,
    modelRoot.UpperBody.Head.Armor.HelmetLeather
  )
  :addParts(kattArmor.Armor.Leggings,
    modelRoot.UpperBody.Body.Armor.BeltLeather,
    modelRoot.LowerBody.Front.Armor.LeggingsLeather
  )
  :addParts(kattArmor.Armor.Boots,
    modelRoot.LowerBody.Main.FlipperFrontRight.Armor.BootLeather,
    modelRoot.LowerBody.Main.FlipperFrontLeft.Armor.BootLeather,
    modelRoot.LowerBody.Main.FlipperBackRight.Armor.BootLeather,
    modelRoot.LowerBody.Main.FlipperBackLeft.Armor.BootLeather
  )

-- Chainmail armor
kattArmor.Materials.chainmail
  :setTexture(textures["textures.armor.chainmailArmor"])

-- Iron armor
kattArmor.Materials.iron
  :setTexture(textures["textures.armor.ironArmor"])

-- Golden armor
kattArmor.Materials.golden
  :setTexture(textures["textures.armor.goldenArmor"])

-- Diamond armor
kattArmor.Materials.diamond
  :setTexture(textures["textures.armor.diamondArmor"])

-- Netherite armor
kattArmor.Materials.netherite
  :setTexture(textures["textures.armor.netheriteArmor"])

-- Turtle helmet
kattArmor.Materials.turtle
  :setTexture(textures["textures.armor.turtleHelmet"])