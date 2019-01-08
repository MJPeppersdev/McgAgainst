module McgAgainst.Scenes.History.Messages exposing (..)

import McgAgainst.Components.Errors as Errors
import McgAgainst.Models.Game.Round as Round


{-| This type is used for all sending of messages, allowing us to send messages handled outside this scene.
-}
type ConsumerMessage
    = ErrorMessage Errors.Message
    | Close
    | LocalMessage Message


{-| The messages used in the history scene.
-}
type Message
    = Load (List Round.FinishedRound)
