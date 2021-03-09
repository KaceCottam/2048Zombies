module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Array exposing (Array, length)
import Browser exposing (Document, document)

import Random exposing (generate)

colors : Array String
colors = Array.fromList [ "red", "blue", "green", "yellow", "lightred", "lightblue", "lightgreen" ]

type Model = MainMenu String

init : Model
init = MainMenu "red" 

type Message = RandomizeColor | RandomColor (Maybe String)

update : Message -> Model -> ( Model, Cmd Message )
update message model = case (message, model) of
  (RandomizeColor, MainMenu _) ->
    let
      gen = Random.int 0 (length colors - 1)
      randomInt = generate identity gen
      maybeColor = Cmd.map (RandomColor << (\i -> Array.get i colors)) randomInt
    in ( model, maybeColor )
  (RandomColor (Just color), MainMenu _) -> ( MainMenu color, Cmd.none )
  (RandomColor Nothing, MainMenu _) -> ( MainMenu "white", Cmd.none )

view : Model -> Document Message
view model = case model of
  MainMenu color -> 
    let
      title = "Happy " ++ color ++ " birthday!"
      birthdayButton = button [ onClick RandomizeColor ] [ h1 [] [ text "Happy birthday!" ] ]
      birthdayDiv = div [ style "background-color" color, style "height" "95vh" ] [ birthdayButton ]
      sourceCodeInformation = h2 [ style "background-color" "white", style "height" "5vh" ]
        [ text "Source code hosted at "
        , (\path -> a [ href path ] [ text path ]) "https://github.com/KaceCottam/2048Zombies/"
        ]
    in Document title [ birthdayDiv, sourceCodeInformation ]

main : Program () Model Message
main = document { init = \_ -> ( init, Cmd.none)
                , subscriptions = always Sub.none
                , update = update
                , view = view
                }