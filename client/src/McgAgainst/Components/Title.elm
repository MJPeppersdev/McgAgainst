port module McgAgainst.Components.Title exposing (set)


port title : String -> Cmd msg


set : String -> Cmd msg
set =
    title
