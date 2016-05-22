port module Main exposing (..)

import Html exposing (..)
import Html.App

import GotScales

-- MAIN

main =
  Html.App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

-- MODEL

type alias Model = GotScales.Model

-- UPDATE

type Msg
    = GotScalesMsg GotScales.Msg

init : (Model, Cmd Msg)
init =
    let
        (newModel, cmd) = (GotScales.init GotScales.initialModel)
    in
        (newModel, Cmd.map GotScalesMsg cmd)

update : Msg -> Model -> (Model, Cmd Msg)
update message model =
    case message of
        GotScalesMsg subMsg ->
            let
                -- Destructure the response from GotScales.update
                -- return (Model, Cmd Msg).
                (updatedModel, cmd) = GotScales.update subMsg model
            in
                -- Then update the cmd returned from GotScales.update
                -- to have be tagged GotScalesMsg.
                (updatedModel, Cmd.map GotScalesMsg cmd)

-- VIEW

view : Model -> Html Msg
view model = Html.App.map GotScalesMsg (GotScales.view model)

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map GotScalesMsg (GotScales.subscriptions model) ]
