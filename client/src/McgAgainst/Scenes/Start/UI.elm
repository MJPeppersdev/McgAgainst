module McgAgainst.Scenes.Start.UI exposing (view, alreadyInGameOverlay)

import String
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Keyed as Keyed
import McgAgainst.Models.Game as Game
import McgAgainst.Components.Tabs as Tabs
import McgAgainst.Components.Icon as Icon
import McgAgainst.Components.About as About
import McgAgainst.Components.Input as Input
import McgAgainst.Components.Overlay as Overlay exposing (Overlay)
import McgAgainst.Scenes.Start.Models exposing (Model)
import McgAgainst.Scenes.Start.Messages exposing (Message(..), Tab(..))
import McgAgainst.Scenes.Lobby.Messages as Lobby


alreadyInGameOverlay : Overlay Message
alreadyInGameOverlay =
    Overlay
        "info-circle"
        "Already in game."
        [ p [] [ text "You are already in this game, so you have joined as an existing player." ]
        , p []
            [ text "If you want to join as a new player, please "
            , a
                [ class "link"
                , title "Leave the game."
                , attribute "tabindex" "0"
                , attribute "role" "button"
                , onClick
                    (Batch
                        [ Lobby.Leave |> LobbyMessage
                        , Overlay.Hide |> OverlayMessage
                        ]
                    )
                ]
                [ text "leave the game" ]
            , text " first."
            ]
        ]


{-| Render the start screen.
-}
view : Model -> Html Message
view model =
    let
        nameEntered =
            not (String.isEmpty model.nameInput.value)

        gameCodeEntered =
            not (String.isEmpty model.gameCodeInput.value)

        versionInfo =
            if String.isEmpty model.init.version then
                []
            else
                [ text " Version ", text model.init.version ]
    in
        div [ id "start-screen" ]
            [ div [ id "start-screen-content", class "mui-panel" ]
                ([ h1 [ class "mui--divider-bottom" ] [ text "Massive Decks" ]
                 ]
                    ++ (existingGames model.storage)
                    ++ [ Input.view model.nameInput
                       ]
                    ++ (Tabs.view (renderTab nameEntered gameCodeEntered model) model.tabs)
                    ++ [ a
                            [ class "about-link mui--divider-top link"
                            , attribute "tabindex" "0"
                            , attribute "role" "button"
                            , onClick (About.show model.init.version |> OverlayMessage)
                            ]
                            [ Icon.icon "question-circle", text " About" ]
                       , div [ id "forkongithub" ]
                            [ div []
                                [ a [ href "https://github.com/McGdevfunk824/McgAgainst", target "_blank", rel "noopener" ]
                                    [ Icon.icon "github", text " Fork me on GitHub" ]
                                ]
                            ]
                       ]
                )
            , footer []
                [ a [ href "https://github.com/McGdevfunk824/McgAgainst" ]
                    [ img [ src "images/icon.svg", alt "McG logo.", title "McG Against" ] [] ]
                , p [] versionInfo
                ]
            ]


renderTab : Bool -> Bool -> Model -> Tab -> List (Html Message)
renderTab nameEntered gameCodeEntered model tab =
    case tab of
        Create ->
            [ createLobbyButton (nameEntered && model.buttonsEnabled) ]

        Join ->
            List.concat
                [ [ Input.view model.gameCodeInput
                  ]
                , (if model.passwordRequired == (Just model.gameCodeInput.value) then
                    [ Input.view model.passwordInput ]
                   else
                    []
                  )
                , [ joinLobbyButton (nameEntered && gameCodeEntered && model.buttonsEnabled)
                  ]
                ]


existingGames : List Game.GameCodeAndSecret -> List (Html msg)
existingGames games =
    if List.isEmpty games then
        []
    else
        [ div [ class "rejoin mui--divider-bottom" ]
            [ span [] [ text "You can rejoin " ]
            , Keyed.ul [] (List.map existingGame games)
            ]
        ]


existingGame : Game.GameCodeAndSecret -> ( String, Html msg )
existingGame game =
    ( game.gameCode, li [] [ a [ href ("#" ++ game.gameCode) ] [ text ("Game \"" ++ game.gameCode ++ "\"") ] ] )


{-| A button to join an existing lobby.
-}
joinLobbyButton : Bool -> Html Message
joinLobbyButton enabled =
    button
        [ class "mui-btn mui-btn--large mui-btn--primary"
        , onClick JoinLobbyAsNewPlayer
        , disabled (not enabled)
        ]
        [ text "Join Game" ]


{-| A button to create a new lobby.
-}
createLobbyButton : Bool -> Html Message
createLobbyButton enabled =
    button
        [ class "mui-btn mui-btn--large mui-btn--primary"
        , onClick CreateLobby
        , disabled (not enabled)
        ]
        [ text "Create Game" ]
