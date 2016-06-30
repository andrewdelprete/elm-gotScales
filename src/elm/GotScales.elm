port module GotScales exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)
import Html.App

import String exposing (join)

type alias Note = String
type alias NotePattern = List Note
type alias NotePatternList = List
    {
        name: String,
        notes: NotePattern
    }

type Msg
  = NoOp
  | NoteMsg String
  | NoteListMsg NotePattern
  | ChordListMsg NotePatternList
  | ScaleListMsg NotePatternList
  | NoteTypeMsg String

constants =
    {
        naturalText = "♮ Naturals",
        sharpsAndFlatsText = "♯ Sharps ♭ Flats",
        showNaturals = "SHOW_NATURALS",
        showSharpsAndFlats = "SHOW_SHARPS_AND_FLATS"
    }

-- MAIN

main =
    Html.App.program
        { init = (init initialModel)
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

-- MODEL

initialModel =
    {
        noteType = "SHOW_NATURALS",
        noteList = [],
        scaleList = [{ name = "", notes = [] }],
        chordList = [{ name = "", notes = [] }],
        noteSelected = "C"
    }

type alias Model =
    {
        chordList: NotePatternList,
        noteSelected: Note,
        noteList: NotePattern,
        noteType: String,
        scaleList: NotePatternList
    }

init : Model -> (Model, Cmd Msg)
init model =
    (model, Cmd.none)

-- VIEW

view : Model -> Html Msg
view model =
    section [ class "GotScales" ] [
        noteType model,
        noteSelector model,
        (if model.noteSelected /= "" then scalesAndChordsList model.scaleList "scales" else div [] []),
        (if model.noteSelected /= "" then scalesAndChordsList model.chordList "chords" else div [] [])
    ]

noteType : Model -> Html Msg
noteType model =
    let
        naturalLink =
            if model.noteType == constants.showNaturals then
                span [ class "NoteType__toggle NoteType__toggle--active" ] [ text constants.naturalText ]
            else
                a [ class "NoteType__toggle pointer", onClick (NoteTypeMsg constants.showNaturals) ] [ text constants.naturalText ]

        sharpsAndFlatsLink =
            if model.noteType == constants.showSharpsAndFlats then
                span [ class "NoteType__toggle NoteType__toggle--active" ] [ text constants.sharpsAndFlatsText ]
            else
                a [ class "NoteType__toggle pointer", onClick (NoteTypeMsg constants.showSharpsAndFlats) ] [ text constants.sharpsAndFlatsText ]
    in
        section [ class "NoteType" ] [
            naturalLink,
            span [ class "mh1" ] [ text "•" ],
            sharpsAndFlatsLink
        ]

noteSelector : Model -> Html Msg
noteSelector model =
    let
        classNames = String.join " "
            [
                "NoteSelector__note",
                (if model.noteType == constants.showNaturals then "NoteSelector__note--natural" else "NoteSelector__note--sharpsAndFlats")
            ]
    in
        section
            [ class "NoteSelector" ]
            (List.map (\n -> note NoteMsg classNames "NoteSelector__note--active" (n == model.noteSelected) n) model.noteList)
            -- List.map (note classNames activeClass << (==) model.noteSelected) model.noteList

scalesAndChordsList : NotePatternList -> String -> Html Msg
scalesAndChordsList notePattern heading =
    let
        classNames = String.join " "
            [
                "NoteList__note"
            ]

    in
        section
            [ class "NoteList" ]
            [
                div
                    [ class "NoteList__heading sub-title tac" ]
                    [ text heading ],
                div
                    [ class "NoteList__section tac mb6" ]
                    (List.map (\pattern -> div [] [
                        div [ class "NoteList__subheading ft4 tac mb2" ] [ text pattern.name ],
                        div [ class "NoteList__notes" ] (List.map (note (always NoOp) "NoteList__note dib ph2" "" False) pattern.notes)
                    ]) notePattern)
            ]


note : (Note -> Msg) -> String -> String -> Bool -> Note -> Html Msg
note msg classNames activeClass isActive note =
    let
        classNames = String.join " "
            [
                classNames,
                (if isActive then activeClass else "")
            ]

    in
        a [ class classNames, onClick (msg note) ] [ text note ]

-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        NoteMsg subMsg ->
            ({ model | noteSelected = subMsg }, setNote subMsg)
        NoteTypeMsg subMsg ->
            ({ model | noteType = subMsg, scaleList = [], chordList = [], noteSelected = "" }, setNoteType subMsg)
        NoteListMsg subMsg ->
            ({ model | noteList = subMsg }, Cmd.none)
        ScaleListMsg subMsg ->
            ({ model | scaleList = subMsg }, Cmd.none)
        ChordListMsg subMsg ->
            ({ model | chordList = subMsg }, Cmd.none)
        NoOp ->
            (model, Cmd.none)

-- SUBSCRIPTIONS

port noteList : (NotePattern -> msg) -> Sub msg
port chordList : (NotePatternList -> msg) -> Sub msg
port scaleList : (NotePatternList -> msg) -> Sub msg

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [
            noteList NoteListMsg,
            chordList ChordListMsg,
            scaleList ScaleListMsg
        ]

-- OUTGOING PORTS

port setNoteType : String -> Cmd msg
port setNote : String -> Cmd msg
