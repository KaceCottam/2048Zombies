module Model exposing (..)

import Levels exposing (LevelT)

type Model = MainMenu
           | Rules 
           | Level (LevelT Model Message) 
           | Win Model 
           | Lose Model
           | WinGame 