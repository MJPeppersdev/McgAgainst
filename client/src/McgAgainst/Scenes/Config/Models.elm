module McgAgainst.Scenes.Config.Models exposing (..)

import McgAgainst.Components.Input as Input
import McgAgainst.Models.Game as Game
import McgAgainst.Scenes.Config.Messages exposing (Message, InputId)


{-| The state of the config screen.
-}
type alias Model =
    { decks : List Game.DeckInfo
    , deckIdInput : Input.Model InputId Message
    , passwordInput : Input.Model InputId Message
    , loadingDecks : List String
    }
