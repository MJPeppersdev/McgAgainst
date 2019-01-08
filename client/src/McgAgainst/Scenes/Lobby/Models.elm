module McgAgainst.Scenes.Lobby.Models exposing (Model)

import McgAgainst.Models exposing (Init)
import McgAgainst.Models.Game as Game
import McgAgainst.Models.Player as Player
import McgAgainst.Models.Card as Card
import McgAgainst.Models.Notification as Notification exposing (Notification)
import McgAgainst.Scenes.Lobby.Sidebar as Sidebar
import McgAgainst.Scenes.Config.Models as Config
import McgAgainst.Scenes.Playing.Models as Playing
import McgAgainst.Components.BrowserNotifications as BrowserNotifications
import McgAgainst.Components.TTS as TTS


{-| The state of the lobby.
-}
type alias Model =
    { lobby : Game.Lobby
    , hand : Card.Hand
    , config : Config.Model
    , playing : Playing.Model
    , browserNotifications : BrowserNotifications.Model
    , secret : Player.Secret
    , init : Init
    , notification : Maybe Notification
    , qrNeedsRendering : Bool
    , sidebar : Sidebar.Model
    , tts : TTS.Model
    }
