module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Browser exposing (Document, document)
import List exposing (foldr)

import Tile
import Board exposing (Board)
import Levels exposing (..)

import Board
import Board

type Model = MainMenu | Rules | Level (LevelT Model Message) | Win Model | WinGame | Lose

type Direction = Up | Down | Left | Right

type Message = Play | Move Direction | ReturnToMenu | NextLevel Model | Reset Board | Undo

update : Message -> Model -> ( Model, Cmd Message )
update message model =
  let
    bool x y b = if b then x else y 
    checkWin = List.concat >> List.filter Tile.isHuman >> List.length >> (==) 0
    checkLose = List.concat >> List.filter Tile.isZombie >> List.length >> (==) 0
    nextBoard board = bool board.nextModelOnWin (bool board.nextModelOnLose (Level board) (checkLose board.board)) (checkWin board.board)
    playLevels levels = 
      case levels of
        [] -> MainMenu
        (x::xs) -> Level (x (foldr (\level acc -> Win <| Level (level acc Lose) ) (WinGame) xs) Lose)
  in case (message, model) of
    (Play, _)             -> (playLevels [level1, level2], Cmd.none)
    (Reset old, Level b)  -> (Level {b| board = b.initialBoard, undoList = Reset old :: b.undoList}, Cmd.none)
    (Move Up, Level b)    -> (nextBoard {b| board = Board.mergeUp b.board}, Cmd.none)
    (Move Down, Level b)  -> (nextBoard {b| board = Board.mergeDown b.board }, Cmd.none)
    (Move Left, Level b)  -> (nextBoard {b| board = Board.mergeLeft b.board }, Cmd.none)
    (Move Right, Level b) -> (nextBoard {b| board = Board.mergeRight b.board }, Cmd.none)
    (ReturnToMenu, _)     -> (MainMenu, Cmd.none)
    (NextLevel l, _)      -> (l, Cmd.none)
    _                     -> (model, Cmd.none)

view : Model -> Document Message
view model = case model of
  MainMenu ->
    let
      title = "Kace Game"
      titleText = h1 [ style "text-color" "green" ] [ text "2048 Zombies" ]
      playButton = button [ onClick Play ] [ h1 [] [ text "Play game!" ] ]
      rulesButton = button [ onClick <| NextLevel Rules ] [ h1 [] [ text "Rules and Explanation" ] ]
    in Document title [ titleText, playButton, rulesButton ]

  Rules ->
    let
      title = "2048 Zombies - Rules"
      content = 
        [ p [] [ text "2048 Zombies is a puzzle game where the player controls zombies so that they can eat humans." ]
        , p [] [ text "Every movement the zombies do, the humans will also do." ]
        , br [] []
        , p [] [ text "Walls are purple: they cannot be surpassed by either humans or zombies." ]
        , p [] [ text "Humans are tan with an 'H': they can be eaten by zombies to give zombies +1 movement." ]
        , p [] [ text "Zombies are green with a 'Z' and a number in their name: This number is the amount of spaces they are allowed to move before decaying." ]
        , br [] []
        , p [] [ text "You can win if all the humans are eaten, but you lose if all the zombies decay." ]
        ]

    in Document title
      [ h1 [] [ text "Rules" ]
      , hr [] []
      , div [] content
      , button [onClick ReturnToMenu] [ text "Return to Main Menu" ]
      ]

  Level board ->
    let
      title = "Kace Game - Level 1"
    in Document title
      [ h1 [] [ text <| "Level " ++ String.fromInt board.id ++ ": " ++ board.title ]
      , Board.show board.board
      , button [ onClick <| Move Up ] [ text "Up" ] 
      , button [ onClick <| Move Down ] [ text "Down" ] 
      , button [ onClick <| Move Left ] [ text "Left" ] 
      , button [ onClick <| Move Right ] [ text "Right" ] 
      , button [ onClick Play ] [ text "Reset" ] 
      , button [ onClick ReturnToMenu ] [ text "Return to main menu" ] 
      , case board.additionalHtml of
        Just html -> html
        Nothing -> div [] []
      ]
  Win nextGame -> Document "Kace Game - Winner!"
    [ h1 [] [ text "You win!" ]
    , button [onClick ReturnToMenu] [ text "Return to Main Menu" ]
    , button [onClick <| NextLevel nextGame ] [ text "Next Level" ]
    ]

  WinGame -> Document "Kace Game - Winner!" [ h1 [] [ text "Thanks for playing!" ], button [onClick ReturnToMenu] [ text "Return to Main Menu" ] ]
  Lose -> Document "Kace Game - Loser!" [ h1 [] [ text "You lose!" ], button [onClick ReturnToMenu] [ text "Return to Main Menu" ] ]

main : Program () Model Message
main = document { init = \_ -> ( MainMenu, Cmd.none )
                , subscriptions = always Sub.none
                , update = update
                , view = view
                }