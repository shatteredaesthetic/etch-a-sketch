module View exposing (view)

import Html exposing (..)
import Html.Events exposing (onClick)
import Animation exposing (..)
import Collage exposing (..)
import Element exposing (..)
import Types exposing (..)


view : Model -> Html Msg
view model =
    let
        angle =
            animate model.clock model.animation
    in
        div []
            [ collage 600 600 [ (rotate (degrees angle) (drawLine model)) ]
                |> Element.toHtml
            , div []
                [ shakeBtn
                , div []
                    [ (colorBtn "black")
                    , (colorBtn "red")
                    , (colorBtn "green")
                    , (colorBtn "blue")
                    , (colorBtn "yellow")
                    ]
                ]
            ]


shakeBtn : Html Msg
shakeBtn =
    button [ onClick Shake ] [ Html.text "Shake It Up!" ]


colorBtn : String -> Html Msg
colorBtn label =
    button [ onClick (ChangeColor label) ] [ Html.text label ]


drawLine : Model -> Form
drawLine model =
    let
        intsToFloats ( x, y ) =
            ( toFloat x, toFloat y )

        shape =
            path (List.map intsToFloats model.points)
    in
        shape
            |> traced (solid model.colour)
