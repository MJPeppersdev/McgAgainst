module McgAgainst.Scenes.Lobby.Messages exposing (..)

import McgAgainst.Models.Game as Game
import McgAgainst.Models.Card as Card
import McgAgainst.Models.Player as Player exposing (Player)
import McgAgainst.Models.Notification as Notification exposing (Notification)
import McgAgainst.Scenes.Lobby.Sidebar as Sidebar
import McgAgainst.Scenes.Config.Messages as Config
import McgAgainst.Scenes.Playing.Messages as Playing
import McgAgainst.Components.Errors as Errors
import McgAgainst.Components.Overlay as Overlay
import McgAgainst.Components.BrowserNotifications as BrowserNotifications
import McgAgainst.Components.TTS as TTS

{- | This type is used for all sending of messages, allowing us to send messages handled outside this scene.
-}
type ConsumerMessage
    = ErrorMessage Errors.Message
    | OverlayMessage (Overlay.Message Message)
    | Leave
    | LocalMessage Message

{-| The messages used in the start screen.
-}
type Message
    = DismissNotification Notification
    | SetNotification (List Player -> Maybe Notification)
    | UpdateLobbyAndHand Game.LobbyAndHand
    | UpdateLobby (Game.Lobby -> Game.Lobby)
    | UpdateHand Card.Hand
    | Identify
    | DisplayInviteOverlay
    | BrowserNotificationForUser (Game.Lobby -> Maybe Player.Id) String String
    | RenderQr
    | Batch (List Message)
    | NoOp
    | BrowserNotificationsMessage BrowserNotifications.Message
    | ConfigMessage Config.ConsumerMessage
    | PlayingMessage Playing.ConsumerMessage
    | SidebarMessage Sidebar.Message
    | TTSMessage TTS.Message
