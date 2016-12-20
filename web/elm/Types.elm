module Types exposing (..)

import Time exposing (Time)
import Animation exposing (Animation)
import Color exposing (Color)
import Keyboard.Extra as KE


type alias Model =
    { points : List Point
    , x : Int
    , y : Int
    , keyboardModel : KE.Model
    , clock : Time
    , animation : Animation
    , animations : List (Time -> Animation)
    , colour : Color
    }


type alias Point =
    ( Int, Int )


type Msg
    = KeyboardExtraMsg KE.Msg
    | Tick Time
    | Shake
    | ChangeColor String
