module Levels exposing (LevelT, level1, level2)

import Board exposing (Board)
import Tile exposing (Tile(..))

import Html exposing (Html, div, p, text)
import Maybe exposing (Maybe(..))

type alias LevelT model msg =
    { title: String
    , id: Int
    , initialBoard: Board
    , board: Board
    , undoList: List msg
    , additionalHtml: Maybe (Html msg)
    , nextModelOnWin: model
    , nextModelOnLose: model
    }

makeLevel : String -> Int -> Board -> model -> model -> Maybe (Html msg) -> LevelT model msg
makeLevel title id board nextModelWin nextModelLose html =
  { title = title
  , id = id
  , initialBoard = board
  , board = board
  , undoList = []
  , additionalHtml = html
  , nextModelOnWin = nextModelWin
  , nextModelOnLose = nextModelLose
  }

pText : String -> Html msg
pText s = p [] [ text s ] 

level1 : model -> model -> LevelT model msg
level1 win lose = makeLevel "An Introduction" 1
    [ [ Wall, Wall, Wall, Wall, Wall ]
    , [ Wall, Empty, Human, Empty, Wall ]
    , [ Wall, Empty, Empty, Empty, Wall ]
    , [ Wall, Empty, Zombie 2, Empty, Wall ]
    , [ Wall, Wall, Wall, Wall, Wall ]
    ]
    win
    lose
    <| Just <|
    div []
    [ pText "Welcome to 2048Zombies!"
    , pText "You are the zombies. Your goal is to eat all humans."
    , pText "Your name has a number. This is how many squares you can move."
    , pText "Humans will run in the same direction as the zombies."
    , pText "Try to eat some humans by going UP now!"
    ]

level2 : model -> model -> LevelT model msg
level2 win lose = makeLevel "Combinations" 2
    [ [ Wall, Wall, Wall, Wall, Wall, Wall, Wall ]
    , [ Wall, Wall, Wall, Wall, Human, Wall, Wall ]
    , [ Wall, Wall, Wall, Wall, Empty, Wall, Wall ]
    , [ Wall, Wall, Wall, Wall, Empty, Wall, Wall ]
    , [ Wall, Wall, Wall, Wall, Empty, Wall, Wall ]
    , [ Wall, Zombie 4, Empty, Empty, Zombie 2, Wall, Wall ]
    , [ Wall, Wall, Wall, Wall, Wall, Wall, Wall ]
    ]
    win
    lose
    <| Just <|
    div []
    [ pText "Good job, you ate those humans! Here are some more!"
    , pText "You might notice that your zombies can not eat the humans without more moves right now."
    , pText "Try combining your two zombie groups by moving to the RIGHT!"
    ]