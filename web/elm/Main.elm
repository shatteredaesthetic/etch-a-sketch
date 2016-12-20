module Main exposing (..)

import Color exposing (..)
import Keyboard.Extra
import Html as App
import Time exposing (Time, millisecond)
import Animation exposing (..)
import AnimationFrame
import Types exposing (..)
import Animations exposing (animations)
import View exposing (view)


main : Program Never Model Msg
main =
    App.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map KeyboardExtraMsg Keyboard.Extra.subscriptions
        , AnimationFrame.diffs Tick
        ]


init : ( Model, Cmd Msg )
init =
    let
        ( keyboardModel, keyboardCmd ) =
            Keyboard.Extra.init
    in
        ( { points = [ ( 0, 0 ) ]
          , x = 0
          , y = 0
          , keyboardModel = keyboardModel
          , clock = 0
          , animation = static 0
          , animations = []
          , colour = black
          }
        , Cmd.map KeyboardExtraMsg keyboardCmd
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        KeyboardExtraMsg keyMsg ->
            let
                ( keyboardModel, keyboardCmd ) =
                    Keyboard.Extra.update keyMsg model.keyboardModel
            in
                ( { model | keyboardModel = keyboardModel }
                , Cmd.map KeyboardExtraMsg keyboardCmd
                )

        Tick dt ->
            handleTick dt model

        Shake ->
            { model | animations = animations } ! []

        ChangeColor colour ->
            let
                colour_ =
                    selectColor colour
            in
                { model | colour = colour_ } ! []


selectColor : String -> Color
selectColor colour =
    case colour of
        "black" ->
            black

        "red" ->
            red

        "blue" ->
            blue

        "yellow" ->
            yellow

        "green" ->
            green

        _ ->
            black


handleTick : Time -> Model -> ( Model, Cmd Msg )
handleTick dt model =
    let
        { x, y } =
            Keyboard.Extra.arrows model.keyboardModel

        x_ =
            model.x + x

        y_ =
            model.y + y

        ( points_, animation_, animations_ ) =
            getNextAnimation model

        newPoints =
            case ( x, y ) of
                ( 0, 0 ) ->
                    points_

                _ ->
                    ( x_, y_ ) :: points_

        model_ =
            { model
                | points = ( x_, y_ ) :: newPoints
                , clock = model.clock + dt
                , animation = animation_
                , animations = animations_
            }
    in
        case ( x, y ) of
            ( 0, 0 ) ->
                model_ ! []

            _ ->
                { model_ | x = x_, y = y_ } ! []


getNextAnimation : Model -> ( List ( Int, Int ), Animation, List (Time -> Animation) )
getNextAnimation model =
    case (isDone model.clock model.animation) of
        True ->
            let
                nextAnimation =
                    case List.head model.animations of
                        Nothing ->
                            static 0

                        Just animation ->
                            animation model.clock

                nextAnimations =
                    Maybe.withDefault [] <| List.tail model.animations

                justFinished =
                    equals nextAnimation (static 0) && not (equals model.animation (static 0))

                nextPoints =
                    case justFinished of
                        True ->
                            []

                        False ->
                            model.points
            in
                ( nextPoints, nextAnimation, nextAnimations )

        False ->
            ( model.points, model.animation, model.animations )
