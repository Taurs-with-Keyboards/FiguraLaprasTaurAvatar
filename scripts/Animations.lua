-- Model setup
local model     = models.LaprasTaur
local modelRoot = model.Player
local lapras    = modelRoot.LowerBody

-- Rotation Animations
local rotParts = {
  { part = lapras,
      rot = {
        groundIdle = {
          x = "-math.clamp(math.sin(lerpTime * 180) * 0.25, 0, 2) - math.clamp(math.sin(lerpTime * 180) * 0.25, -2, 0)",
          y = "0",
          z = "0"
        },
        groundMove = {
          x = "-math.clamp(math.sin(lerpTime * 180) * 0.25, 0, 2) - math.clamp(math.sin(lerpTime * 180) * 0.25, -2, 0)",
          y = "0",
          z = "0"
        },
        waterIdle = {
          x = "-math.clamp(math.sin(lerpTime * 180) * 2, 0, 2) - math.clamp(math.sin(lerpTime * 180) * 2, -2, 0)",
          y = "0",
          z = "0"
        },
        waterSwim = {
          x = "-math.clamp(math.sin(lerpTime * 180 - 180) * 2, 0, 2) - math.clamp(math.sin(lerpTime * 180 - 180) * 2, -2, 0)",
          y = "0",
          z = "0"
        },
        underwaterIdle = {
          x = "-math.clamp(math.sin(lerpTime * 180), 0, 2) - math.clamp(math.sin(lerpTime * 180), -2, 0)",
          y = "0",
          z = "0"
        },
        underwaterSwim = {
          x = "-math.clamp(math.sin(lerpTime * 180), 0, 2) - math.clamp(math.sin(lerpTime * 180) * 4, -5, 0)",
          y = "0",
          z = "0"
        }
      },
      cur      = 0,
      nextTick = 0,
      target   = 0,
      curPos   = 0
  },
  { part = lapras.Main.FlipperFrontRight,
      rot = {
        groundIdle = {
          x = "0",
          y = "-10",
          z = "10 + math.sin(lerpTime * 180 / 3 + 90)"
        },
        groundMove = {
          x = "-math.clamp(math.sin(lerpTime * 90 - 120) * -10, -42, 0) - math.clamp(math.sin(lerpTime * 90 - 300) * -10, -42, 0) + math.clamp(math.sin(lerpTime * 180 + 120) * -10, -42, 0)",
          y = "(10 - math.clamp(math.sin(lerpTime * 180 + 270) * 32, -15, 32) - math.clamp(math.sin(lerpTime * 180 + 270) * 60, -20, 0) - math.clamp(math.sin(lerpTime * 180 + 270) * 20, -15, 0) - math.clamp(math.sin(lerpTime * 180 + 270) * 15, -15, 0)) * -0.8",
          z = "-10 + math.clamp(math.sin(lerpTime * 180 - 225) * 20, 0, 30) + math.clamp(math.sin(lerpTime * 180 - 205) * 7, -2, 0) - math.clamp(math.sin(lerpTime * 180 - 205), -2, 0) + (math.clamp(math.sin(lerpTime * 180 + 250), -1, -0.8) + 0.8) * 40"
        },
        waterIdle = {
          x = "math.clamp(math.sin(lerpTime * 180) * 2, 0, 2) + math.clamp(math.sin(lerpTime * 180) * 2, -2, 0)",
          y = "-(math.clamp(math.sin(lerpTime * 180 - 90) * 1.5, 0, 1) + math.clamp(math.sin(lerpTime * 180 - 90) * 2.5, 0, 6) + math.clamp(math.sin(lerpTime * 180 - 90) * 1.5, -1, 0) + math.clamp(math.sin(lerpTime * 180 - 90) * 2, -4, 0) + 10)",
          z = "10 + math.sin(lerpTime * 180 / 3 + 90) * 6"
        },
        waterSwim = {
          x = "math.clamp(math.sin(lerpTime * 90) * 8, 0, 10) - math.clamp(math.sin(lerpTime * 90) * 8, -10, 0) - math.clamp(math.sin(lerpTime * 180) * 4, -10, 0)",
          y = "-(math.clamp(math.sin(lerpTime * 180 - 90) * 4, 0, 5) + math.clamp(math.sin(lerpTime * 180 - 90) * 8, -2, 7) + math.clamp(math.sin(lerpTime * 180 - 75) * 15, -15, 0) + math.clamp(math.sin(lerpTime * 180 - 90) * 5, -10, 0) + 10)",
          z = "10 + math.sin(lerpTime * 180) * 6"
        },
        underwaterIdle = {
          x = "math.clamp(math.sin(lerpTime * 180) * 2, 0, 2) + math.clamp(math.sin(lerpTime * 180) * 2, -2, 0)",
          y = "-(math.clamp(math.sin(lerpTime * 180 - 90) * 1.5, 0, 1) + math.clamp(math.sin(lerpTime * 180 - 90) * 2.5, 0, 6) + math.clamp(math.sin(lerpTime * 180 - 90) * 1.5, -1, 0) + math.clamp(math.sin(lerpTime * 180 - 90) * 2, -4, 0) - 10)",
          z = "10 + math.sin(lerpTime * 180 / 3 + 90) * 6"
        },
        underwaterSwim = {
          x = "math.clamp(math.sin(lerpTime * 90 + 45) * 8, 0, 10) - math.clamp(math.sin(lerpTime * 90 + 45) * 8, -10, 0) - math.clamp(math.sin(lerpTime * 180 + 90) * 4, -10, 0)",
          y = "-(math.clamp(math.sin(lerpTime * 180) * 4, 0, 5) + math.clamp(math.sin(lerpTime * 180) * 20, -2, 25) + math.clamp(math.sin(lerpTime * 180 + 45) * 4, -5, 0) + math.clamp(math.sin(lerpTime * 180 + 25) * 8, -7, 4))",
          z = "-(20 - math.clamp(math.sin(lerpTime * 180) * 80, 0, 200) + math.clamp(math.sin(lerpTime * 180 - 140) * 30, -10, 25) - math.clamp(math.sin(lerpTime * 180) * 35, -30, 0))"
        }
      },
      cur      = 0,
      nextTick = 0,
      target   = 0,
      curPos   = 0
  },
  { part = lapras.Main.FlipperFrontRight.FlipperFrontRight,
      rot = {
        groundIdle = {
          x = "0",
          y = "0",
          z = "-10 - math.clamp(math.sin(lerpTime * 180 + 90) * 1.5, 0, 1) - math.clamp(math.sin(lerpTime * 180 + 90) * 2.5, 0, 6) - math.clamp(math.sin(lerpTime * 180 + 90) * 1.5, -1, 0) - math.clamp(math.sin(lerpTime * 180 + 90) * 2, -4, 0)"
        },
        groundMove = {
          x = "0",
          y = "0",
          z = "-7.5 + math.clamp(math.sin(lerpTime * 180 + 90 - 150) * 12, 0, 12) - math.clamp(math.sin(lerpTime * 180 + 270) * 1.5, 0, 1) + math.clamp(math.sin(lerpTime * 180 + 270) * 2, 0, 6) - math.clamp(math.sin(lerpTime * 180 + 270) * 1.5, -1, 0) + math.clamp(math.sin(lerpTime * 180 + 270) * 10, -10, 0) - (math.clamp(math.sin(lerpTime * 180 + 250), -1, -0.8) + 0.8) * 40"
        },
        waterIdle = {
          x = "0",
          y = "0",
          z = "5 - math.clamp(math.sin(lerpTime * 180 + 90) * 1.5, 0, 1) - math.clamp(math.sin(lerpTime * 180 + 90) * 2.5, 0, 6) - math.clamp(math.sin(lerpTime * 180 + 90) * 1.5, -1, 0) - math.clamp(math.sin(lerpTime * 180 + 90) * 2, -4, 0)"
        },
        waterSwim = {
          x = "0",
          y = "0",
          z = "5 - math.clamp(math.sin(lerpTime * 180 + 90) * 1.5, 0, 1) - math.clamp(math.sin(lerpTime * 180 + 90) * 2.5, 0, 6) - math.clamp(math.sin(lerpTime * 180 + 90) * 1.5, -1, 0) - math.clamp(math.sin(lerpTime * 180 + 90) * 2, -4, 0)"
        },
        underwaterIdle = {
          x = "0",
          y = "0",
          z = "5 - math.clamp(math.sin(lerpTime * 180 + 90) * 1.5, 0, 1) - math.clamp(math.sin(lerpTime * 180 + 90) * 2.5, 0, 6) - math.clamp(math.sin(lerpTime * 180 + 90) * 1.5, -1, 0) - math.clamp(math.sin(lerpTime * 180 + 90) * 2, -4, 0)"
        },
        underwaterSwim = {
          x = "0",
          y = "0",
          z = "-math.clamp(math.sin(lerpTime * 180 - 45) * 5, 0, 200) - math.clamp(math.sin(lerpTime * 180 - 185) * 10, 0, 8) + math.clamp(math.sin(lerpTime * 180 - 45) * 25, -20, 15)"
        }
      },
      cur      = 0,
      nextTick = 0,
      target   = 0,
      curPos   = 0
  },
  { part = lapras.Main.FlipperFrontLeft,
      rot = {
        groundIdle = {
          x = "0",
          y = "10",
          z = "-10 - math.sin(lerpTime * 180 / 3 + 90)"
        },
        groundMove = {
          x = "-math.clamp(math.sin(lerpTime * 90 - 120) * -10, -42, 0) - math.clamp(math.sin(lerpTime * 90 - 300) * -10, -42, 0) + math.clamp(math.sin(lerpTime * 180 + 120) * -10, -42, 0)",
          y = "(10 - math.clamp(math.sin(lerpTime * 180 + 270) * 32, -15, 32) - math.clamp(math.sin(lerpTime * 180 + 270) * 60, -20, 0) - math.clamp(math.sin(lerpTime * 180 + 270) * 20, -15, 0) - math.clamp(math.sin(lerpTime * 180 + 270) * 15, -15, 0)) * 0.8",
          z = "10 - math.clamp(math.sin(lerpTime * 180 - 225) * 20, 0, 30) - math.clamp(math.sin(lerpTime * 180 - 205) * 7, -2, 0) + math.clamp(math.sin(lerpTime * 180 - 205), -2, 0) - (math.clamp(math.sin(lerpTime * 180 + 250), -1, -0.8) + 0.8) * 40"
        },
        waterIdle = {
          x = "math.clamp(math.sin(lerpTime * 180) * 2, 0, 2) + math.clamp(math.sin(lerpTime * 180) * 2, -2, 0)",
          y = "math.clamp(math.sin(lerpTime * 180 - 90) * 1.5, 0, 1) + math.clamp(math.sin(lerpTime * 180 - 90) * 2.5, 0, 6) + math.clamp(math.sin(lerpTime * 180 - 90) * 1.5, -1, 0) + math.clamp(math.sin(lerpTime * 180 - 90) * 2, -4, 0) + 10",
          z = "-10 - math.sin(lerpTime * 180 / 3 + 90) * 6"
        },
        waterSwim = {
          x = "math.clamp(math.sin(lerpTime * 90) * 8, 0, 10) - math.clamp(math.sin(lerpTime * 90) * 8, -10, 0) - math.clamp(math.sin(lerpTime * 180) * 4, -10, 0)",
          y = "math.clamp(math.sin(lerpTime * 180 - 90) * 4, 0, 5) + math.clamp(math.sin(lerpTime * 180 - 90) * 8, -2, 7) + math.clamp(math.sin(lerpTime * 180 - 75) * 15, -15, 0) + math.clamp(math.sin(lerpTime * 180 - 90) * 5, -10, 0) + 10",
          z = "-10 - math.sin(lerpTime * 180) * 6"
        },
        underwaterIdle = {
          x = "math.clamp(math.sin(lerpTime * 180) * 2, 0, 2) + math.clamp(math.sin(lerpTime * 180) * 2, -2, 0)",
          y = "math.clamp(math.sin(lerpTime * 180 - 90) * 1.5, 0, 1) + math.clamp(math.sin(lerpTime * 180 - 90) * 2.5, 0, 6) + math.clamp(math.sin(lerpTime * 180 - 90) * 1.5, -1, 0) + math.clamp(math.sin(lerpTime * 180 - 90) * 2, -4, 0) - 10",
          z = "-10 - math.sin(lerpTime * 180 / 3 + 90) * 6"
        },
        underwaterSwim = {
          x = "math.clamp(math.sin(lerpTime * 90 + 45) * 8, 0, 10) - math.clamp(math.sin(lerpTime * 90 + 45) * 8, -10, 0) - math.clamp(math.sin(lerpTime * 180 + 90) * 4, -10, 0)",
          y = "math.clamp(math.sin(lerpTime * 180) * 4, 0, 5) + math.clamp(math.sin(lerpTime * 180) * 20, -2, 25) + math.clamp(math.sin(lerpTime * 180 + 45) * 4, -5, 0) + math.clamp(math.sin(lerpTime * 180 + 25) * 8, -7, 4)",
          z = "20 - math.clamp(math.sin(lerpTime * 180) * 80, 0, 200) + math.clamp(math.sin(lerpTime * 180 - 140) * 30, -10, 25) - math.clamp(math.sin(lerpTime * 180) * 35, -30, 0)"
        }
      },
      cur      = 0,
      nextTick = 0,
      target   = 0,
      curPos   = 0
  },
  { part = lapras.Main.FlipperFrontLeft.FlipperFrontLeft,
      rot = {
        groundIdle = {
          x = "0",
          y = "0",
          z = "10 + math.clamp(math.sin(lerpTime * 180 + 90) * 1.5, 0, 1) + math.clamp(math.sin(lerpTime * 180 + 90) * 2.5, 0, 6) + math.clamp(math.sin(lerpTime * 180 + 90) * 1.5, -1, 0) + math.clamp(math.sin(lerpTime * 180 + 90) * 2, -4, 0)"
        },
        groundMove = {
          x = "0",
          y = "0",
          z = "7.5 - math.clamp(math.sin(lerpTime * 180 + 90 - 150) * 12, 0, 12) + math.clamp(math.sin(lerpTime * 180 + 270) * 1.5, 0, 1) - math.clamp(math.sin(lerpTime * 180 + 270) * 2, 0, 6) + math.clamp(math.sin(lerpTime * 180 + 270) * 1.5, -1, 0) - math.clamp(math.sin(lerpTime * 180 + 270) * 10, -10, 0) + (math.clamp(math.sin(lerpTime * 180 + 250), -1, -0.8) + 0.8) * 40"
        },
        waterIdle = {
          x = "0",
          y = "0",
          z = "-5 + math.clamp(math.sin(lerpTime * 180 + 90) * 1.5, 0, 1) + math.clamp(math.sin(lerpTime * 180 + 90) * 2.5, 0, 6) + math.clamp(math.sin(lerpTime * 180 + 90) * 1.5, -1, 0) + math.clamp(math.sin(lerpTime * 180 + 90) * 2, -4, 0)"
        },
        waterSwim = {
          x = "0",
          y = "0",
          z = "-5 + math.clamp(math.sin(lerpTime * 180 + 90) * 1.5, 0, 1) + math.clamp(math.sin(lerpTime * 180 + 45) * 10, 0, 20) + math.clamp(math.sin(lerpTime * 180 + 90) * 1.5, -1, 0) + math.clamp(math.sin(lerpTime * 180 + 90) * 2, -4, 0)"
        },
        underwaterIdle = {
          x = "0",
          y = "0",
          z = "-5 + math.clamp(math.sin(lerpTime * 180 + 90) * 1.5, 0, 1) + math.clamp(math.sin(lerpTime * 180 + 90) * 2.5, 0, 6) + math.clamp(math.sin(lerpTime * 180 + 90) * 1.5, -1, 0) + math.clamp(math.sin(lerpTime * 180 + 90) * 2, -4, 0)"
        },
        underwaterSwim = {
          x = "0",
          y = "0",
          z = "math.clamp(math.sin(lerpTime * 180 - 45) * 5, 0, 200) + math.clamp(math.sin(lerpTime * 180 - 185) * 10, 0, 8) - math.clamp(math.sin(lerpTime * 180 - 45) * 25, -20, 15)"
        }
      },
      cur      = 0,
      nextTick = 0,
      target   = 0,
      curPos   = 0
  },
  { part = lapras.Main.FlipperBackRight,
      rot = {
        groundIdle = {
          x = "0",
          y = "10",
          z = "12.5 + math.sin(lerpTime * 180 / 3 + 90) * 2"
        },
        groundMove = {
          x = "0",
          y = "10 + math.clamp(math.sin(lerpTime * 180 + 290) * 35, 0, 30) + math.clamp(math.sin(lerpTime * 180 + 290) * 30, -15, 0) + math.clamp(math.sin(lerpTime * 180 + 290) * 25, -20, 0)",
          z = "5 - math.clamp(math.sin(lerpTime * 180 - 380) * 8, 0, 5) - math.clamp(math.sin(lerpTime * 180 - 380) * 10, -20, 0)"
        },
        waterIdle = {
          x = "math.clamp(math.sin(lerpTime * 180) * 2, 0, 2) + math.clamp(math.sin(lerpTime * 180) * 2, -2, 0)",
          y = "-(math.clamp(math.sin(lerpTime * 180) * 1.5, 0, 1) + math.clamp(math.sin(lerpTime * 180) * 2.5, 0, 6) + math.clamp(math.sin(lerpTime * 180) * 1.5, -1, 0) + math.clamp(math.sin(lerpTime * 180) * 2, -4, 0) - 10)",
          z = "10 + math.sin(lerpTime * 180 / 3 + 90) * 6"
        },
        waterSwim = {
          x = "math.clamp(math.sin(lerpTime * 90) * 2, 0, 10) - math.clamp(math.sin(lerpTime * 90) * 2, -10, 0) - math.clamp(math.sin(lerpTime * 180) * 5, -10, 0)",
          y = "-(math.clamp(math.sin(lerpTime * 180 - 115) * 4, 0, 5) + math.clamp(math.sin(lerpTime * 180 - 135) * 8, -2, 8) + math.clamp(math.sin(lerpTime * 180 - 120) * 15 / 2, -15, 0) + math.clamp(math.sin(lerpTime * 180 - 90) * 5, -10, 0) - 10)",
          z = "-(-math.clamp(math.sin(lerpTime * 180 - 45) * 5, 0, 10) - math.clamp(math.sin(lerpTime * 180 - 45) * 15, -20, 0) - 5)"
        },
        underwaterIdle = {
          x = "math.clamp(math.sin(lerpTime * 180) * 2, 0, 2) + math.clamp(math.sin(lerpTime * 180) * 2, -2, 0)",
          y = "-(math.clamp(math.sin(lerpTime * 180) * 1.5, 0, 1) + math.clamp(math.sin(lerpTime * 180) * 2.5, 0, 6) + math.clamp(math.sin(lerpTime * 180) * 1.5, -1, 0) + math.clamp(math.sin(lerpTime * 180) * 2, -4, 0) + 10)",
          z = "10 + math.sin(lerpTime * 180 / 3 + 90) * 6"
        },
        underwaterSwim = {
          x = "math.clamp(math.sin(lerpTime * 90 + 180) * 8, 0, 10) - math.clamp(math.sin(lerpTime * 90 + 180) * 8, -10, 0) + math.clamp(math.sin(lerpTime * 180 + 180) * 4, -10, 0)",
          y = "10 - math.clamp(math.sin(lerpTime * 180 + 225) * 10, 10, 20) + math.clamp(math.sin(lerpTime * 90) * 15, 0, 20) + math.clamp(math.sin(lerpTime * 90 + 180) * 15, 0, 20)",
          z = "math.clamp(math.sin(lerpTime * 180 - 190) * 40, 0, 200) - math.clamp(math.sin(lerpTime * 180 + 20) * 40, -10, 40) + math.clamp(math.sin(lerpTime * 180 + 180) * 35, -40, 0)"
        }
      },
      cur      = 0,
      nextTick = 0,
      target   = 0,
      curPos   = 0
  },
  { part = lapras.Main.FlipperBackRight.FlipperBackRight,
      rot = {
        groundIdle = {
          x = "0",
          y = "0",
          z = "-12.5 - math.clamp(math.sin(lerpTime * 180 + 90) * 1.5, 0, 1) - math.clamp(math.sin(lerpTime * 180 + 90) * 2.5, 0, 6) - math.clamp(math.sin(lerpTime * 180 + 90) * 1.5, -1, 0) - math.clamp(math.sin(lerpTime * 180 + 90) * 2, -4, 0)"
        },
        groundMove = {
          x = "0",
          y = "0",
          z = "-10 - math.clamp(math.sin(lerpTime * 180 + 90 - 180) * 12, 0, 12) - math.clamp(math.sin(lerpTime * 180 + 270) * 1.5, 0, 1) - math.clamp(math.sin(lerpTime * 180 + 270) * 2.5, 0, 6) - math.clamp(math.sin(lerpTime * 180 + 270) * 1.5, -1, 0) - math.clamp(math.sin(lerpTime * 180 + 270) * 2, -4, 0)"
        },
        waterIdle = {
          x = "0",
          y = "0",
          z = "5 + math.clamp(math.sin(lerpTime * 180 + 90) * 1.5, 0, 1) + math.clamp(math.sin(lerpTime * 180 + 90) * 2.5, 0, 6) + math.clamp(math.sin(lerpTime * 180 + 90) * 1.5, -1, 0) + math.clamp(math.sin(lerpTime * 180 + 90) * 2, -4, 0)"
        },
        waterSwim = {
          x = "0",
          y = "0",
          z = "-(-5 + math.clamp(math.sin(lerpTime * 180 + 90) * 1.5, 0, 1) + math.clamp(math.sin(lerpTime * 180 + 45) * 10, 0, 20) + math.clamp(math.sin(lerpTime * 180 + 90) * 1.5, -1, 0) + math.clamp(math.sin(lerpTime * 180 + 90) * 2, -4, 0))"
        },
        underwaterIdle = {
          x = "0",
          y = "0",
          z = "5 - math.clamp(math.sin(lerpTime * 180 + 90) * 1.5, 0, 1) - math.clamp(math.sin(lerpTime * 180 + 90) * 2.5, 0, 6) - math.clamp(math.sin(lerpTime * 180 + 90) * 1.5, -1, 0) - math.clamp(math.sin(lerpTime * 180 + 90) * 2, -4, 0)"
        },
        underwaterSwim = {
          x = "0",
          y = "0",
          z = "-math.clamp(math.sin(lerpTime * 180 - 225) * 5, 0, 200) - math.clamp(math.sin(lerpTime * 180) * 10, 0, 8) + math.clamp(math.sin(lerpTime * 180 - 225) * 25, -20, 15)"
        }
      },
      cur      = 0,
      nextTick = 0,
      target   = 0,
      curPos   = 0
  },
  { part = lapras.Main.FlipperBackLeft,
      rot = {
        groundIdle = {
          x = "0",
          y = "-10",
          z = "-12.5 - math.sin(lerpTime * 180 / 3 + 90) * 2"
        },
        groundMove = {
          x = "0",
          y = "-10 - math.clamp(math.sin(lerpTime * 180 + 290) * 35, 0, 30) - math.clamp(math.sin(lerpTime * 180 + 290) * 30, -15, 0) - math.clamp(math.sin(lerpTime * 180 + 90 - 190) * 25, -20, 0)",
          z = "-5 + math.clamp(math.sin(lerpTime * 180 - 380) * 8, 0, 5) + math.clamp(math.sin(lerpTime * 180 - 380) * 10, -20, 0)"
        },
        waterIdle = {
          x = "math.clamp(math.sin(lerpTime * 180) * 2, 0, 2) + math.clamp(math.sin(lerpTime * 180) * 2, -2, 0)",
          y = "math.clamp(math.sin(lerpTime * 180) * 1.5, 0, 1) + math.clamp(math.sin(lerpTime * 180) * 2.5, 0, 6) + math.clamp(math.sin(lerpTime * 180) * 1.5, -1, 0) + math.clamp(math.sin(lerpTime * 180) * 2, -4, -0) - 10",
          z = "-10 - math.sin(lerpTime * 180 / 3 + 90) * 6"
        },
        waterSwim = {
          x = "math.clamp(math.sin(lerpTime * 90) * 2, 0, 10) - math.clamp(math.sin(lerpTime * 90) * 2, -10, 0) - math.clamp(math.sin(lerpTime * 180) * 5, -10, 0)",
          y = "math.clamp(math.sin(lerpTime * 180 - 115) * 4, 0, 5) + math.clamp(math.sin(lerpTime * 180 - 135) * 8, -2, 8) + math.clamp(math.sin(lerpTime * 180 - 120) * 15 / 2, -15, 0) + math.clamp(math.sin(lerpTime * 180 - 90) * 5, -10, 0) - 10",
          z = "-math.clamp(math.sin(lerpTime * 180 - 45) * 5, 0, 10) - math.clamp(math.sin(lerpTime * 180 - 45) * 15, -20, 0) - 5"
        },
        underwaterIdle = {
          x = "math.clamp(math.sin(lerpTime * 180) * 2, 0, 2) + math.clamp(math.sin(lerpTime * 180) * 2, -2, 0)",
          y = "math.clamp(math.sin(lerpTime * 180) * 1.5, 0, 1) + math.clamp(math.sin(lerpTime * 180) * 2.5, 0, 6) + math.clamp(math.sin(lerpTime * 180) * 1.5, -1, 0) + math.clamp(math.sin(lerpTime * 180) * 2, -4, 0) + 10",
          z = "-10 - math.sin(lerpTime * 180 / 3 + 90) * 6"
        },
        underwaterSwim = {
          x = "math.clamp(math.sin(lerpTime * 90 + 180) * 8, 0, 10) - math.clamp(math.sin(lerpTime * 90 + 180) * 8, -10, 0) + math.clamp(math.sin(lerpTime * 180 + 180) * 4, -10, 0)",
          y = "-10 + math.clamp(math.sin(lerpTime * 180 + 225) * 10, 10, 20) - math.clamp(math.sin(lerpTime * 90) * 15, 0, 20) - math.clamp(math.sin(lerpTime * 90 + 180) * 15, 0, 20)",
          z = "-math.clamp(math.sin(lerpTime * 180 - 190) * 40, 0, 200) + math.clamp(math.sin(lerpTime * 180 + 20) * 40, -10, 40) - math.clamp(math.sin(lerpTime * 180 + 180) * 35, -40, 0)"
        }
      },
      cur      = 0,
      nextTick = 0,
      target   = 0,
      curPos   = 0
  },
  { part = lapras.Main.FlipperBackLeft.FlipperBackLeft,
      rot = {
        groundIdle = {
          x = "0",
          y = "0",
          z = "12.5 + math.clamp(math.sin(lerpTime * 180 + 90) * 1.5, 0, 1) + math.clamp(math.sin(lerpTime * 180 + 90) * 2.5, 0, 6) + math.clamp(math.sin(lerpTime * 180 + 90) * 1.5, -1, 0) + math.clamp(math.sin(lerpTime * 180 + 90) * 2, -4, 0)"
        },
        groundMove = {
          x = "0",
          y = "0",
          z = "10 + math.clamp(math.sin(lerpTime * 180 + 90 - 180) * 12, 0, 12) + math.clamp(math.sin(lerpTime * 180 + 270) * 1.5, 0, 1) + math.clamp(math.sin(lerpTime * 180 + 270) * 2.5, 0, 6) + math.clamp(math.sin(lerpTime * 180 + 270) * 1.5, -1, 0) + math.clamp(math.sin(lerpTime * 180 + 270) * 2, -4, 0)"
        },
        waterIdle = {
          x = "0",
          y = "0",
          z = "-5 + math.clamp(math.sin(lerpTime * 180 + 90) * 1.5, 0, 1) + math.clamp(math.sin(lerpTime * 180 + 90) * 2.5, 0, 6) + math.clamp(math.sin(lerpTime * 180 + 90) * 1.5, -1, 0) + math.clamp(math.sin(lerpTime * 180 + 90) * 2, -4, 0)"
        },
        waterSwim = {
          x = "0",
          y = "0",
          z = "-5 + math.clamp(math.sin(lerpTime * 180 + 90) * 1.5, 0, 1) + math.clamp(math.sin(lerpTime * 180 + 45) * 10, 0, 20) + math.clamp(math.sin(lerpTime * 180 + 90) * 1.5, -1, 0) + math.clamp(math.sin(lerpTime * 180 + 90) * 2, -4, 0)"
        },
        underwaterIdle = {
          x = "0",
          y = "0",
          z = "-5 + math.clamp(math.sin(lerpTime * 180 + 90) * 1.5, 0, 1) + math.clamp(math.sin(lerpTime * 180 + 90) * 2.5, 0, 6) + math.clamp(math.sin(lerpTime * 180 + 90) * 1.5, -1, 0) + math.clamp(math.sin(lerpTime * 180 + 90) * 2, -4, 0)"
        },
        underwaterSwim = {
          x = "0",
          y = "0",
          z = "math.clamp(math.sin(lerpTime * 180 - 225) * 5, 0, 200) + math.clamp(math.sin(lerpTime * 180) * 10, 0, 8) - math.clamp(math.sin(lerpTime * 180 - 225) * 25, -20, 15)"
        }
      },
      cur      = 0,
      nextTick = 0,
      target   = 0,
      curPos   = 0
  },
  { part = lapras.Main.Tail,
      rot = {
        groundIdle = {
          x = "-5 + 2 * (math.clamp(math.sin(lerpTime * 180 - 25), 0, 2) + math.clamp(math.sin(lerpTime * 180 - 25), -2, 0) + 2 * (math.sin(lerpTime * 180)) + 2 * (math.sin(lerpTime * 180 / 3)))",
          y = "0",
          z = "0"
        },
        groundMove = {
          x = "2 * (math.clamp(math.sin(lerpTime * 180 - 60), 0, 2) + math.clamp(math.sin(lerpTime * 180 - 60), -2, 0) + 2 * (math.sin(lerpTime * 180 - 60)) + 2 * (math.sin(lerpTime * 180 - 60)))",
          y = "0",
          z = "0"
        },
        waterIdle = {
          x = "5 + 2 * (math.clamp(math.sin(lerpTime * 180 - 25), 0, 2) + math.clamp(math.sin(lerpTime * 180 - 25), -2, 0) + 2 * (math.sin(lerpTime * 180)) + 2 * (math.sin(lerpTime * 180 / 3)))",
          y = "0",
          z = "0"
        },
        waterSwim = {
          x = "2 * (math.clamp(math.sin(lerpTime * 180 + 45), 0, 2) + math.clamp(math.sin(lerpTime * 180 + 45), -2, 0) + 2 * (math.sin(lerpTime * 180 + 45)) + 2 * (math.sin(lerpTime * 180 / 3 + 45)))",
          y = "0",
          z = "0"
        },
        underwaterIdle = {
          x = "2 * (math.clamp(math.sin(lerpTime * 180 - 25), 0, 2) + math.clamp(math.sin(lerpTime * 180 - 25), -2, 0) + 2 * (math.sin(lerpTime * 180)) + 2 * (math.sin(lerpTime * 180 / 3)))",
          y = "0",
          z = "0"
        },
        underwaterSwim = {
          x = "-10 - math.clamp(math.sin(lerpTime * 180 - 75) * 10, 0, 30) - math.clamp(math.sin(lerpTime * 180 - 75) * 20, -50, 0)",
          y = "0",
          z = "0"
        }
      },
      cur      = 0,
      nextTick = 0,
      target   = 0,
      curPos   = 0
  },
  { part = lapras.Main.Tail.Tail,
      rot = {
        groundIdle = {
          x = "5 - 2 * (math.clamp(math.sin(lerpTime * 180 + 45), 0, 2) + math.clamp(math.sin(lerpTime * 180 + 45), -2, 0) + 2 * (math.sin(lerpTime * 180 + 45)) + 2 * (math.sin(lerpTime * 180 / 3 + 45)))",
          y = "0",
          z = "0"
        },
        groundMove = {
          x = "-2 * (math.clamp(math.sin(lerpTime * 180 + 45), 0, 2) + math.clamp(math.sin(lerpTime * 180 + 45), -2, 0) + 2 * (math.sin(lerpTime * 180 + 45)) + 2 * (math.sin(lerpTime * 180 + 45)))",
          y = "0",
          z = "0"
        },
        waterIdle = {
          x = "2 * (math.clamp(math.sin(lerpTime * 180 - 25), 0, 2) + math.clamp(math.sin(lerpTime * 180 - 25), -2, 0) + 2 * (math.sin(lerpTime * 180)) + 2 * (math.sin(lerpTime * 180 / 3)))",
          y = "0",
          z = "0"
        },
        waterSwim = {
          x = "-2 * (math.clamp(math.sin(lerpTime * 180 + 45), 0, 2) + math.clamp(math.sin(lerpTime * 180 + 45), -2, 0) + 2 * (math.sin(lerpTime * 180 + 45)) + 2 * (math.sin(lerpTime * 180 / 3 + 45)))",
          y = "0",
          z = "0"
        },
        underwaterIdle = {
          x = "-2 * (math.clamp(math.sin(lerpTime * 180 + 45), 0, 2) + math.clamp(math.sin(lerpTime * 180 + 45), -2, 0) + 2 * (math.sin(lerpTime * 180 + 45)) + 2 * (math.sin(lerpTime * 180 / 3 + 45)))",
          y = "0",
          z = "0"
        },
        underwaterSwim = {
          x = "-math.clamp(math.sin(lerpTime * 180 + 180) * 10, 0, 30) - math.clamp(math.sin(lerpTime * 180 + 180) * 20, -50, 0)",
          y = "0",
          z = "0"
        }
      },
      cur      = 0,
      nextTick = 0,
      target   = 0,
      curPos   = 0
  }
}

-- Position animations
local posParts = {
  { part = modelRoot,
      pos = {
        groundIdle = { x = "0", y = "0", z = "0" },
        groundMove = {
          x = "0",
          y = " 0.5 * (-math.clamp(math.sin(lerpTime * 180 + 145) * 0.6, 0, 0.6) - math.clamp(math.sin(lerpTime * 180 + 125) * 0.5, 0, 0.2) - math.clamp(math.sin(lerpTime * 180 + 125) * 0.5, -0.3, 0) - math.clamp(math.sin(lerpTime * 180 + 145) * 0.2, -0.5, 0)) + 0.35",
          z = "10 + 5 * (-1 - 1 + math.clamp(math.sin(lerpTime * 180 - 270), -0.25, 1))"
        },
        waterIdle = {
          x = "0",
          y = "-math.clamp(math.sin(lerpTime * 180 - 45) * 0.25, 0, 5) - math.clamp(math.sin(lerpTime * 180 - 45) * 0.5, -3, 0) - 0.5",
          z = "0"
        },
        waterSwim = {
          x = "0",
          y = "-math.clamp(math.sin(lerpTime * 180 - 45) * 0.25, 0, 5) - math.clamp(math.sin(lerpTime * 180 - 45) * 0.5, -3, 0) - 0.5",
          z = "-math.clamp(math.sin(lerpTime * 180 - 45), 0, 5) - math.clamp(math.sin(lerpTime * 180 - 45), -3, 0)"
        },
        underwaterIdle = {
          x = "0",
          y = "math.clamp(-math.sin(lerpTime * 180 + 45) * 0.2, -50, 0) + math.clamp(-math.sin(lerpTime * 180 + 45) * 0.2, 0, 5)",
          z = "0"
        },
        underwaterSwim = {
          x = "0", 
          y = "math.clamp(-math.sin(lerpTime * 180 + 45) * 0.5, -50, 0) + math.clamp(-math.sin(lerpTime * 180 + 45) * 0.5, 0, 5)",
          z = "math.clamp(math.sin(lerpTime * 180) * 2, 0, 5) + math.clamp(math.sin(lerpTime * 180) * 2, -3, 0)"
        }
      },
      cur      = 0,
      nextTick = 0,
      target   = 0,
      curPos   = 0
  },
}

-- Variables
local vel     = vec(0, 0, 0)
local time    = 0
local _time   = time
local pose    = require("scripts.Posing")
local ticks   = require("scripts.WaterTicks")
local g       = require("scripts.GroundCheck")
local vehicle = require("scripts.Vehicles")
function events.TICK()
  -- Animation timer
  _time   = time
  vel     = player:getVelocity()
  
  -- Animation speed/direction control
  local speed = vel:dot((player:getLookDir().x_z):normalize())
  time = time + ((math.clamp(speed, -0.25, 0.25) * 0.01 * (vehicle.minecart and 0 or 1 )) + ((speed == 0) and 0.001 or 0))
  
  -- Rotation Tick Lerp
  for _, part in ipairs(rotParts) do
    part.cur      = part.nextTick
    part.nextTick = math.lerp(part.nextTick, part.target, 0.5)
  end
  
  -- Position Tick Lerp
  for _, part in ipairs(posParts) do
    part.cur      = part.nextTick
    part.nextTick = math.lerp(part.nextTick, part.target, 0.5)
  end
  
end

function events.RENDER(delta, context)
  if context == "RENDER" or context == "FIRST_PERSON" then
    -- Animation modifiers
    local moving     = vel.zx:length() ~= 0
    local inWater    = ticks.water      < 20
    local underwater = ticks.under      < 20
    
    -- Animation states
    local groundIdleState     = not moving and (not inWater or g.ground) and not vehicle.vehicle
    local groundMoveState     =     moving and (not inWater or g.ground) and not pose.elytra and not (pose.swim and inWater) and not vehicle.vehicle
    local waterIdleState      = not moving and inWater
    local waterSwimState      =     moving and inWater
    local underwaterIdleState = not moving and underwater
    local underwaterSwimState = vel:length() ~= 0 and underwater
    
    local animState = groundMoveState and "groundMove" or groundIdleState and "groundIdle" or underwaterSwimState and "underwaterSwim" or underwaterIdleState and "underwaterIdle" or waterSwimState and "waterSwim" or "waterIdle"
    
    -- Lerp animation timer
    lerpTime = math.lerp(_time, time, delta)
    
    -- Rotation animation
    for _, part in ipairs(rotParts) do
      -- Target rotation
      part.target = vec(load("return " .. part.rot[animState].x)(), load("return " .. part.rot[animState].y)(), load("return " .. part.rot[animState].z)())
      
      if _ == 1 then -- Modify first index
        part.target = part.target + ((pose.crawl or pose.spin) and vec(90, 0, 0) or (pose.swim or pose.elytra) and vec(80, 0, 0) or pose.sleep and vec(70, 0, 0) or 0)
      end
      
      -- Actual rotation
      part.curPos = math.lerp(part.cur, part.nextTick, delta)
      part.part:setRot(part.curPos)
    end
    
    -- Position animation
    for _, part in ipairs(posParts) do
      -- Target position
      part.target = vec(load("return " .. part.pos[animState].x)(), load("return " .. part.pos[animState].y)(), load("return " .. part.pos[animState].z)())
      
      if _ == 1 then -- Modify first index
        part.target = not pose.spin and ((pose.swim or pose.crawl) and part.target.xzy or part.target) or 0
        part.target = part.target + (pose.crouch and vec(0, 2, 0) or (pose.crawl or pose.elytra) and vec(0, 0, 33) or pose.sleep and vec(0, 0, 15) or pose.spin and vec(0, 0, 22) or pose.swim and vec(0, 10, 25) or vehicle.hasPassenger and vec(0, -9, 10) or 0)
      end
      
      -- Actual position
      part.curPos = math.lerp(part.cur, part.nextTick, delta)
      part.part:setPos(part.curPos)
    end
    
    -- Misc animations
    local crouch = player:isCrouching()
    lapras:setPos(pose.crawl and vec(0, 1, -1) or crouch and vec(0, 0, pose.elytra and 4 or 5) or 0)
  end
end

-- Dynamic rotations
do
  -- Variables
  local pitchCurrent, pitchNextTick, pitchTarget, pitchCurrentPos = 0,0,0,0
  local yawCurrent,   yawNextTick,   yawTarget,   yawCurrentPos   = 0,0,0,0
  local rollCurrent,  rollNextTick,  rollTarget,  rollCurrentPos  = 0,0,0,0
  
  -- Gradual values
  function events.TICK()
    pitchCurrent, yawCurrent, rollCurrent    = pitchNextTick, yawNextTick, rollNextTick
    pitchNextTick, yawNextTick, rollNextTick = math.lerp(pitchNextTick, pitchTarget, 0.75), math.lerp(yawNextTick, yawTarget, 0.25), math.lerp(rollNextTick, rollTarget, 0.35)
  end
  
  -- Pitch rotations parts
  local pitchParts = {
    lapras.Main,
  }
  
  -- Yaw rotations parts
  local yawParts = {
    modelRoot.UpperBody,
    lapras.Front,
  }
  
  -- Roll rotation parts
  local rollParts = {
    { part = lapras.Main.FlipperFrontRight,                   mult = 2.5  },
    { part = lapras.Main.FlipperFrontLeft,                    mult = -2.5 },
    { part = lapras.Main.FlipperBackRight,                    mult = 2.5  },
    { part = lapras.Main.FlipperBackLeft,                     mult = -2.5 },
    { part = lapras.Main.FlipperFrontRight.FlipperFrontRight, mult = 1    },
    { part = lapras.Main.FlipperFrontLeft.FlipperFrontLeft,   mult = -1   },
    { part = lapras.Main.FlipperBackRight.FlipperBackRight,   mult = 1    },
    { part = lapras.Main.FlipperBackLeft.FlipperBackLeft,     mult = -1   }
  }
  
  local pitchLimit = 20
  local yawLimit   = 26
  local rollLimit  = 20
  function events.RENDER(delta, context)
    if context == "RENDER" or context == "FIRST_PERSON" then
      local pitchShouldRot = not vehicle.vehicle and not pose.spin and not player:isClimbing() and not pose.elytra
      local yawShouldRot   = pose.stand
      local rollShouldRot  = ticks.water >= 20
      
      pitchTarget     = pitchShouldRot and math.clamp(vel.y * 70, -pitchLimit, pitchLimit) or 0
      pitchCurrentPos = math.lerp(pitchCurrent, pitchNextTick, delta)
      
      yawTarget       = yawShouldRot and math.clamp(vanilla_model.HEAD:getOriginRot(delta).y, -yawLimit, yawLimit) or 0
      yawCurrentPos   = math.lerp(yawCurrent, yawNextTick, delta)
      
      rollTarget      = pose.sleep and -18 or rollShouldRot and math.clamp(vel.y * 70, -rollLimit, rollLimit) or 0
      rollCurrentPos  = math.lerp(rollCurrent, rollNextTick, delta)
      
      -- Pitch Rotations
      for _, part in ipairs(pitchParts) do
        part:setOffsetRot(pitchCurrentPos, 0, 0)
      end
      
      -- Yaw rotations
      for _, part in ipairs(yawParts) do
        part:setOffsetRot(0, yawCurrentPos, 0)
      end
      
      -- Roll rotations
      for _, part in ipairs(rollParts) do
        part.part:setOffsetRot(0, 0, rollCurrentPos * part.mult)
      end
    end
  end
end

-- Breathing control
do
  local speed = 0
  local lastSpeed = 0
  function events.TICK()
    lastSpeed = speed
    speed = speed + math.clamp((vel:length() * 15 + 1) * 0.05, 0, 0.4)
  end
  
  function events.RENDER(delta, context)
    if context == "RENDER" or context == "FIRST_PERSON" then
      local scale = math.sin(math.lerp(lastSpeed, speed, delta)) * 0.0125 + 1.0125
      lapras.Front.Front:setScale(scale)
    end
  end
end

-- Parrot control
do
  local parts = {
    lapras.Main.LeftParrotPivot,
    lapras.Main.RightParrotPivot,
  }
  
  function events.RENDER(delta, context)
    if context == "RENDER" or context == "FIRST_PERSON" then
      for _, parrot in pairs(parts) do
        parrot:setRot(-lapras.Main:getOffsetRot().x__ + -lapras:getRot().x__)
      end
    end
  end
end

-- Fixing spyglass jank
function events.RENDER(delta, context)
  if context == "RENDER" or context == "FIRST_PERSON" then
    local rot = vanilla_model.HEAD:getOriginRot()
    rot.x = math.clamp(rot.x, -90, 30)
    modelRoot.UpperBody.Spyglass:setRot(rot)
  end
end