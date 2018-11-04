import Browser
import Browser.Navigation as Nav
import Url
import Html exposing (Html, b, ul, li, text, a)
import Html.Attributes exposing (href)


-- MAIN

main : Program () Model Msg
main =
    Browser.application {
        init = init,
        subscriptions = (\model -> (Sub.none)),
        view = view,
        update = update,
        onUrlChange = UrlChanged,
        onUrlRequest = LinkClicked
    }


-- Model

type alias Model = { key : Nav.Key, url: Url.Url }

init : () -> Url.Url -> Nav.Key -> (Model, Cmd Msg)
init flags url key =
    ( Model key url, Cmd.none)

-- Update

type Msg =
    UrlChanged Url.Url |
    LinkClicked Browser.UrlRequest

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    (model, Nav.pushUrl model.key (Url.toString url))
                Browser.External href ->
                    (model, Nav.load href)

        UrlChanged url ->
            let _ = Debug.log "Allo" model in
            ( {model | url = url }, Cmd.none )



-- View

view : Model -> Browser.Document Msg
view model =
    {
        title = "URL Interceptor",
        body =
            [
                text "The current URL is: ",
                b [] [text (Url.toString model.url) ],
                ul [] [
                    viewLink "/home",
                    viewLink "/profile",
                    viewLink "/reviews/the-century-of-the-self",
                    viewLink "/reviews/public-opinion",
                    viewLink "/reviews/shah-of-shahs"
                ]
            ]
    }


viewLink : String -> Html msg
viewLink path =
    li [] [a [href path] [text path] ]
