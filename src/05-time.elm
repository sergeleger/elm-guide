import Browser
import Time
import Task
import DateFormat
import Html exposing ( Html, h1, text, button, div)
import Html.Events exposing (onClick)
import Debug exposing (log)

-- main

main =
    Browser.element {
        init = init,
        view = view,
        update = update,
        subscriptions = subscriptions
    }


-- Model

type alias Model =
    {
        zone : Time.Zone,
        time : Time.Posix,
        running : Bool
    }

init : () -> (Model, Cmd Msg)
init _ =
    (
        Model Time.utc (Time.millisToPosix 0) True,
        Task.perform AdjustTimeZone Time.here
    )


-- Update

type Msg =
    Tick Time.Posix |
    AdjustTimeZone Time.Zone |
    ToggleRunning


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Tick newTime ->
            (
                { model | time = newTime },
                Cmd.none
            )

        AdjustTimeZone newZone ->
            (
                { model | zone = newZone },
                Cmd.none
            )

        ToggleRunning ->
            (
                { model | running = not model.running },
                Cmd.none
            )

subscriptions : Model -> Sub Msg
subscriptions model =
    if model.running then
        Time.every 1000 Tick
    else
        Sub.none


view : Model -> Html Msg
view model =
    let
        (label) =
            if model.running then "Pause" else "Start"
    in
    div []
        [
            h1 [] [ text <| formatTime model ],
            button [onClick ToggleRunning] [text label]
        ]


formatTime : Model -> String
formatTime tz =
    DateFormat.format
        [
            DateFormat.hourMilitaryFixed,
            DateFormat.text ":",
            DateFormat.minuteFixed,
            DateFormat.text ":",
            DateFormat.secondFixed
        ] tz.zone tz.time
