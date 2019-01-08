module McgAgainst.Scenes.Playing.HouseRule.Available exposing (houseRules)

import McgAgainst.Scenes.Playing.HouseRule as HouseRule exposing (HouseRule)
import McgAgainst.Scenes.Playing.HouseRule.Reboot as Reboot


houseRules : List HouseRule
houseRules =
    [ Reboot.rule ]
