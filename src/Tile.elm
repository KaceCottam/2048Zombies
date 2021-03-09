module Tile exposing (Tile(..), show, isEmpty, isHuman, isZombie)

import Html exposing (Html)
import Html.Attributes exposing (style)
import Html exposing (div, text, h2)

type Tile = Empty | Zombie Int | Human | Wall

 -- TODO: eventually replace with icons
show : Tile -> Html msg
show tile = 
  let
    defaultSize = [ style "height" "50px", style "width" "50px"]
    backgroundColor = style "background-color"
    border = style "border"
    centeredText s = h2 [ style "vertical-align" "middle", style "text-align" "center" ] [ text s ]
  in
    case tile of
      Empty    -> div (border "dotted" :: defaultSize) []
      Zombie n -> div (border "solid" :: backgroundColor "lightgreen" :: defaultSize) [ centeredText <| "Z" ++ String.fromInt n ]
      Human    -> div (border "solid" :: backgroundColor "tan" :: defaultSize) [ centeredText "H" ]
      Wall     -> div (border "outset" :: backgroundColor "purple" :: defaultSize) []


isEmpty : Tile -> Bool
isEmpty t = case t of
  Empty -> True
  _     -> False

isHuman : Tile -> Bool
isHuman t = case t of
  Human -> True
  _     -> False

isZombie : Tile -> Bool
isZombie t = case t of
  Zombie _ -> True
  _        -> False