module McgAgainst.Scenes.Start.Messages exposing (..)

import McgAgainst.Models exposing (Path)
import McgAgainst.Components.Input as Input
import McgAgainst.Components.Errors as Errors
import McgAgainst.Components.Tabs as Tabs
import McgAgainst.Components.Overlay as Overlay
import McgAgainst.Components.Storage as Storage
import McgAgainst.Scenes.Lobby.Messages as Lobby
import McgAgainst.Models.Game as Game
import McgAgainst.Models.Player as Player

{- | The messages used in the start screen.
-}
type Message
    = SubmitCurrentTab
    | PathChange Path
    | CreateLobby
    | SetButtonsEnabled Bool
    | JoinLobbyAsNewPlayer
    | JoinGivenLobbyAsNewPlayer String
    | JoinLobbyAsExistingPlayer Player.Secret String
    | StoreCredentialsAndMoveToLobby String Player.Secret
    | MoveToLobby String
    | JoinLobby Player.Secret Game.LobbyAndHand
    | TryExistingGame String
    | ClearExistingGame Game.GameCodeAndSecret
    | InputMessage (Input.Message InputId)
    | LobbyMessage Lobby.ConsumerMessage
    | ErrorMessage Errors.Message
    | OverlayMessage (Overlay.Message Message)
    | TabsMessage (Tabs.Message Tab)
    | StorageMessage Storage.Message
    | SetPasswordRequired
    | Batch (List Message)
    | NoOp

{- | IDs for the inputs to differentiate between them in messages.
-}
type InputId
    = Name
    | GameCode
    | Password

{- | Tabs for the start page.
-}
type Tab
    = Create
    | Join
