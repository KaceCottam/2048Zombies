module BoardTests exposing (..)

import Test exposing (Test, describe, test)
import Expect

import Board exposing (mergeLeft, mergeRight, mergeUp, mergeDown, rotateCCW, rotateCW)
import Tile exposing (Tile(..))

suite : Test
suite =
  describe "The Board module and associated functions"
  [ describe "Board.mergeRight"
    [ test "merge with zombie -> human" <| \_ -> 
        Board.mergeRight [ [ Zombie 1, Human ] ]
          |> Expect.equalLists [ [ Empty, Zombie 1 ] ]
    , test "merge with human -> zombie" <| \_ -> 
        Board.mergeRight [ [ Human, Zombie 1 ] ]
          |> Expect.equalLists [ [ Human, Zombie 1 ] ]
    , test "merge with zombie -> wall" <| \_ -> 
        Board.mergeRight [ [ Zombie 1, Wall ] ]
          |> Expect.equalLists [ [ Zombie 1, Wall ] ]
    , test "merge with human -> wall" <| \_ -> 
        Board.mergeRight [ [ Human, Wall ] ]
          |> Expect.equalLists [ [ Human, Wall ] ]
    , test "merge with zombie -> empty" <| \_ -> 
        Board.mergeRight [ [ Zombie 2, Empty ] ]
          |> Expect.equalLists [ [ Empty, Zombie 1 ] ]
    , test "merge with zombie -> empty death" <| \_ -> 
        Board.mergeRight [ [ Zombie 1, Empty ] ]
          |> Expect.equalLists [ [ Empty, Empty ] ]
    , test "merge with zombie -> zombie" <| \_ -> 
        Board.mergeRight [ [ Zombie 2, Zombie 1 ] ]
          |> Expect.equalLists [ [ Empty, Zombie 3 ] ]
    , test "merge with zombie -> empty -> wall" <| \_ -> 
        Board.mergeRight [ [ Zombie 2, Empty, Wall ] ]
          |> Expect.equalLists [ [ Empty, Zombie 1, Wall ] ]
    , test "merge with zombie -> empty -> wall death" <| \_ -> 
        Board.mergeRight [ [ Zombie 1, Empty, Wall ] ]
          |> Expect.equalLists [ [ Empty, Empty, Wall ] ]
    ]
  , describe "Board.mergeLeft"
    [ test "merge with zombie -> human" <| \_ -> 
        Board.mergeLeft [ [ Human, Zombie 1 ] ]
          |> Expect.equalLists [ [ Zombie 1, Empty ] ]
    , test "merge with human -> zombie" <| \_ -> 
        Board.mergeLeft [ [ Zombie 1, Human ] ]
          |> Expect.equalLists [ [ Zombie 1, Human ] ]
    , test "merge with zombie -> wall" <| \_ -> 
        Board.mergeLeft [ [ Wall, Zombie 1 ] ]
          |> Expect.equalLists [ [ Wall, Zombie 1 ] ]
    , test "merge with human -> wall" <| \_ -> 
        Board.mergeLeft [ [ Wall, Human ] ]
          |> Expect.equalLists [ [ Wall, Human ] ]
    , test "merge with zombie -> empty" <| \_ -> 
        Board.mergeLeft [ [ Empty, Zombie 2 ] ]
          |> Expect.equalLists [ [ Zombie 1, Empty] ]
    , test "merge with zombie -> empty death" <| \_ -> 
        Board.mergeLeft [ [ Empty, Zombie 1 ] ]
          |> Expect.equalLists [ [ Empty, Empty ] ]
    ]
  , describe "Board.rotateCW and Board.rotateCCW"
    [ test "rotateCW" <| \_ ->
      Board.rotateCW [ [ Wall, Empty ], [ Empty, Empty ], [ Empty, Empty ] ]
        |> Expect.equalLists [ [ Empty, Empty, Wall ], [ Empty, Empty, Empty ] ]
    , test "rotateCW 2" <| \_ ->
      Board.rotateCW [ [ Wall, Human ], [ Empty, Human ], [Empty, Human ] ]
        |> Expect.equalLists [ [ Empty, Empty, Wall ], [ Human, Human, Human ] ]
    , test "rotateCCW" <| \_ ->
      Board.rotateCCW [ [ Wall, Empty ], [ Empty, Empty ], [Empty, Empty ] ]
        |> Expect.equalLists [ [ Empty, Empty, Empty ], [ Wall, Empty, Empty ] ]
    , test "rotateCCW 2" <| \_ ->
      Board.rotateCCW [ [ Wall, Human ], [ Empty, Human ], [Empty, Human ] ]
        |> Expect.equalLists [ [ Human, Human, Human ], [ Wall, Empty, Empty ] ]
    ]
  ]