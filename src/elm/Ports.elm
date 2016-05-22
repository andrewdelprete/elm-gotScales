port module Ports exposing (..)

-- Incoming Port
port notesArray : (Chord -> msg) -> Sub msg

-- Outgoing Port
port setNoteType : String -> Cmd msg

-- Outgoing Port
port setNote : String -> Cmd msg
