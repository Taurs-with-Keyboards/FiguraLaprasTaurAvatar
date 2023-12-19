local Config = {
  -- Should the model get textures from the player's skin?
  usesPlayerSkin = true,
  -- Should the model use Alex proportions, or Steve proportions?
  isAlex = true,
  -- How should the Whirl Pool be handled?
  -- Set to `true` to have it enabled by default.
  -- Set to `false` to have it disabled by default.
  -- Set to `nil` to allow the Dolphins Grace Status Effect to control it. This will also prevent an ActionWheel action from being created.
  whirlPoolEffect = true,
  -- How should the glowing eyes be handled?
  -- Set to `true` to have them enabled by default.
  -- Set to `false` to have them disabled by default.
  -- Set to `nil` to allow the merling origin to control them. This will also prevent an ActionWheel action from being created.
  glowingEyes = true,
  -- Should the Lapras Body make noise when you land after falling/jumping?
  landSound = true,
  -- How many ticks should it take for you to dry off after leaving water/rain? (20 ticks = 1 second)
  waterTimer = 400,
  -- Should your arms have movement while moving? (except when swimming or crawling)
  armMovement = false,
  -- Should your Camera match your head's position?
  matchCamera = true,
  cameraWarn  = true,
}
return Config
