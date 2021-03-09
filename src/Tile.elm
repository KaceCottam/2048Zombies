module Tile exposing (Tile(..), show, isEmpty)

import Html exposing (Html)
import Html.Attributes exposing (style)
import Html exposing (div, text)

type Tile = Empty | Zombie Int | Human | Wall

 -- TODO: eventually replace with icons
show : Tile -> Html msg
show tile = 
  let
    defaultSize = [ style "height" "10px", style "width" "10px"]
    backgroundColor = style "background-color"
    border = style "border"
  in
    case tile of
      Empty    -> div (border "dotted" :: defaultSize) []
      Zombie n -> div (border "solid" :: backgroundColor "green" :: defaultSize) [ text <| "Z" ++ String.fromInt n ]
      Human    -> div (border "solid" :: backgroundColor "tan" :: defaultSize) [ text "H" ] 
      Wall     -> div (border "outset" :: backgroundColor "brown" :: defaultSize) []


isEmpty : Tile -> Bool
isEmpty t = case t of
  Empty -> True
  _     -> False