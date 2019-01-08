module McgAgainst.Scenes.History exposing (init, subscriptions, view, update)

import Html exposing (Html)
import McgAgainst.API as API
import McgAgainst.API.Request as Request
import McgAgainst.Scenes.History.Messages exposing (Message(..), ConsumerMessage(..))
import McgAgainst.Scenes.History.Models exposing (Model)
import McgAgainst.Scenes.History.UI as UI
import McgAgainst.Models.Player as Player exposing (Player)


init : String -> ( Model, Cmd ConsumerMessage )
init gameCode =
    ( { rounds = Nothing
      }
    , Request.send_ (API.getHistory gameCode) ErrorMessage (LocalMessage << Load)
    )


{-| Subscriptions for the playing scene.
-}
subscriptions : Model -> Sub ConsumerMessage
subscriptions model =
    Sub.none


{-| Render the history.
-}
view : Model -> List Player -> Html ConsumerMessage
view =
    UI.view


{-| Update the model.
-}
update : Message -> Model -> ( Model, Cmd ConsumerMessage )
update message model =
    case message of
        Load rounds ->
            ( { model | rounds = Just rounds }, Cmd.none )
