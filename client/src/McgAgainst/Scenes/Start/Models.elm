module McgAgainst.Scenes.Start.Models exposing (..)

import McgAgainst.Models exposing (Init, Path)
import McgAgainst.Scenes.Lobby.Models as Lobby
import McgAgainst.Components.Tabs as Tabs
import McgAgainst.Components.Input as Input
import McgAgainst.Components.Errors as Errors
import McgAgainst.Components.Overlay as Overlay
import McgAgainst.Components.Storage as Storage
import McgAgainst.Scenes.Start.Messages exposing (Message, InputId, Tab)


{-| The state of the start screen.
-}
type alias Model =
    { lobby : Maybe Lobby.Model
    , init : Init
    , path : Path
    , nameInput : Input.Model InputId Message
    , gameCodeInput : Input.Model InputId Message
    , passwordInput : Input.Model InputId Message
    , passwordRequired : Maybe String
    , errors : Errors.Model
    , overlay : Overlay.Model Message
    , buttonsEnabled : Bool
    , tabs : Tabs.Model Tab Message
    , storage : Storage.Model
    }
