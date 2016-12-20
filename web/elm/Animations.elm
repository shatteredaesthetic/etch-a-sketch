module Animations exposing (animations)

import Animation exposing (..)
import Time exposing (Time, millisecond)


animations : List (Time -> Animation)
animations =
    [ shake, shake_, shake__, shake___, shake, shake_, shake__, shake___ ]


shake : Time -> Animation
shake t =
    animation t
        |> from 0
        |> to 40
        |> duration (125 * millisecond)


shake_ : Time -> Animation
shake_ t =
    animation t
        |> from 40
        |> to -20
        |> duration (500 * millisecond)


shake__ : Time -> Animation
shake__ t =
    animation t
        |> from -20
        |> to 10
        |> duration (125 * millisecond)


shake___ : Time -> Animation
shake___ t =
    animation t
        |> from 10
        |> to 0
        |> duration (250 * millisecond)
