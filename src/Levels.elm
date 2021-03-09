module Levels exposing (..)

import Board exposing (Board)
import Tile exposing (Tile(..))

level1 : Board
level1 = [ [ Wall, Wall, Wall, Wall, Wall ]
         , [ Wall, Empty, Human, Empty, Wall ]
         , [ Wall, Empty, Empty, Empty, Wall ]
         , [ Wall, Empty, Zombie 2, Empty, Wall ]
         , [ Wall, Wall, Wall, Wall, Wall ] ]