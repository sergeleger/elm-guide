import Browser
import Html exposing (Html, div, text)
import Json.Decode exposing (Decoder, field, int, string, map2, decodeString, errorToString)
import Debug exposing (log)

main =
    Browser.element
        {
            init = init,
            subscriptions = (\n -> Sub.none),
            view = view,
            update = (\_ model -> (model, Cmd.none))
        }



type alias Model =
    {
        name : String,
        age : Int
    }

init : () -> (Model, Cmd Msg)
init _ =
    let
        obj = decodeString modelDecoder """{"age": 45, "name": "Leger"}"""
    in
    case obj of
        Ok m ->
            (m,Cmd.none)

        Err err ->
            ( Model (errorToString err) 0, Cmd.none )

type Msg = None

view : (Model) -> Html Msg
view model =
    div [] [text <| model.name ++ " is " ++ String.fromInt model.age]



modelDecoder : Decoder Model
modelDecoder =
    map2 Model
        (field "name" string)
        (field "age" int)