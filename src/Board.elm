module Board exposing (Board, mergeRight, mergeLeft, mergeUp, mergeDown, rotateCW, rotateCCW, reverse, show)

import List exposing (foldl, map, singleton)
import Tile exposing (Tile(..))
import Html exposing (Html, table, tr, td)
import Html exposing (a)

type alias Board = List (List Tile)

show : Board -> Html msg
show board = 
  let
    convertRows =  map (td [] << singleton << Tile.show)
    convertedBoard = map (tr [] << convertRows) board
  in
    table [] convertedBoard

reverse : Board -> Board
reverse = List.reverse << map List.reverse

mergeRight : Board -> Board
mergeRight = map mergeRightRow

mergeLeft : Board -> Board
mergeLeft = reverse << mergeRight << reverse

mergeUp : Board -> Board
mergeUp = rotateCCW >> mergeLeft >> rotateCW

mergeDown : Board -> Board
mergeDown = rotateCW >> mergeLeft >> rotateCCW

rotateCW : Board -> Board
rotateCW = transpose << List.reverse

rotateCCW : Board -> Board
rotateCCW = List.reverse << transpose

-- TODO: discover a tail-recursive way of doing this
transpose : Board -> Board
transpose = 
  let
    unsafeHead xs = case xs of
      x::_ -> x
      _    -> Empty
    unsafeTail xs = case xs of
      _::rest -> rest
      _       -> []

    transposeImpl acc b = case b of
      []::_ -> acc
      _     -> transposeImpl (map unsafeHead b :: acc) (map unsafeTail b)
  in
    transposeImpl []

mergeRightRow : List Tile -> List Tile
mergeRightRow tiles =
  let
    f : Tile -> List Tile -> List Tile
    f nextTile acc  = case (acc, nextTile) of
      ([], a) -> [a]
      (Wall::xs, a) -> a :: Wall :: xs
      (_, Wall)  -> Wall :: acc
      (Empty::_, a) -> a :: acc
      (Zombie n :: xs, Empty) -> Zombie (n - 1) :: xs
      (Zombie 1 :: xs, a) -> a :: Empty :: xs
      (Zombie n :: xs, Human) -> Zombie n :: Empty :: xs
      (Zombie n1 :: xs, Zombie n2) -> Zombie (n1 + n2) :: Empty :: xs
      (Human::_, Human) -> Human :: acc
      (Human::_, Zombie n) -> Zombie n :: acc
      (a::xs, Empty) -> a :: Empty :: xs
  in
    tiles
      |> List.reverse
      |> foldl f []
      |> List.reverse 
