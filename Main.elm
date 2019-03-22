module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (id)
import AFrame exposing (..)
import AFrame.Primitives exposing (..)
import AFrame.Primitives.Attributes exposing (..)
import ModelLoader exposing (..)
import AnimationFrame exposing (..)
import Time exposing (..)


type alias Model =
    { time : Time, positx : Float, posity : Float, direct : Int }


type Msg
    = TimeUpdate Time
    | Increment
    | Decrement
    | Stay
    | Jump

models : List String
models =
    List.map (\n -> ("T-Rex-0" ++ (toString n) ++ ".ply")) (List.range 0 7)


init : ( Model, Cmd Msg )
init =
    ( { time = 0, positx = 0, posity = -2, direct = 0 }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TimeUpdate diff ->
            { model | time = model.time 
                    } ! []
        Increment ->
            { model | positx = model.positx + 1
                    , direct = 0
                    , time = model.time + 100
                    } ! []
        Decrement ->
            { model | positx = model.positx - 1
                    , direct = 180
                    , time = model.time + 100
                    } ! []
        Stay ->
            { model | direct = model.direct 
                    , time = model.time + 100
                    } ! []
        Jump ->
            { model | posity = model.posity * -1 
                    , time = model.time + 1000
                    } ! []


subscriptions : Model -> Sub Msg
subscriptions model =
    AnimationFrame.diffs TimeUpdate


getModelSource : Model -> String
getModelSource model =
    let
        fps =
            6

        frames =
            List.length models

        time =
            round (model.time / second * fps)

        indexToTake =
            rem time frames
    in
        "dino" ++ (toString indexToTake)


getModels : List (Html Msg)
getModels =
    List.map2
        (\n f -> assetItem [ src f, id ("dino" ++ (toString n)) ] [])
        (List.range 0 (List.length models))
        models


view : Model -> Html Msg
view model =
    let
        modelsrc =
            "src: #" ++ (getModelSource model)
    in
        div []
            [ div []
                  [ button [ onClick Decrement ] [ text "Move-Left" ]
                  , button [ onClick Increment ] [ text "Move-Right" ]
                  , button [ onClick Stay ] [ text "Stay" ]
                  , button [ onClick Jump ] [ text "Jump" ]
                  ]
              ,scene []
                  [ assets [] ([] ++ getModels)
                  , entity
                    [ plymodel modelsrc
                    , scale 0.5 0.5 0.5
                    , position model.positx model.posity -13
                    , rotation -90 model.direct 0
                    ]
                    []
                  ]
            ]

main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , subscriptions = subscriptions
        , update = update
        }
