local Config = {
  -- Should the model get textures from the player's skin.
  usesPlayerSkin = false,
  -- Should the model use Alex proportions, or Steve proportions.
  isAlex = true,
  -- Should the Lapras Body make noise when you land after falling/jumping.
  landSound = true,
  -- How many ticks should it take for you to dry off after leaving water/rain? (20 ticks = 1 second)
  waterTimer = 400,
  -- Should your arms have movement while moving? (except when swimming or crawling)
  armMovement = true,
  -- Should your Camera match your head's position?
  matchCamera = false,
  cameraWarn  = true,
}
return Config
