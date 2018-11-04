import Browser
import Html exposing (Html, div, text, h2, img, button, br)
import Html.Events exposing (onClick)
import Html.Attributes exposing( src )
import Http
import Json.Decode as Decode
import Url.Builder as Url

-- Main

main =
    Browser.element
    {
        init = init,
        subscriptions = (\model -> Sub.none),
        update = update,
        view = view
    }


-- Model

type alias Model =
    {
        topic : String,
        url : String
    }

init : () -> (Model, Cmd Msg)
init _ =
    (
        Model "baby" "waiting.gif",
        getRandomGif "baby"
    )

-- Update

type Msg =
    MorePlease |
    NewGif (Result Http.Error String)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        MorePlease -> (model, getRandomGif model.topic)

        NewGif result ->
            case result of
                Ok newUrl -> ({model | url = newUrl }, Cmd.none)
                Err _ -> (model, Cmd.none)


-- View

view : Model -> Html Msg
view model =
    div []
        [
            h2 [] [text model.topic ],
            button [onClick MorePlease] [ text "More Please!" ],
            br [] [],
            img [ src model.url ] []
        ]

-- Http

getRandomGif : String -> Cmd Msg
getRandomGif topic =
    Http.send NewGif (Http.get (toGiphyUrl topic) gifDecoder)


toGiphyUrl : String -> String
toGiphyUrl topic =
    Url.crossOrigin "https://api.giphy.com" ["v1", "gifs", "random"]
        [ Url.string "api_key" "dc6zaTOxFJmzC", Url.string "tag" topic]

gifDecoder : Decode.Decoder String
gifDecoder =
    Decode.field "data" (Decode.field "image_url" Decode.string)

