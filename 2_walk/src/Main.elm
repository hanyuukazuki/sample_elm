module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (id, style)
import AFrame exposing (..)
import AFrame.Primitives exposing (..)
import AFrame.Primitives.Attributes exposing (..)
import ModelLoader exposing (..)
import AnimationFrame exposing (..)
import Time exposing (..)
import AFrame.Extra.Physics exposing (grid, staticBody)
import AFrame.Primitives.Camera exposing (camera, wasdControlsEnabled)
import Process exposing (..)
import Task exposing (..)

type alias Model =
    { time : Time, positx : Float, posity : Float, positz : Float, direct : Int, cameray : Float }


type Msg
    = TimeUpdate Time
    | Increment
    | Decrement
    | Turn
    | Jump
    | Jumped
    | Front
    | Back
    | Reset

models : List String
models =
    List.map (\n -> ("T-Rex-0" ++ (toString n) ++ ".ply")) (List.range 0 7)

init : ( Model, Cmd Msg )
init =
    ( { time = 0, positx = 0, posity = -2, positz = 2, direct = 0, cameray = -2 }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TimeUpdate diff ->
            { model | posity = if model.posity > -2 then model.posity - 0.1 else model.posity
                    } ! []
        Increment ->
            { model | positx = if model.direct == 0 then model.positx + 1
                               else if model.direct == 180 then model.positx - 1
                               else model.positx 
                    , positz = if model.direct == 270 then model.positz + 1
                               else if model.direct == 90 then model.positz - 1
                               else model.positz
                    , time =   model.time + 500
                    } ! []
        Decrement ->
            { model | positx = if model.direct == 0 then model.positx - 1
                               else if model.direct == 180 then model.positx + 1
                               else model.positx
                    , positz = if model.direct == 270 then model.positz - 1
                               else if model.direct == 90 then model.positz + 1
                               else model.positz
                    , time = model.time + 500
                    } ! []
        Front ->
            { model | positz = model.positz + 1
                    , direct = 270
                    , time = model.time + 500
                    } ! []
        Back ->
            { model | positz = model.positz - 1
                    , direct = 90
                    , time = model.time + 500
                    } ! []
        Turn ->
            { model | direct = if model.direct == 270 then 0
                      else model.direct + 90 
                    , time = model.time + 500
                    } ! []
        Jump ->
            { model | posity = 0.01
                    , time = model.time + 1000
                    } ! []
        Reset ->
            { model | time = 0
                    , positx = 0
                    , posity = -2
                    , positz = 2
                    , direct = 0
                    } ! []
        Jumped ->
            { model | posity = model.posity * -1
                    , cameray = model.cameray * model.posity / -model.posity
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
                  [ button [ style [("background-color", "#86f442")]
                        , style [ ("padding", "10px")]
                        , style [ ("border-radius", "3px")]
                        , style [ ("position", "fixid")]
                        ,onClick Increment ] [ text "前進" ]
                  , button [ style [("background-color", "#86f442")]
                        , style [ ("padding", "10px")]
                        , style [ ("border-radius", "3px")] 
                        ,onClick Decrement ] [ text "後退" ]
                  , button [ style [("background-color", "#86f442")]
                        , style [ ("padding", "10px")]
                        , style [ ("border-radius", "3px")]
                        , onClick Turn ] [ text "方向転換" ]
                  , button [ style [("background-color", "#86f442")]
                        , style [ ("padding", "10px")]
                        , style [ ("border-radius", "3px")]
                        , onClick Jump ] [ text "飛ぶ" ]
                  , button [ style [("background-color", "#86f442")]
                        , style [ ("padding", "10px")]
                        , style [ ("border-radius", "3px")]
                        , onClick Reset ] [ text "開始位置" ]
              ]
              ,scene []
                  [ camera [ wasdControlsEnabled False, position 0 model.cameray 8 ] []
                  ,grid
                      [ staticBody
                      , position 0 -2 0
                      ]
                      [] 
                  , assets [] ([] ++ getModels)
                  , entity
                    [ plymodel modelsrc
                    , scale 0.1 0.1 0.1
                    , position model.positx model.posity model.positz
                    , rotation -90 model.direct 0
                    ]
                    []
                  , entity
                    [ plymodel "src: url(./lowpolytree.ply)"
                    , scale 1.2 1.2 1.2
                    , position 0 0 -2
                    , rotation 180 90 180
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
