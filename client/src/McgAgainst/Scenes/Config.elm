module McgAgainst.Scenes.Config exposing (update, view, init, subscriptions)

import String
import Html exposing (Html)
import McgAgainst.API as API
import McgAgainst.API.Request as Request
import McgAgainst.Components.Input as Input
import McgAgainst.Components.Errors as Errors
import McgAgainst.Scenes.Lobby.Models as Lobby
import McgAgainst.Scenes.Config.Messages exposing (ConsumerMessage(..), Message(..), InputId(..), Deck(..))
import McgAgainst.Scenes.Config.Models exposing (Model)
import McgAgainst.Scenes.Config.UI as UI
import McgAgainst.Models.Game as Game
import McgAgainst.Models.Player as Player
import McgAgainst.Util as Util exposing ((:>))


{-| Create the initial model for the config screen.
-}
init : Game.Lobby -> Player.Secret -> ( Model, Cmd ConsumerMessage )
init lobby secret =
    let
        canChangeConfig =
            lobby.owner == secret.id

        config =
            lobby.config

        setPasswordButton =
            if canChangeConfig then
                UI.setPasswordButton
            else
                (\_ -> [])
    in
        { decks = []
        , deckIdInput = Input.initWithExtra DeckId "input-with-button" UI.deckIdInputLabel "" "Play Code" UI.addDeckButton (Util.cmd AddDeck) InputMessage
        , passwordInput = Input.initWithExtra Password "input-with-button" UI.passwordInputLabel (config.password |> Maybe.withDefault "") "Password" setPasswordButton (Util.cmd SetPassword) InputMessage
        , loadingDecks = []
        }
            ! [ ( Password, Input.SetEnabled canChangeConfig ) |> InputMessage |> LocalMessage |> Util.cmd ]


{-| Subscriptions for the config screen.
-}
subscriptions : Model -> Sub ConsumerMessage
subscriptions model =
    Sub.none


{-| Render the config screen.
-}
view : Lobby.Model -> Html ConsumerMessage
view lobbyModel =
    UI.view lobbyModel |> Html.map LocalMessage


{-| Handles messages and alters the model as appropriate.
-}
update : Message -> Lobby.Model -> ( Model, Cmd ConsumerMessage )
update message lobbyModel =
    let
        lobby =
            lobbyModel.lobby

        gameCode =
            lobbyModel.lobby.gameCode

        secret =
            lobbyModel.secret

        model =
            lobbyModel.config
    in
        case message of
            ConfigureDecks (Request rawDeckId) ->
                let
                    deckId =
                        String.toUpper rawDeckId
                in
                    { model | loadingDecks = model.loadingDecks ++ [ deckId ] }
                        ! [ Request.send (API.addDeck gameCode secret deckId) (addDeckErrorHandler deckId) ErrorMessage (\_ -> (Add deckId) |> ConfigureDecks |> LocalMessage)
                          , inputClearErrorCmd DeckId
                          ]

            AddDeck ->
                ( model, Util.cmd (LocalMessage (ConfigureDecks (Request model.deckIdInput.value))) )

            ConfigureDecks (Add deckId) ->
                ( removeDeckLoadingSpinner deckId model, Cmd.none )

            ConfigureDecks (Fail deckId errorMessage) ->
                ( removeDeckLoadingSpinner deckId model, inputSetErrorCmd DeckId errorMessage )

            InputMessage message ->
                let
                    ( deckIdInput, deckIdMsg ) =
                        Input.update message lobbyModel.config.deckIdInput

                    ( passwordInput, passwordMsg ) =
                        Input.update message lobbyModel.config.passwordInput
                in
                    { model
                        | deckIdInput = deckIdInput
                        , passwordInput = passwordInput
                    }
                        ! [ Cmd.map LocalMessage deckIdMsg, Cmd.map LocalMessage passwordMsg ]

            AddAi ->
                ( model, Request.send_ (API.newAi gameCode secret) ErrorMessage (\_ -> LocalMessage NoOp) )

            StartGame ->
                ( model, Request.send (API.newGame gameCode secret) newGameErrorHandler ErrorMessage HandUpdate )

            EnableRule rule ->
                ( model, Request.send_ (API.enableRule rule gameCode secret) ErrorMessage ignore )

            DisableRule rule ->
                ( model, Request.send_ (API.disableRule rule gameCode secret) ErrorMessage ignore )

            SetPassword ->
                ( model, Request.send_ (API.setPassword gameCode secret model.passwordInput.value) ErrorMessage ignore )

            NoOp ->
                ( model, Cmd.none )


ignore : () -> ConsumerMessage
ignore =
    (\_ -> LocalMessage NoOp)


inputClearErrorCmd : InputId -> Cmd ConsumerMessage
inputClearErrorCmd inputId =
    ( inputId, Nothing |> Input.Error ) |> InputMessage |> LocalMessage |> Util.cmd


inputSetErrorCmd : InputId -> String -> Cmd ConsumerMessage
inputSetErrorCmd inputId error =
    ( inputId, Just error |> Input.Error ) |> InputMessage |> LocalMessage |> Util.cmd


removeDeckLoadingSpinner : String -> Model -> Model
removeDeckLoadingSpinner deckId model =
    { model | loadingDecks = List.filter ((/=) deckId) model.loadingDecks }


addDeckErrorHandler : String -> API.AddDeckError -> ConsumerMessage
addDeckErrorHandler deckId error =
    case error of
        API.CardcastTimeout ->
            ConfigureDecks (Fail deckId "There was a problem accessing CardCast, please try again after a short wait.") |> LocalMessage

        API.DeckNotFound ->
            ConfigureDecks (Fail deckId "The given play code doesn't exist, please check you have the correct code.") |> LocalMessage


newGameErrorHandler : API.NewGameError -> ConsumerMessage
newGameErrorHandler error =
    case error of
        API.GameInProgress ->
            ErrorMessage <| Errors.New "Can't start the game - it is already in progress." False

        API.NotEnoughPlayers required ->
            ErrorMessage <| Errors.New ("Can't start the game - you need at least " ++ (toString required) ++ " players to start the game.") False
