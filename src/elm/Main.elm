module Main where

import Html exposing (div, textarea, text, Html)
import Html.Attributes exposing (style, placeholder, class, rows)
import Html.Events exposing (targetValue, on)
import Signal exposing (Address, message)
import StartApp.Simple as StartApp
import String exposing (isEmpty)

import Ishizer exposing (ishizer)

-- MODEL
type alias Model = String
modelDefault : Model
modelDefault = "[ Result Here ]"

model : Model
model = modelDefault

-- UPDATE
type Action = UpdateText String

update : Action -> Model -> Model
update action model =
    case action of
        UpdateText newStr -> ishizer newStr |>
            (\newStr ->
                if isEmpty newStr == True then
                    modelDefault
                else
                    newStr
            )

-- VIEW
view : Address Action -> Model -> Html
view address model =
    div []
        [ textarea [placeholder "Thish is where you type", rows 5, on "input" targetValue (\str -> message address (UpdateText str))] []
        , div [ class "Ishizer__result tac" ] [ text model ]
        ]

main =
    StartApp.start { model = model , update = update, view = view }
