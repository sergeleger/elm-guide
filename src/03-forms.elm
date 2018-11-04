import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import String

main =
    Browser.sandbox { init = init, update = update, view = view }


-- Model

type alias Model = {
        name: String ,
        password: String,
        passwordAgain: String,
        age: String
    }

init : Model
init = Model "" "Abcdefg12" "Abcdefg12" ""


-- Update

type Msg =
    Name String |
    Password String  |
    PasswordAgain String |
    Age String


update: Msg -> Model -> Model
update msg model =
    case msg of
        Name name ->
            { model | name = name }
        Password password ->
            { model | password = password }

        PasswordAgain password ->
            {model | passwordAgain = password }

        Age age ->
            {model | age = age }


view : Model -> Html Msg
view model =
    div []
        [
            viewInput "text" "Name" model.name Name,
            viewInput "password" "Password" model.password Password,
            viewInput "password" "Re-enter Password" model.passwordAgain PasswordAgain,
            viewInput "text" "Age" model.age Age,
            viewValidation model
        ]

viewInput : String -> String -> String  -> (String -> msg) ->  Html msg
viewInput t p v toMsg =
    input [ type_ t, placeholder p, value v, onInput toMsg] []

viewValidation : Model -> Html msg
viewValidation model =
    if model.password /= model.passwordAgain then
        div [ style "color" "red" ] [ text "Passwords do not match!"]
    else if String.length model.password <= 8 then
        div [ style "color" "red" ] [ text "Passwords too short!"]
    else if not ( String.any Char.isDigit model.password ) then
        div [ style "color" "red" ] [ text "Passwords need to have one digit!"]
    else if not ( String.any Char.isUpper model.password ) then
        div [ style "color" "red" ] [ text "Passwords need to have one uppercase letter!"]
    else if not ( String.any Char.isLower model.password ) then
        div [ style "color" "red" ] [ text "Passwords need to have one lowercase letter!"]
    else if String.toInt model.age == Nothing then
        div [ style "color" "red" ] [ text "Age is not a number"]
    else
        div [ style "color" "green" ] [ text "OK"]


