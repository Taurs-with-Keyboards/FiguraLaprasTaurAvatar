-- Model setup
local model     = models.LaprasTaur
local upperRoot = model.Player.UpperBody
local lowerRoot = model.Player.LowerBody

-- Squishy API Animations
local squapi = require("lib.SquAPI")

-- Ear Animations
local ears = upperRoot.Head.Ears
squapi.ear(ears.LeftEar, ears.RightEar, false, _, 0.35, _, 1, 0.05, 0.1)

-- LowerBody Physics
local main = lowerRoot.Main
squapi.centuarPhysics(main, main.FlipperFrontLeft, main.FlipperFrontLeft.Tip, main.FlipperFrontRight, main.FlipperFrontRight.Tip, main.FlipperBackLeft, main.FlipperBackLeft.Tip, main.FlipperBackRight, main.FlipperBackRight.Tip)