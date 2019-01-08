module McgAgainst.Scenes.History.Models exposing (Model)

import McgAgainst.Models.Game.Round as Round


{-| The state of the lobby.
-}
type alias Model =
    { rounds : Maybe (List Round.FinishedRound)
    }
