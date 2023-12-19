local pehkui = client.hasResource("pehkui:icon.png")

if not host:isHost() or not pehkui then return end

local function pehkuiCommands()
  host:sendChatCommand("/scale reset")
    :sendChatCommand("/scale set pehkui:hitbox_width 3.5")
    :sendChatCommand("/scale set pehkui:hitbox_height 1.25")
    :sendChatCommand("/scale set pehkui:eye_height 1.3")
    :sendChatCommand("/scale set pehkui:reach 1.2")
    :sendChatCommand("/scale set pehkui:jump_height 0.5")
    :sendChatCommand("/scale persist set true")
end

-- Return action wheel page
return action_wheel:newAction()
  :title("Using Pehkui?\n\nThis action will input commands to change your models attributes to\nTotal's recommended settings. It will change the following:\n\n- Bigger hitbox\n- Heigher eye level\n- Slightly longer reach (to match camera)\n- Reduced jump height")
  :hoverColor(vectors.hexToRGB("5EB7DD"))
  :item("minecraft:armor_stand")
  :onLeftClick(pehkuiCommands)