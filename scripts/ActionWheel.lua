-- Connects various actions accross many scripts into pages
local mainPage = action_wheel:newPage()
action_wheel:setPage(mainPage)

mainPage:setAction( -1, require("scripts.GlowingEyes"))
  :setAction( -1, require("scripts.FlopSound"))
  :setAction( -1, require("scripts.WhirlpoolEffect"))
  :setAction( -1, require("scripts.Pehkui"))
  :setAction( -1, require("scripts.Pokeball"))
  :setAction( -1, require("scripts.CameraControl"))