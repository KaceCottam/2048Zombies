module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing (style, href)
import Html.Events exposing (onClick)
import Array exposing (Array, length)
import Browser exposing (Document, document)

import Random exposing (Seed, initialSeed, generate, int)

colors : Array String
colors = Array.fromList [ "red", "blue", "green", "yellow", "lightred", "lightblue", "lightgreen" ]

type alias MainMenuModel = 
  { color : String
  , seed : Seed
  }

type Model = MainMenu MainMenuModel

init : Model
init = MainMenu { color = "red", seed = initialSeed 42 }

type Message = RandomizeColor | RandomColor (Maybe String)

update : Message -> Model -> ( Model, Cmd Message )
update message model = case (message, model) of
  (RandomizeColor, MainMenu menu) ->
    let
      gen = Random.int 0 (length colors - 1)
      randomInt = Random.generate identity gen
      maybeColor = Cmd.map (RandomColor << (\i -> Array.get i colors)) randomInt
    in ( model, maybeColor )
  (RandomColor (Just color), MainMenu menu) -> ( MainMenu {menu| color=color}, Cmd.none )
  (RandomColor Nothing, MainMenu menu) -> ( MainMenu {menu| color="white"}, Cmd.none )

view : Model -> Document Message
view model = case model of
  MainMenu mainMenu -> 
    let
      title = "Happy " ++ mainMenu.color ++ " birthday!"
      birthdayButton = button [ onClick RandomizeColor ] [ text "Happy birthday!" ]
      birthdayDiv = div [ style "background-color" mainMenu.color, style "height" "95vh" ] [ birthdayButton ]
      sourceCodeInformation = div [ style "height" "5vh" ] [ text "Source code hosted at ", (\path -> a [ href path ] [ text path ]) "https://github.com/KaceCottam/2048Zombies/" ]
    in Document title [ birthdayDiv, sourceCodeInformation ]

main : Program () Model Message
main = document { init = \_ -> ( init, Cmd.none)
                , subscriptions = always Sub.none
                , update = update
                , view = view
                }